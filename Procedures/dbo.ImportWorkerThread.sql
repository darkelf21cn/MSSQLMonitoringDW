SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportWorkerThread]
AS
SET XACT_ABORT ON

DECLARE @ErrorNumber INT;
DECLARE @ErrorSeverity INT;
DECLARE @ErrorState INT;
DECLARE @ErrorProcedure NVARCHAR(128);
DECLARE @ErrorLine INT;
DECLARE @ErrorMessage NVARCHAR(MAX);

DECLARE @ArchiveStartDate SMALLDATETIME;
DECLARE @RetentionStartDate SMALLDATETIME;
DECLARE @Now DATETIME = GETDATE();
SELECT
	@ArchiveStartDate = DATEADD(DAY, 0 - archive_days, @Now),
	@RetentionStartDate = DATEADD(DAY, 0 - retention_days, @Now)
FROM bMonitoringObjects WHERE monitor_name = 'WorkerThread';

BEGIN TRANSACTION;

DELETE FROM dbo.mWorkerThreadHist
WHERE monitor_time < @RetentionStartDate;

INSERT INTO dbo.mWorkerThreadHist
SELECT * FROM dbo.mWorkerThread
WHERE monitor_time < @ArchiveStartDate;

DELETE FROM dbo.mWorkerThread
WHERE monitor_time < @ArchiveStartDate;

INSERT INTO dbo.mWorkerThread (monitor_time, server_name, active_worker_threads, current_worker_threads, max_worker_threads, worker_thread_usage_pct)
SELECT dbo.TrimTime(@Now, 5), RTRIM(server_name), RTRIM(active_worker_threads), RTRIM(current_worker_threads), RTRIM(max_worker_threads), RTRIM(CONVERT(INT, current_worker_threads * 100.0 / max_worker_threads)) FROM dbo.iWorkerThread

TRUNCATE TABLE dbo.iWorkerThread;

COMMIT TRANSACTION;
GO
