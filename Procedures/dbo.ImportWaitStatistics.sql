SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ImportWaitStatistics]
AS
SET XACT_ABORT ON

DECLARE @RetentionStartDate SMALLDATETIME;
DECLARE @Now DATETIME = GETDATE();
SELECT
	@RetentionStartDate = DATEADD(DAY, 0 - retention_days, @Now)
FROM bMonitoringObjects WHERE monitor_name = 'WaitStatistics';

DECLARE @BatchID BIGINT;
SELECT
	@BatchID = ISNULL(MAX(batch_id), 0)
FROM
	dbo.mWaitStatistics;

BEGIN TRANSACTION;

DELETE FROM dbo.mWaitStatistics
WHERE monitor_time < @RetentionStartDate;

INSERT INTO dbo.mWaitStatistics(
	batch_id,
	monitor_time,
	server_name,
	wait_type,
	waiting_tasks_count,
	wait_time_ms,
	max_wait_time_ms,
	signal_wait_time_ms
)
SELECT
	@BatchID + 1,
	dbo.TrimTime(a.monitor_time, 1),
	a.server_name,
	a.wait_type,
	a.waiting_tasks_count,
	a.wait_time_ms,
	a.max_wait_time_ms,
	a.signal_wait_time_ms
FROM
	dbo.iWaitStatistics a

TRUNCATE TABLE dbo.iWaitStatistics;

COMMIT TRANSACTION;




GO
