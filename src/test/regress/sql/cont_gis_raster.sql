-- ST_SummaryStatsAgg(raster, integer, boolean)
-- ST_SummaryStatsAgg(raster, boolean, double)
-- ST_SummaryStatsAgg(raster, integer, boolean, double)
CREATE CONTINUOUS VIEW test_st_stats_agg1 AS SELECT ST_SummaryStatsAgg(r::raster, 1, true) FROM test_gis_raster_stream;
CREATE CONTINUOUS VIEW test_st_stats_agg2 AS SELECT ST_SummaryStatsAgg(r::raster, true, 1.0) FROM test_gis_raster_stream;
CREATE CONTINUOUS VIEW test_st_stats_agg0 AS SELECT ST_SummaryStatsAgg(r::raster, 1, true, 1.0) FROM test_gis_raster_stream ;
CREATE CONTINUOUS VIEW test_sw_st_stats_agg1 AS SELECT ST_SummaryStatsAgg(r::raster, 1, true) FROM test_gis_raster_stream WHERE (arrival_timestamp > clock_timestamp() - interval '1 hour');
CREATE CONTINUOUS VIEW test_sw_st_stats_agg2 AS SELECT ST_SummaryStatsAgg(r::raster, true, 1.0) FROM test_gis_raster_stream WHERE (arrival_timestamp > clock_timestamp() - interval '1 hour');
CREATE CONTINUOUS VIEW test_sw_st_stats_agg0 AS SELECT ST_SummaryStatsAgg(r::raster, 1, true, 1.0) FROM test_gis_raster_stream WHERE (arrival_timestamp > clock_timestamp() - interval '1 hour');

-- ST_CountAgg(raster, boolean)
-- ST_CountAgg(raster, integer, boolean)
-- ST_CountAgg(raster, integer, boolean, double)
CREATE CONTINUOUS VIEW test_st_countagg0 AS SELECT ST_CountAgg(r::raster, true) FROM test_gis_raster_stream;
CREATE CONTINUOUS VIEW test_st_countagg1 AS SELECT ST_CountAgg(r::raster, 1, true) FROM test_gis_raster_stream;
CREATE CONTINUOUS VIEW test_st_countagg2 AS SELECT ST_CountAgg(r::raster, 1, true, 0.0) FROM test_gis_raster_stream;
CREATE CONTINUOUS VIEW test_sw_st_countagg0 AS SELECT ST_CountAgg(r::raster, true) FROM test_gis_raster_stream WHERE (arrival_timestamp > clock_timestamp() - interval '1 hour');
CREATE CONTINUOUS VIEW test_sw_st_countagg1 AS SELECT ST_CountAgg(r::raster, 1, true) FROM test_gis_raster_stream WHERE (arrival_timestamp > clock_timestamp() - interval '1 hour');
CREATE CONTINUOUS VIEW test_sw_st_countagg2 AS SELECT ST_CountAgg(r::raster, 1, true, 0.0) FROM test_gis_raster_stream WHERE (arrival_timestamp > clock_timestamp() - interval '1 hour');

-- ST_SameAlignment(raster)
CREATE CONTINUOUS VIEW test_st_samealignment AS SELECT ST_SameAlignment(r::raster) FROM test_gis_raster_stream;
CREATE CONTINUOUS VIEW test_sw_st_samealignment AS SELECT ST_SameAlignment(r::raster) FROM test_gis_raster_stream WHERE (arrival_timestamp > clock_timestamp() - interval '1 hour');

