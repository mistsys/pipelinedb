/*-------------------------------------------------------------------------
 *
 * cont_worker.c
 *
 * Copyright (c) 2013-2015, PipelineDB
 *
 * IDENTIFICATION
 *    src/include/pipeline/cont_worker.c
 *
 *-------------------------------------------------------------------------
 */

#include "postgres.h"

#include "access/htup_details.h"
#include "access/xact.h"
#include "catalog/pipeline_query.h"
#include "catalog/pipeline_query_fn.h"
#include "executor/execdesc.h"
#include "executor/executor.h"
#include "miscadmin.h"
#include "pgstat.h"
#include "pipeline/combinerReceiver.h"
#include "pipeline/cont_plan.h"
#include "pipeline/cont_scheduler.h"
#include "pipeline/cqmatrel.h"
#include "pipeline/tuplebuf.h"
#include "utils/builtins.h"
#include "utils/hsearch.h"
#include "utils/memutils.h"
#include "utils/resowner.h"
#include "utils/snapmgr.h"
#include "utils/syscache.h"
#include "tcop/dest.h"
#include "tcop/tcopprot.h"

static bool
should_read_fn(TupleBufferReader *reader, TupleBufferSlot *slot)
{
	return slot->id % continuous_query_num_workers == reader->proc->group_id;
}

typedef struct {
	Oid view_id;
	ContinuousView *view;
	DestReceiver *dest;
	QueryDesc *query_desc;
	MemoryContext state_cxt;
	MemoryContext tmp_cxt;
	CQStatEntry stats;
	AttrNumber *groupatts;
	FuncExpr *hashfunc;
} ContQueryWorkerState;

static void
init_query_state(ContQueryWorkerState *state, Oid id, MemoryContext context, ResourceOwner owner, TupleBufferBatchReader *reader)
{
	PlannedStmt *pstmt;
	MemoryContext state_cxt;
	MemoryContext old_cxt;

	MemSet(state, 0, sizeof(ContQueryWorkerState));

	state_cxt = AllocSetContextCreate(context, "WorkerQueryStateCxt",
			ALLOCSET_DEFAULT_MINSIZE,
			ALLOCSET_DEFAULT_INITSIZE,
			ALLOCSET_DEFAULT_MAXSIZE);

	old_cxt = MemoryContextSwitchTo(state_cxt);

	state->view_id = id;
	state->state_cxt = state_cxt;
	state->view = GetContinuousView(id);
	state->tmp_cxt = AllocSetContextCreate(state_cxt, "WorkerQueryTmpCxt",
			ALLOCSET_DEFAULT_MINSIZE,
			ALLOCSET_DEFAULT_INITSIZE,
			ALLOCSET_DEFAULT_MAXSIZE);

	if (state->view == NULL)
		return;

	state->dest = CreateDestReceiver(DestCombiner);

	SetCombinerDestReceiverParams(state->dest, reader, id);

	pstmt = GetContPlan(state->view, Worker);
	state->query_desc = CreateQueryDesc(pstmt, NULL, InvalidSnapshot, InvalidSnapshot, state->dest, NULL, 0);
	state->query_desc->snapshot = GetTransactionSnapshot();
	state->query_desc->snapshot->copied = true;

	RegisterSnapshotOnOwner(state->query_desc->snapshot, owner);

	ExecutorStart(state->query_desc, EXEC_NO_STREAM_LOCKING);

	state->query_desc->snapshot->active_count++;
	UnregisterSnapshotFromOwner(state->query_desc->snapshot, owner);
	UnregisterSnapshotFromOwner(state->query_desc->estate->es_snapshot, owner);
	state->query_desc->snapshot = NULL;

	if (IsA(state->query_desc->plannedstmt->planTree, Agg))
	{
		Agg *agg = (Agg *) state->query_desc->plannedstmt->planTree;
		Relation matrel;
		ResultRelInfo *ri;

		state->groupatts = agg->grpColIdx;

		matrel = heap_openrv_extended(state->view->matrel, NoLock, true);

		if (matrel == NULL)
		{
			state->view = NULL;
			return;
		}

		ri = CQMatRelOpen(matrel);

		if (agg->numCols)
		{
			FuncExpr *hash = GetGroupHashIndexExpr(agg->numCols, ri);
			if (hash == NULL)
			{
				/* matrel has been dropped */
				state->view = NULL;
				CQMatRelClose(ri);
				heap_close(matrel, NoLock);
				return;
			}

			SetCombinerDestReceiverHashFunc(state->dest, hash, CurrentMemoryContext);
		}

		CQMatRelClose(ri);
		heap_close(matrel, NoLock);
	}

	SetTupleBufferBatchReader(state->query_desc->planstate, reader);

	state->query_desc->estate->es_lastoid = InvalidOid;

	(*state->dest->rStartup) (state->dest, state->query_desc->operation, state->query_desc->tupDesc);

	cq_stat_init(&state->stats, state->view->id, 0);

	/*
	 * The main loop initializes and ends plans across plan executions, so it expects
	 * the plan to be uninitialized
	 */
	ExecEndNode(state->query_desc->planstate);
	FreeExecutorState(state->query_desc->estate);

	MemoryContextSwitchTo(old_cxt);
}

