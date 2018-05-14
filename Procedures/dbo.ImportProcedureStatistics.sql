SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportProcedureStatistics]
AS
SET XACT_ABORT ON
BEGIN

DECLARE @RetentionStartDate SMALLDATETIME;
DECLARE @Now DATETIME = GETDATE();
SELECT
	@RetentionStartDate = DATEADD(DAY, 0 - retention_days, @Now)
FROM bMonitoringObjects WHERE monitor_name = 'ProcedureStatistics';

BEGIN TRANSACTION;
DELETE FROM dbo.mProcedureStatistics
WHERE monitor_time < @RetentionStartDate;

DECLARE @BatchID BIGINT;
SELECT
	@BatchID = ISNULL(MAX(batch_id), 0)
FROM
	dbo.mProcedureStatistics;

INSERT INTO dbo.mProcedureStatistics (batch_id, monitor_time, server_name, database_name, object_name, creation_time,
								plan_handle, sql_handle, execution_count, last_execution_time, last_elapsed_time,
								last_worker_time, last_logical_reads, max_elapsed_time, min_elapsed_time, total_elapsed_time,
								total_logical_reads, total_logical_writes, total_physical_reads, total_worker_time)
SELECT DISTINCT
	@BatchID + 1,
	dbo.TrimTime(a.monitor_time, 5),
	a.server_name,
	a.database_name,
	a.object_name,
	a.creation_time,
	a.plan_handle,
	a.sql_handle,
	a.execution_count,
	a.last_execution_time, 
	a.last_elapsed_time,
	a.last_worker_time,
	a.last_logical_reads,
	a.max_elapsed_time,
	a.min_elapsed_time,
	a.total_elapsed_time,
	a.total_logical_reads,
	a.total_logical_writes,
	a.total_physical_reads,
	a.total_worker_time
FROM
	dbo.iProcedureStatistics a
	LEFT JOIN dbo.mProcedures b
		ON a.server_name = b.server_name
		   AND a.database_name = b.database_name
		   AND a.object_name = b.object_name
		   AND a.plan_handle = b.plan_handle
		   AND a.sql_handle = b.sql_handle
WHERE
	a.last_execution_time > b.last_execution_time
	OR b.server_name IS NULL

DELETE FROM dbo.mProcedures
WHERE update_time < @RetentionStartDate;

MERGE dbo.mProcedures AS t
USING dbo.iProcedureStatistics AS s
ON (
	t.server_name = s.server_name
	AND t.database_name = s.database_name
	AND t.object_name = s.object_name
	AND t.plan_handle = s.plan_handle
	AND t.sql_handle = s.sql_handle
)
WHEN MATCHED THEN
	UPDATE SET
		t.update_time = @Now,
		t.last_execution_time = s.last_execution_time
WHEN NOT MATCHED THEN
	INSERT (
		update_time,
		server_name,
		database_name,
		object_name,
		sql_handle,
		plan_handle,
		last_execution_time
	)
	VALUES (
		@Now,
		s.server_name,
		s.database_name,
		s.object_name,
		s.sql_handle,
		s.plan_handle,
		s.last_execution_time
	);

TRUNCATE TABLE dbo.iProcedureStatistics;

COMMIT TRANSACTION;

END;
GO