-- ST_Union(raster)
-- ST_Union(raster, integer)
-- ST_Union(raster, text)
-- ST_Union(raster, integer, text)
CREATE CONTINUOUS VIEW test_st_union_raster0 AS SELECT Box3D(ST_Union(r::raster)) FROM test_gis_raster_stream;
CREATE CONTINUOUS VIEW test_st_union_raster1 AS SELECT Box3D(ST_Union(r::raster, 1)) FROM test_gis_raster_stream;
CREATE CONTINUOUS VIEW test_st_union_raster2 AS SELECT Box3D(ST_Union(r::raster, 'COUNT')) FROM test_gis_raster_stream;
CREATE CONTINUOUS VIEW test_st_union_raster3 AS SELECT Box3D(ST_Union(r::raster, 1, 'SUM')) FROM test_gis_raster_stream;
CREATE CONTINUOUS VIEW test_sw_st_union_raster0 AS SELECT Box3D(ST_Union(r::raster)) FROM test_gis_raster_stream WHERE (arrival_timestamp > clock_timestamp() - interval '1 hour');
CREATE CONTINUOUS VIEW test_sw_st_union_raster1 AS SELECT Box3D(ST_Union(r::raster, 1)) FROM test_gis_raster_stream WHERE (arrival_timestamp > clock_timestamp() - interval '1 hour');
CREATE CONTINUOUS VIEW test_sw_st_union_raster2 AS SELECT Box3D(ST_Union(r::raster, 'COUNT')) FROM test_gis_raster_stream WHERE (arrival_timestamp > clock_timestamp() - interval '1 hour');
CREATE CONTINUOUS VIEW test_sw_st_union_raster3 AS SELECT Box3D(ST_Union(r::raster, 1, 'SUM')) FROM test_gis_raster_stream WHERE (arrival_timestamp > clock_timestamp() - interval '1 hour');