static void
cleanup_query_state(ContQueryWorkerState **states, Oid id)
{
	ContQueryWorkerState *state = states[id];

	if (state == NULL)
		return;

	MemoryContextDelete(state->state_cxt);
	pfree(state);
	states[id] = NULL;
}

static ContQueryWorkerState **
init_query_states_array(MemoryContext context)
{
	MemoryContext old_cxt = MemoryContextSwitchTo(context);
	ContQueryWorkerState **states = palloc0(MAXALIGN(mul_size(sizeof(ContQueryWorkerState *), MAX_CQS)));
	MemoryContextSwitchTo(old_cxt);

	return states;
}

static ContQueryWorkerState *
get_query_state(ContQueryWorkerState **states, Oid id, MemoryContext context, ResourceOwner owner, TupleBufferBatchReader *reader)
{
	ContQueryWorkerState *state = states[id];
	HeapTuple tuple;
	ResourceOwner old_owner;

	MyCQStats = NULL;

	/* Entry missing? Start a new transaction so we read the latest pipeline_query catalog. */
	if (state == NULL)
	{
		CommitTransactionCommand();
		StartTransactionCommand();
	}

	old_owner = CurrentResourceOwner;
	CurrentResourceOwner = owner;

	PushActiveSnapshot(GetTransactionSnapshot());

	tuple = SearchSysCache1(PIPELINEQUERYID, Int32GetDatum(id));

	/* Was the continuous view removed? */
	if (!HeapTupleIsValid(tuple))
	{
		PopActiveSnapshot();
		cleanup_query_state(states, id);
		return NULL;
	}

	if (state != NULL)
	{
		/* Was the continuous view modified? In our case this means remove the old view and add a new one */
		Form_pipeline_query row = (Form_pipeline_query) GETSTRUCT(tuple);
		if (row->hash != state->view->hash)
		{
			cleanup_query_state(states, id);
			state = NULL;
		}
	}

	ReleaseSysCache(tuple);

	if (state == NULL)
	{
		MemoryContext old_cxt = MemoryContextSwitchTo(context);
		state = palloc0(sizeof(ContQueryWorkerState));
		init_query_state(state, id, context, owner, reader);
		states[id] = state;
		MemoryContextSwitchTo(old_cxt);

		if (state->view == NULL)
		{
			PopActiveSnapshot();
			cleanup_query_state(states, id);
			return NULL;
		}
	}

	PopActiveSnapshot();

	CurrentResourceOwner = old_owner;

	MyCQStats = &state->stats;

	return state;
}

static bool
has_queries_to_process(Bitmapset *queries)
{
	return !bms_is_empty(queries);
}

