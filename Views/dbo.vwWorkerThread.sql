SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwWorkerThread]
AS
SELECT
	a.monitor_time,
	a.server_name,
	CONVERT(UNIQUEIDENTIFIER, HASHBYTES('MD5', 'WorkerThread' + server_name)) AS tracking_guid,
	a.active_worker_threads,
	a.current_worker_threads,
	a.max_worker_threads,
	a.worker_thread_usage_pct
FROM
	dbo.mWorkerThread a (NOLOCK)
WHERE
	a.monitor_time = (SELECT MAX(monitor_time) FROM dbo.mWorkerThread (NOLOCK))
GO