INSERT INTO test_gis_raster_stream (id, r) VALUES (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(21, 75, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.502));
INSERT INTO test_gis_raster_stream (id, r) VALUES (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(93, 58, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.153));
INSERT INTO test_gis_raster_stream (id, r) VALUES (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(48, 62, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.196));
INSERT INTO test_gis_raster_stream (id, r) VALUES (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(86, 74, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.803));
INSERT INTO test_gis_raster_stream (id, r) VALUES (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(82, 49, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.654));
INSERT INTO test_gis_raster_stream (id, r) VALUES (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(12, 4, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.173));
INSERT INTO test_gis_raster_stream (id, r) VALUES (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(33, 29, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.780));
INSERT INTO test_gis_raster_stream (id, r) VALUES (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(31, 3, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.038));
INSERT INTO test_gis_raster_stream (id, r) VALUES (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(47, 17, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.551));
INSERT INTO test_gis_raster_stream (id, r) VALUES (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(66, 90, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.638));
INSERT INTO test_gis_raster_stream (id, r) VALUES (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(67, 72, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.278));
INSERT INTO test_gis_raster_stream (id, r) VALUES (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(68, 66, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.884));
INSERT INTO test_gis_raster_stream (id, r) VALUES (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(65, 96, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.327));
INSERT INTO test_gis_raster_stream (id, r) VALUES (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(40, 80, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.125));
INSERT INTO test_gis_raster_stream (id, r) VALUES (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(80, 28, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.025));
INSERT INTO test_gis_raster_stream (id, r) VALUES (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(51, 19, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.250));
INSERT INTO test_gis_raster_stream (id, r) VALUES (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(81, 91, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.271));
INSERT INTO test_gis_raster_stream (id, r) VALUES (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(17, 82, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.375));
INSERT INTO test_gis_raster_stream (id, r) VALUES (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(69, 12, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.651));
INSERT INTO test_gis_raster_stream (id, r) VALUES (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(89, 36, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.787));
INSERT INTO test_gis_raster_stream (id, r) VALUES (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(21, 55, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.400));
INSERT INTO test_gis_raster_stream (id, r) VALUES (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(33, 35, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.030));
INSERT INTO test_gis_raster_stream (id, r) VALUES (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(18, 33, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.518));
INSERT INTO test_gis_raster_stream (id, r) VALUES (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(18, 64, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.222));
INSERT INTO test_gis_raster_stream (id, r) VALUES (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(88, 22, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.184));
INSERT INTO test_gis_raster_stream (id, r) VALUES (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(4, 74, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.492));
INSERT INTO test_gis_raster_stream (id, r) VALUES (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(92, 62, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.060));
INSERT INTO test_gis_raster_stream (id, r) VALUES (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(36, 64, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.907));
INSERT INTO test_gis_raster_stream (id, r) VALUES (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(8, 6, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.023));
INSERT INTO test_gis_raster_stream (id, r) VALUES (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(62, 49, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.739));
INSERT INTO test_gis_raster_stream (id, r) VALUES (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(92, 48, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.732));
INSERT INTO test_gis_raster_stream (id, r) VALUES (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(25, 82, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.211));
INSERT INTO test_gis_raster_stream (id, r) VALUES (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(1, 41, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.194));
INSERT INTO test_gis_raster_stream (id, r) VALUES (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(37, 9, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.090));
INSERT INTO test_gis_raster_stream (id, r) VALUES (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(31, 67, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.008));
INSERT INTO test_gis_raster_stream (id, r) VALUES (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(62, 85, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.946));
INSERT INTO test_gis_raster_stream (id, r) VALUES (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(18, 65, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.223));
INSERT INTO test_gis_raster_stream (id, r) VALUES (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(18, 86, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.751));
INSERT INTO test_gis_raster_stream (id, r) VALUES (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(23, 48, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.464));
INSERT INTO test_gis_raster_stream (id, r) VALUES (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(98, 12, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.990));
INSERT INTO test_gis_raster_stream (id, r) VALUES (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(12, 83, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.355));
INSERT INTO test_gis_raster_stream (id, r) VALUES (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(81, 48, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.689));
INSERT INTO test_gis_raster_stream (id, r) VALUES (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(71, 15, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.299));
INSERT INTO test_gis_raster_stream (id, r) VALUES (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(14, 9, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.134));
INSERT INTO test_gis_raster_stream (id, r) VALUES (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(37, 48, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.287));
INSERT INTO test_gis_raster_stream (id, r) VALUES (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(29, 12, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.024));
INSERT INTO test_gis_raster_stream (id, r) VALUES (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(88, 99, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.944));
INSERT INTO test_gis_raster_stream (id, r) VALUES (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(96, 36, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.069));
INSERT INTO test_gis_raster_stream (id, r) VALUES (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(20, 94, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.125));
INSERT INTO test_gis_raster_stream (id, r) VALUES (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(84, 94, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.871));
INSERT INTO test_gis_raster_stream (id, r) VALUES (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(44, 6, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.948));
INSERT INTO test_gis_raster_stream (id, r) VALUES (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(11, 15, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.078));
INSERT INTO test_gis_raster_stream (id, r) VALUES (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(20, 39, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.812));
INSERT INTO test_gis_raster_stream (id, r) VALUES (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(13, 84, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.820));
INSERT INTO test_gis_raster_stream (id, r) VALUES (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(80, 90, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.455));
INSERT INTO test_gis_raster_stream (id, r) VALUES (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(75, 53, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.163));
INSERT INTO test_gis_raster_stream (id, r) VALUES (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(80, 11, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.848));
INSERT INTO test_gis_raster_stream (id, r) VALUES (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(28, 88, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.591));
INSERT INTO test_gis_raster_stream (id, r) VALUES (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(7, 7, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.667));
INSERT INTO test_gis_raster_stream (id, r) VALUES (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(87, 82, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.746));
INSERT INTO test_gis_raster_stream (id, r) VALUES (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(34, 60, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.187));
INSERT INTO test_gis_raster_stream (id, r) VALUES (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(31, 36, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.365));
INSERT INTO test_gis_raster_stream (id, r) VALUES (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(21, 74, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.623));
INSERT INTO test_gis_raster_stream (id, r) VALUES (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(75, 25, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.333));
INSERT INTO test_gis_raster_stream (id, r) VALUES (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(100, 34, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.185));
INSERT INTO test_gis_raster_stream (id, r) VALUES (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(76, 21, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.424));
INSERT INTO test_gis_raster_stream (id, r) VALUES (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(75, 67, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.645));
INSERT INTO test_gis_raster_stream (id, r) VALUES (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(66, 57, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.545));
INSERT INTO test_gis_raster_stream (id, r) VALUES (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(57, 49, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.844));
INSERT INTO test_gis_raster_stream (id, r) VALUES (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(12, 98, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.584));
INSERT INTO test_gis_raster_stream (id, r) VALUES (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(47, 85, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.946));
INSERT INTO test_gis_raster_stream (id, r) VALUES (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(68, 64, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.891));
INSERT INTO test_gis_raster_stream (id, r) VALUES (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(88, 39, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.560));
INSERT INTO test_gis_raster_stream (id, r) VALUES (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(58, 19, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.456));
INSERT INTO test_gis_raster_stream (id, r) VALUES (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(79, 71, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.993));
INSERT INTO test_gis_raster_stream (id, r) VALUES (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(72, 20, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.480));
INSERT INTO test_gis_raster_stream (id, r) VALUES (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(45, 97, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.842));
INSERT INTO test_gis_raster_stream (id, r) VALUES (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(89, 62, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.700));
INSERT INTO test_gis_raster_stream (id, r) VALUES (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(91, 91, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.039));
INSERT INTO test_gis_raster_stream (id, r) VALUES (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(30, 64, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.499));
INSERT INTO test_gis_raster_stream (id, r) VALUES (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(44, 65, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.899));
INSERT INTO test_gis_raster_stream (id, r) VALUES (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(20, 9, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.080));
INSERT INTO test_gis_raster_stream (id, r) VALUES (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(21, 70, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.145));
INSERT INTO test_gis_raster_stream (id, r) VALUES (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(98, 86, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.043));
INSERT INTO test_gis_raster_stream (id, r) VALUES (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(34, 98, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.491));
INSERT INTO test_gis_raster_stream (id, r) VALUES (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(95, 65, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.384));
INSERT INTO test_gis_raster_stream (id, r) VALUES (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(65, 2, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.317));
INSERT INTO test_gis_raster_stream (id, r) VALUES (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(26, 97, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.454));
INSERT INTO test_gis_raster_stream (id, r) VALUES (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(29, 83, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.070));
INSERT INTO test_gis_raster_stream (id, r) VALUES (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(76, 24, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.254));
INSERT INTO test_gis_raster_stream (id, r) VALUES (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(55, 50, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.017));
INSERT INTO test_gis_raster_stream (id, r) VALUES (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(23, 89, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.596));
INSERT INTO test_gis_raster_stream (id, r) VALUES (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(92, 65, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.895));
INSERT INTO test_gis_raster_stream (id, r) VALUES (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(51, 52, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.629));
INSERT INTO test_gis_raster_stream (id, r) VALUES (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(61, 1, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.323));
INSERT INTO test_gis_raster_stream (id, r) VALUES (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(92, 51, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.983));
INSERT INTO test_gis_raster_stream (id, r) VALUES (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(53, 18, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.004));
INSERT INTO test_gis_raster_stream (id, r) VALUES (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(76, 36, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.376));
INSERT INTO test_gis_raster_stream (id, r) VALUES (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(76, 94, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.416));
INSERT INTO test_gis_raster_stream (id, r) VALUES (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(44, 20, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.053));
INSERT INTO test_gis_raster_stream (id, r) VALUES (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(21, 75, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.502)), (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(93, 58, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.153)), (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(48, 62, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.196)), (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(86, 74, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.803)), (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(82, 49, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.654)), (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(12, 4, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.173)), (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(33, 29, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.780)), (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(31, 3, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.038)), (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(47, 17, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.551)), (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(66, 90, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.638)), (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(67, 72, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.278)), (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(68, 66, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.884)), (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(65, 96, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.327)), (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(40, 80, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.125)), (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(80, 28, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.025)), (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(51, 19, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.250)), (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(81, 91, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.271)), (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(17, 82, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.375)), (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(69, 12, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.651)), (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(89, 36, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.787)), (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(21, 55, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.400)), (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(33, 35, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.030)), (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(18, 33, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.518)), (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(18, 64, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.222)), (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(88, 22, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.184)), (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(4, 74, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.492)), (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(92, 62, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.060)), (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(36, 64, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.907)), (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(8, 6, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.023)), (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(62, 49, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.739)), (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(92, 48, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.732)), (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(25, 82, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.211)), (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(1, 41, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.194)), (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(37, 9, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.090)), (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(31, 67, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.008)), (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(62, 85, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.946)), (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(18, 65, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.223)), (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(18, 86, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.751)), (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(23, 48, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.464)), (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(98, 12, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.990)), (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(12, 83, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.355)), (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(81, 48, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.689)), (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(71, 15, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.299)), (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(14, 9, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.134)), (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(37, 48, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.287)), (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(29, 12, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.024)), (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(88, 99, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.944)), (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(96, 36, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.069)), (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(20, 94, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.125)), (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(84, 94, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.871)), (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(44, 6, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.948)), (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(11, 15, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.078)), (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(20, 39, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.812)), (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(13, 84, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.820)), (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(80, 90, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.455)), (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(75, 53, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.163)), (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(80, 11, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.848)), (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(28, 88, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.591)), (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(7, 7, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.667)), (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(87, 82, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.746)), (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(34, 60, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.187)), (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(31, 36, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.365)), (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(21, 74, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.623)), (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(75, 25, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.333)), (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(100, 34, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.185)), (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(76, 21, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.424)), (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(75, 67, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.645)), (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(66, 57, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.545)), (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(57, 49, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.844)), (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(12, 98, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.584)), (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(47, 85, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.946)), (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(68, 64, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.891)), (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(88, 39, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.560)), (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(58, 19, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.456)), (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(79, 71, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.993)), (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(72, 20, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.480)), (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(45, 97, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.842)), (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(89, 62, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.700)), (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(91, 91, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.039)), (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(30, 64, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.499)), (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(44, 65, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.899)), (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(20, 9, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.080)), (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(21, 70, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.145)), (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(98, 86, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.043)), (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(34, 98, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.491)), (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(95, 65, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.384)), (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(65, 2, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.317)), (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(26, 97, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.454)), (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(29, 83, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.070)), (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(76, 24, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.254)), (0, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(55, 50, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.017)), (1, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(23, 89, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.596)), (2, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(92, 65, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.895)), (3, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(51, 52, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.629)), (4, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(61, 1, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.323)), (5, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(92, 51, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.983)), (6, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(53, 18, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.004)), (7, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(76, 36, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.376)), (8, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(76, 94, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.416)), (9, ST_SetValue(ST_AddBand(ST_MakeEmptyRaster(44, 20, 0.000, 0.000, 0.1), '64BF', 0.0, 0.0), 1, 1, 0.053));