void
ContinuousQueryWorkerMain(void)
{
	TupleBufferBatchReader *reader;
	ResourceOwner owner = ResourceOwnerCreate(NULL, "WorkerResourceOwner");
	MemoryContext run_cxt = AllocSetContextCreate(TopMemoryContext, "WorkerRunCxt",
			ALLOCSET_DEFAULT_MINSIZE,
			ALLOCSET_DEFAULT_INITSIZE,
			ALLOCSET_DEFAULT_MAXSIZE);
	ContQueryWorkerState **states = init_query_states_array(run_cxt);
	ContQueryWorkerState *state = NULL;
	Bitmapset *queries;
	TimestampTz last_processed = GetCurrentTimestamp();
	bool has_queries;
	int id;

	/* Workers never perform any writes, so only need read only transactions. */
	XactReadOnly = true;

	ContQueryBatchContext = AllocSetContextCreate(run_cxt, "ContQueryBatchContext",
			ALLOCSET_DEFAULT_MINSIZE,
			ALLOCSET_DEFAULT_INITSIZE,
			ALLOCSET_DEFAULT_MAXSIZE);

	reader = TupleBufferOpenBatchReader(WorkerTupleBuffer, &should_read_fn, ContQueryBatchContext);

	/* Bootstrap the query ids we should process. */
	StartTransactionCommand();
	MemoryContextSwitchTo(run_cxt);
	queries = GetAllContinuousViewIds();
	CommitTransactionCommand();

	has_queries = has_queries_to_process(queries);

	MemoryContextSwitchTo(run_cxt);

	for (;;)
	{
		uint32 num_processed = 0;
		Bitmapset *tmp;
		bool updated_queries = false;

		TupleBufferBatchReaderTrySleep(reader, last_processed);

		if (MyContQueryProc->group->terminate)
			break;

		/* If we had no queries, then rescan the catalog. */
		if (!has_queries)
		{
			Bitmapset *new, *removed;

			StartTransactionCommand();
			MemoryContextSwitchTo(run_cxt);
			new = GetAllContinuousViewIds();
			CommitTransactionCommand();

			removed = bms_difference(queries, new);
			bms_free(queries);
			queries = new;

			while ((id = bms_first_member(removed)) >= 0)
				cleanup_query_state(states, id);

			bms_free(removed);

			has_queries = has_queries_to_process(queries);
		}

		StartTransactionCommand();

		MemoryContextSwitchTo(ContQueryBatchContext);

		tmp = bms_copy(queries);
		while ((id = bms_first_member(tmp)) >= 0)
		{
			Plan *plan = NULL;
			EState *estate = NULL;

			PG_TRY();
			{
				state = get_query_state(states, id, run_cxt, owner, reader);

				if (state == NULL)
				{
					queries = bms_del_member(queries, id);
					has_queries = has_queries_to_process(queries);
					goto next;
				}

				CHECK_FOR_INTERRUPTS();

				/* No need to process queries which we don't have tuples for. */
				if (!TupleBufferBatchReaderHasTuplesForCQId(reader, id))
					goto next;

				debug_query_string = NameStr(state->view->name);
				MemoryContextSwitchTo(state->tmp_cxt);
				state->query_desc->estate = estate = CreateEState(state->query_desc);

				TupleBufferBatchReaderSetCQId(reader, id);

				SetEStateSnapshot(estate);
				CurrentResourceOwner = owner;

				/* initialize the plan for execution within this xact */
				plan = state->query_desc->plannedstmt->planTree;
				state->query_desc->planstate = ExecInitNode(plan, state->query_desc->estate, EXEC_NO_STREAM_LOCKING);
				SetTupleBufferBatchReader(state->query_desc->planstate, reader);

				/*
				 * We pass a timeout of 0 because the underlying TupleBufferBatchReader takes care of
				 * waiting for enough to read tuples from the TupleBuffer.
				 */
				ExecutePlan(estate, state->query_desc->planstate, state->query_desc->operation,
						true, 0, 0, ForwardScanDirection, state->dest);

				/* free up any resources used by this plan before committing */
				ExecEndNode(state->query_desc->planstate);
				state->query_desc->planstate = NULL;

				num_processed += estate->es_processed + estate->es_filtered;

				MemoryContextResetAndDeleteChildren(state->tmp_cxt);
				MemoryContextSwitchTo(state->state_cxt);

				UnsetEStateSnapshot(estate);
				state->query_desc->estate = estate = NULL;

				IncrementCQExecutions(1);
			}
			PG_CATCH();
			{
				EmitErrorReport();
				FlushErrorState();

				if (estate && ActiveSnapshotSet())
					UnsetEStateSnapshot(estate);

				if (state)
					cleanup_query_state(states, id);

				IncrementCQErrors(1);

				if (!continuous_query_crash_recovery)
					exit(1);

				AbortCurrentTransaction();
				StartTransactionCommand();

				MemoryContextSwitchTo(ContQueryBatchContext);
			}
			PG_END_TRY();

next:
			TupleBufferBatchReaderRewind(reader);

			/* after reading a full batch, update query bitset with any new queries seen */
			if (reader->batch_done && !updated_queries)
			{
				Bitmapset *new;

				updated_queries = true;

				new = bms_difference(reader->queries_seen, queries);

				if (!bms_is_empty(new))
				{
					MemoryContextSwitchTo(ContQueryBatchContext);
					tmp = bms_add_members(tmp, new);

					MemoryContextSwitchTo(run_cxt);
					queries = bms_add_members(queries, new);

					has_queries = has_queries_to_process(queries);
				}

				bms_free(new);
			}

			if (state)
				cq_stat_report(false);
			else
				cq_stat_send_purge(id, 0, CQ_STAT_WORKER);

			debug_query_string = NULL;
		}

		CommitTransactionCommand();

		if (num_processed)
			last_processed = GetCurrentTimestamp();

		TupleBufferBatchReaderReset(reader);
		MemoryContextResetAndDeleteChildren(ContQueryBatchContext);
	}

	StartTransactionCommand();

	for (id = 0; id < MAX_CQS; id++)
	{
		ContQueryWorkerState *state = states[id];
		QueryDesc *query_desc;
		EState *estate;

		if (state == NULL)
			continue;

		/*
		 * We wrap this in a separate try/catch block because ExecInitNode call can potentially throw
		 * an error if the state was for a stream-table join and the table has been dropped.
		 */
		PG_TRY();
		{
			query_desc = state->query_desc;
			estate = query_desc->estate;

			(*state->dest->rShutdown) (state->dest);

			if (estate == NULL)
				query_desc->estate = estate = CreateEState(state->query_desc);

			/* The cleanup functions below expect these things to be registered. */
			RegisterSnapshotOnOwner(estate->es_snapshot, owner);
			RegisterSnapshotOnOwner(query_desc->snapshot, owner);

			CurrentResourceOwner = owner;

			if (query_desc->totaltime)
				InstrStopNode(query_desc->totaltime, estate->es_processed);

			if (query_desc->planstate == NULL)
				query_desc->planstate = ExecInitNode(query_desc->plannedstmt->planTree, state->query_desc->estate, EXEC_NO_STREAM_LOCKING);

			/* Clean up. */
			ExecutorFinish(query_desc);
			ExecutorEnd(query_desc);
			FreeQueryDesc(query_desc);

			MyCQStats = &state->stats;
			cq_stat_report(true);
		}
		PG_CATCH();
		{
			/*
			 * If this happens, it almost certainly means that a stream or table has been dropped
			 * and no longer exists, even though the ended plan may have references to them. We're
			 * not doing anything particularly critical in the above TRY block, so just consume these
			 * harmless errors.
			 */
			FlushErrorState();
		}
		PG_END_TRY();
	}

	CommitTransactionCommand();

	TupleBufferCloseBatchReader(reader);
	pfree(states);
	MemoryContextSwitchTo(TopMemoryContext);
	MemoryContextDelete(run_cxt);
}
