SELECT TOP 5 qs.total_worker_time / qs.execution_count AS AvgCPUTime
	, qs.execution_count
	, qs.plan_handle, qp.query_plan
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY qs.total_worker_time / qs.execution_count DESC;

------------------------------------------------------------------------