SELECT round((row_to_json(st_summarystatsagg)->'count')::text::numeric, 3) FROM test_st_stats_agg0;
SELECT round((row_to_json(st_summarystatsagg)->'sum')::text::numeric, 3) FROM test_st_stats_agg0;
SELECT round((row_to_json(st_summarystatsagg)->'mean')::text::numeric, 3) FROM test_st_stats_agg0;
SELECT round((row_to_json(st_summarystatsagg)->'min')::text::numeric, 3) FROM test_st_stats_agg0;
SELECT round((row_to_json(st_summarystatsagg)->'max')::text::numeric, 3) FROM test_st_stats_agg0;
SELECT round((row_to_json(st_summarystatsagg)->'stddev')::text::numeric, 3) FROM test_st_stats_agg0;

SELECT round((row_to_json(st_summarystatsagg)->'count')::text::numeric, 3) FROM test_st_stats_agg1;
SELECT round((row_to_json(st_summarystatsagg)->'sum')::text::numeric, 3) FROM test_st_stats_agg1;
SELECT round((row_to_json(st_summarystatsagg)->'mean')::text::numeric, 3) FROM test_st_stats_agg1;
SELECT round((row_to_json(st_summarystatsagg)->'min')::text::numeric, 3) FROM test_st_stats_agg1;
SELECT round((row_to_json(st_summarystatsagg)->'max')::text::numeric, 3) FROM test_st_stats_agg1;
SELECT round((row_to_json(st_summarystatsagg)->'stddev')::text::numeric, 3) FROM test_st_stats_agg1;

