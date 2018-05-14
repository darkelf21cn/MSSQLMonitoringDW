SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportSQLAgentJobStatus]
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
FROM bMonitoringObjects WHERE monitor_name = 'SQLAgentJobStatus';

BEGIN TRANSACTION;

DELETE FROM dbo.mAgentJobStatusHist
WHERE monitor_time < @RetentionStartDate;

INSERT INTO dbo.mAgentJobStatusHist
SELECT * FROM dbo.mAgentJobStatus
WHERE monitor_time < @ArchiveStartDate;

DELETE FROM dbo.mAgentJobStatus
WHERE monitor_time < @ArchiveStartDate;

INSERT INTO dbo.mAgentJobStatus (monitor_time, server_name, job_name, is_enabled, job_status, job_start_time, duration_min,
                                    step_id, step_name, last_run_outcome, last_run_time, last_run_duration_min)
SELECT
	dbo.TrimTime(@Now, 5),
	RTRIM(server_name),
	RTRIM(REPLACE(job_name, '#$!$#', '|')),
	is_enabled,
	RTRIM(job_status),
	CASE
		WHEN LTRIM(RTRIM(job_start_time)) = 'NULL' THEN NULL
		ELSE CONVERT(DATETIME, LTRIM(RTRIM(job_start_time)))
	END,
	CASE
		WHEN LTRIM(RTRIM(duration_min)) = 'NULL' THEN NULL
		ELSE CONVERT(INT, LTRIM(RTRIM(duration_min)))
	END,
	CASE
		WHEN LTRIM(RTRIM(step_id)) = 'NULL' THEN NULL
		ELSE CONVERT(INT, LTRIM(RTRIM(step_id)))
	END,
	CASE
		WHEN LTRIM(RTRIM(step_name)) = 'NULL' THEN NULL
		ELSE LTRIM(RTRIM(REPLACE(step_name, '#$!$#', '|')))
	END,
	CASE
		WHEN LTRIM(RTRIM(last_run_outcome)) = 'NULL' THEN NULL
		ELSE LTRIM(RTRIM(last_run_outcome))
	END,		
	CASE
		WHEN LTRIM(RTRIM(last_run_time)) = 'NULL' THEN NULL
		ELSE CONVERT(DATETIME, LTRIM(RTRIM(last_run_time)))
	END,
	CASE
		WHEN LTRIM(RTRIM(last_run_duration_min)) = 'NULL' THEN NULL
		ELSE CONVERT(INT, LTRIM(RTRIM(last_run_duration_min)))
	END
FROM dbo.iAgentJobStatus

TRUNCATE TABLE dbo.iAgentJobStatus;

COMMIT TRANSACTION;
GO
