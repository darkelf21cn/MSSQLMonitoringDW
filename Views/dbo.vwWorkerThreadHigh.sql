SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwWorkerThreadHigh]
AS
SELECT
	a.server_name,
	a.active_worker_threads,
	a.current_worker_threads,
	a.max_worker_threads,
	a.worker_thread_usage_pct
FROM
	dbo.mWorkerThread a (NOLOCK)
	INNER JOIN dbo.vwServerMonitors b (NOLOCK)
		ON a.server_name = b.server_name
WHERE
	b.monitor_name = 'WorkerThread'
	AND a.monitor_time = (SELECT MAX(monitor_time) FROM dbo.mWorkerThread (NOLOCK))
	AND a.worker_thread_usage_pct >= 70
	AND a.max_worker_threads - a.current_worker_threads < 300
	AND (a.active_worker_threads * 1.0 / a.max_worker_threads * 100) > 30
	AND NOT EXISTS (SELECT 'X' FROM dbo.cMaintenanceMode (NOLOCK) WHERE server_id = b.server_id AND GETDATE() BETWEEN maintenance_start_datetime AND maintenance_end_datetime)
	AND NOT EXISTS (SELECT 'X' FROM dbo.cAutoSuppression (NOLOCK) WHERE server_id = b.server_id AND monitor_id = b.monitor_id AND GETDATE() BETWEEN suppress_start_datetime AND suppress_end_datetime)

GO