SELECT round((row_to_json(st_summarystatsagg)->'count')::text::numeric, 3) FROM test_st_stats_agg2;
SELECT round((row_to_json(st_summarystatsagg)->'sum')::text::numeric, 3) FROM test_st_stats_agg2;
SELECT round((row_to_json(st_summarystatsagg)->'mean')::text::numeric, 3) FROM test_st_stats_agg2;
SELECT round((row_to_json(st_summarystatsagg)->'min')::text::numeric, 3) FROM test_st_stats_agg2;
SELECT round((row_to_json(st_summarystatsagg)->'max')::text::numeric, 3) FROM test_st_stats_agg2;
SELECT round((row_to_json(st_summarystatsagg)->'stddev')::text::numeric, 3) FROM test_st_stats_agg2;

SELECT round((row_to_json(st_summarystatsagg)->'count')::text::numeric, 3) FROM test_sw_st_stats_agg0;
SELECT round((row_to_json(st_summarystatsagg)->'sum')::text::numeric, 3) FROM test_sw_st_stats_agg0;
SELECT round((row_to_json(st_summarystatsagg)->'mean')::text::numeric, 3) FROM test_sw_st_stats_agg0;
SELECT round((row_to_json(st_summarystatsagg)->'min')::text::numeric, 3) FROM test_sw_st_stats_agg0;
SELECT round((row_to_json(st_summarystatsagg)->'max')::text::numeric, 3) FROM test_sw_st_stats_agg0;
SELECT round((row_to_json(st_summarystatsagg)->'stddev')::text::numeric, 3) FROM test_sw_st_stats_agg0;

