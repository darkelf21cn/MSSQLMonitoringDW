SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportQueryStatistics]
AS
SET XACT_ABORT ON
BEGIN

DECLARE @RetentionStartDate SMALLDATETIME;
DECLARE @Now DATETIME = GETDATE();
SELECT
	@RetentionStartDate = DATEADD(DAY, 0 - retention_days, @Now)
FROM bMonitoringObjects WHERE monitor_name = 'QueryStatistics';

BEGIN TRANSACTION;
DELETE FROM dbo.mQueryStatistics
WHERE monitor_time < @RetentionStartDate;

DECLARE @BatchID BIGINT;
SELECT
	@BatchID = ISNULL(MAX(batch_id), 0)
FROM
	dbo.mQueryStatistics;

INSERT INTO dbo.mQueryStatistics (batch_id, monitor_time, server_name, execution_count, last_execution_time, 
								last_elapsed_ms, max_elapsed_ms, min_elapsed_ms, total_elapsed_ms, total_logical_reads,
								total_logical_writes, total_physical_reads, total_worker_ms, statement_hash)
SELECT DISTINCT
	@BatchID + 1,
	dbo.TrimTime(a.monitor_time, 5),
	a.server_name,
	a.execution_count,
	a.last_execution_time, 
	a.last_elapsed_ms,
	a.max_elapsed_ms,
	a.min_elapsed_ms,
	a.total_elapsed_ms,
	a.total_logical_reads,
	a.total_logical_writes,
	a.total_physical_reads,
	a.total_worker_ms,
	CONVERT(VARCHAR(32), HashBytes('MD5', a.database_name + a.object_name + CONVERT(NVARCHAR(64), a.sql_handle) + CONVERT(NVARCHAR(64), a.plan_handle) + CONVERT(NVARCHAR(20), a.statement_start_offset) + CONVERT(NVARCHAR(20), a.statement_end_offset)), 2)
FROM
	dbo.iQueryStatistics a
	LEFT JOIN dbo.mQueryStatments b
		ON a.server_name = b.server_name
		   AND CONVERT(VARCHAR(32), HashBytes('MD5', a.database_name + a.object_name + CONVERT(NVARCHAR(64), a.sql_handle) + CONVERT(NVARCHAR(64), a.plan_handle) + CONVERT(NVARCHAR(20), a.statement_start_offset) + CONVERT(NVARCHAR(20), a.statement_end_offset)), 2) = statement_hash
WHERE
	a.last_execution_time > b.last_execution_time
	OR b.server_name IS NULL

DELETE FROM dbo.mQueryStatments
WHERE update_time < @RetentionStartDate;

MERGE dbo.mQueryStatments AS t
USING dbo.iQueryStatistics AS s
ON (
	t.server_name = s.server_name
	AND t.statement_hash = CONVERT(VARCHAR(32), HashBytes('MD5', s.database_name + s.object_name + CONVERT(NVARCHAR(64), s.sql_handle) + CONVERT(NVARCHAR(64), s.plan_handle) + CONVERT(NVARCHAR(20), s.statement_start_offset) + CONVERT(NVARCHAR(20), s.statement_end_offset)), 2)
)
WHEN MATCHED THEN
	UPDATE SET
		t.update_time = @Now,
		t.last_execution_time = s.last_execution_time,
		t.creation_time = s.creation_time,
		t.plan_generation_num = s.plan_generation_num
WHEN NOT MATCHED THEN
	INSERT (
		update_time,
		server_name,
		statement_hash,
		database_name,
		object_name,
		creation_time,
		plan_generation_num,
		statement_text,
		sql_handle,
		plan_handle,
		statement_start_offset,
		statement_end_offset,
		last_execution_time
	)
	VALUES (
		@Now,
		s.server_name,
		CONVERT(VARCHAR(32), HashBytes('MD5', s.database_name + s.object_name + CONVERT(NVARCHAR(64), s.sql_handle) + CONVERT(NVARCHAR(64), s.plan_handle) + CONVERT(NVARCHAR(20), s.statement_start_offset) + CONVERT(NVARCHAR(20), s.statement_end_offset)), 2),
		s.database_name,
		s.object_name,
		s.creation_time,
		s.plan_generation_num,
		s.statement_text,
		s.sql_handle,
		s.plan_handle,
		s.statement_start_offset,
		s.statement_end_offset,
		s.last_execution_time
	);

TRUNCATE TABLE dbo.iQueryStatistics;

COMMIT TRANSACTION;

END;
GO
