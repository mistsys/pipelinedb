/*-------------------------------------------------------------------------
 *
 * cont_plan.h
 * 		Interface for generating/modifying CQ plans
 *
 * Copyright (c) 2013-2015, PipelineDB
 *
 * IDENTIFICATION
 *	  src/include/pipeline/cont_plan.h
 *
 */
#ifndef CONT_PLAN_H
#define CONT_PLAN_H

#include "executor/execdesc.h"
#include "nodes/execnodes.h"
#include "nodes/plannodes.h"
#include "nodes/relation.h"
#include "pipeline/cont_scheduler.h"
#include "utils/resowner.h"
#include "utils/tuplestore.h"

#define IS_STREAM_RTE(relid, root) ((planner_rt_fetch(relid, root)) && \
	((planner_rt_fetch(relid, root))->rtekind == RTE_STREAM))
#define IS_STREAM_TREE(plan) (IsA((plan), StreamScan) || \
		IsA((plan), StreamTableJoin))

extern PlannedStmt *GetContPlan(ContinuousView *view, ContQueryProcType type);
extern TuplestoreScan *SetCombinerPlanTuplestorestate(PlannedStmt *plan, Tuplestorestate *tupstore);
extern FuncExpr *GetGroupHashIndexExpr(int group_len, ResultRelInfo *ri);
extern PlannedStmt *GetCombinerLookupPlan(ContinuousView *view);
extern PlannedStmt *GetContinuousViewOverlayPlan(ContinuousView *view);

extern void SetTupleBufferBatchReader(PlanState *planstate, TupleBufferBatchReader *reader);
extern EState *CreateEState(QueryDesc *query_desc);
extern void SetEStateSnapshot(EState *estate, ResourceOwner owner);
extern void UnsetEStateSnapshot(EState *estate, ResourceOwner owner);

#endif