SELECT round((row_to_json(st_summarystatsagg)->'count')::text::numeric, 3) FROM test_sw_st_stats_agg1;
SELECT round((row_to_json(st_summarystatsagg)->'sum')::text::numeric, 3) FROM test_sw_st_stats_agg1;
SELECT round((row_to_json(st_summarystatsagg)->'mean')::text::numeric, 3) FROM test_sw_st_stats_agg1;
SELECT round((row_to_json(st_summarystatsagg)->'min')::text::numeric, 3) FROM test_sw_st_stats_agg1;
SELECT round((row_to_json(st_summarystatsagg)->'max')::text::numeric, 3) FROM test_sw_st_stats_agg1;
SELECT round((row_to_json(st_summarystatsagg)->'stddev')::text::numeric, 3) FROM test_sw_st_stats_agg1;

SELECT round((row_to_json(st_summarystatsagg)->'count')::text::numeric, 3) FROM test_sw_st_stats_agg2;
SELECT round((row_to_json(st_summarystatsagg)->'sum')::text::numeric, 3) FROM test_sw_st_stats_agg2;
SELECT round((row_to_json(st_summarystatsagg)->'mean')::text::numeric, 3) FROM test_sw_st_stats_agg2;
SELECT round((row_to_json(st_summarystatsagg)->'min')::text::numeric, 3) FROM test_sw_st_stats_agg2;
SELECT round((row_to_json(st_summarystatsagg)->'max')::text::numeric, 3) FROM test_sw_st_stats_agg2;
SELECT round((row_to_json(st_summarystatsagg)->'stddev')::text::numeric, 3) FROM test_sw_st_stats_agg2;

SELECT * FROM test_st_countagg0;
SELECT * FROM test_st_countagg1;
SELECT * FROM test_st_countagg2;
SELECT * FROM test_sw_st_countagg0;
SELECT * FROM test_sw_st_countagg1;
SELECT * FROM test_sw_st_countagg2;

SELECT * FROM test_st_samealignment;
SELECT * FROM test_sw_st_samealignment;

SELECT * FROM test_st_union_raster0;
SELECT * FROM test_st_union_raster1;
SELECT * FROM test_st_union_raster2;
SELECT * FROM test_st_union_raster3;
SELECT * FROM  test_sw_st_union_raster0;
SELECT * FROM  test_sw_st_union_raster1;
SELECT * FROM  test_sw_st_union_raster2;
SELECT * FROM  test_sw_st_union_raster3;

DROP CONTINUOUS VIEW test_st_stats_agg0;
DROP CONTINUOUS VIEW test_st_stats_agg1;
DROP CONTINUOUS VIEW test_st_stats_agg2;
DROP CONTINUOUS VIEW test_sw_st_stats_agg0;
DROP CONTINUOUS VIEW test_sw_st_stats_agg1;
DROP CONTINUOUS VIEW test_sw_st_stats_agg2;
DROP CONTINUOUS VIEW test_st_countagg0;
DROP CONTINUOUS VIEW test_st_countagg1;
DROP CONTINUOUS VIEW test_st_countagg2;
DROP CONTINUOUS VIEW test_sw_st_countagg0;
DROP CONTINUOUS VIEW test_sw_st_countagg1;
DROP CONTINUOUS VIEW test_sw_st_countagg2;
DROP CONTINUOUS VIEW test_st_samealignment;
DROP CONTINUOUS VIEW test_sw_st_samealignment;
DROP CONTINUOUS VIEW test_st_union_raster0;
DROP CONTINUOUS VIEW test_st_union_raster1;
DROP CONTINUOUS VIEW test_st_union_raster2;
DROP CONTINUOUS VIEW test_st_union_raster3;
DROP CONTINUOUS VIEW test_sw_st_union_raster0;
DROP CONTINUOUS VIEW test_sw_st_union_raster1;
DROP CONTINUOUS VIEW test_sw_st_union_raster2;
DROP CONTINUOUS VIEW test_sw_st_union_raster3;
