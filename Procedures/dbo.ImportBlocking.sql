SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportBlocking]
AS
SET XACT_ABORT ON
BEGIN

DECLARE @RetentionStartDate SMALLDATETIME;
DECLARE @Now DATETIME = GETDATE();
SELECT @RetentionStartDate = DATEADD(DAY, 0 - retention_days, @Now) FROM bMonitoringObjects WHERE monitor_name = 'Blocking';

BEGIN TRANSACTION;

DELETE FROM dbo.mBlockingHist
WHERE monitor_time < @RetentionStartDate;

INSERT INTO dbo.mBlockingHist
SELECT * FROM dbo.mBlocking;
		
TRUNCATE TABLE dbo.mBlocking;
		
INSERT INTO dbo.mBlocking (monitor_time, server_name, session_id, blocked_by, level, blocking_tree, blocking_tree_order,
							host_name, login_name, program_name, database_name, status, wait_time_ms, last_wait_type,
							wait_resource, open_tran, cpu, physical_io, individual_query, entire_query)
SELECT
	dbo.TrimTime(@Now, 1),
	RTRIM(server_name),
	session_id,
	blocked_by,
	level,
	RTRIM(blocking_tree),
	ROW_NUMBER() OVER (PARTITION BY server_name ORDER BY blocking_path),
	CASE
		WHEN RTRIM(host_name) = 'NULL' THEN NULL
		ELSE RTRIM(host_name)
	END,
	CASE
		WHEN RTRIM(login_name) = 'NULL' THEN NULL
		ELSE RTRIM(login_name)
	END,
	CASE
		WHEN RTRIM(program_name) = 'NULL' THEN NULL
		ELSE RTRIM(program_name)
	END,
	RTRIM(database_name),
	RTRIM(status),
	wait_time_ms,
	RTRIM(last_wait_type),
	RTRIM(wait_resource),
	open_tran,
	cpu,
	physical_io,
	CASE
		WHEN RTRIM(individual_query) = 'NULL' THEN NULL
		ELSE RTRIM(individual_query)
	END,
	CASE
		WHEN RTRIM(entire_query) = 'NULL' THEN NULL
		ELSE RTRIM(entire_query)
	END
FROM
	dbo.iBlocking;

TRUNCATE TABLE dbo.iBlocking;

COMMIT TRANSACTION;
END;













GO
