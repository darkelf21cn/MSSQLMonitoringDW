SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportTransactionLogUsage]
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
FROM bMonitoringObjects WHERE monitor_name = 'TransactionLogUsage';

BEGIN TRANSACTION;

DELETE FROM dbo.mTransactionLogUsageHist
WHERE monitor_time < @RetentionStartDate;

INSERT INTO dbo.mTransactionLogUsageHist
SELECT * FROM dbo.mTransactionLogUsage
WHERE monitor_time < @ArchiveStartDate;

DELETE FROM dbo.mTransactionLogUsage
WHERE monitor_time < @ArchiveStartDate;

INSERT INTO dbo.mTransactionLogUsage (monitor_time, server_name, database_name, log_size_mb, log_usage_pct, log_reuse_wait_desc, recovery_model_desc)
SELECT @Now, server_name, database_name, log_size_mb, log_usage_pct, log_reuse_wait_desc, recovery_model_desc FROM dbo.iTransactionLogUsage

TRUNCATE TABLE dbo.iTransactionLogUsage;

TRUNCATE TABLE dbo.mTransactionLogCurrentUsage;
WITH tlog
AS (
	SELECT
		monitor_time, server_name, database_name, log_size_mb,
		log_usage_pct, log_reuse_wait_desc, recovery_model_desc
	FROM
		dbo.mTransactionLogUsage (NOLOCK)
	WHERE
		monitor_time = (SELECT MAX(monitor_time) FROM dbo.mTransactionLogUsage (NOLOCK))
),
last_disk
AS
(
	SELECT
		server_name, drive_name, drive_free_mb 
	FROM
		dbo.mDiskSize (NOLOCK)
	WHERE
		monitor_time = (SELECT MAX(monitor_time) FROM dbo.mDiskSize (NOLOCK))	
),
last_datafile
AS
(
	SELECT
		server_name, database_name, drive_name,
		SUM(
			CASE
				WHEN growth = 0 OR file_max_size_mb = 0 THEN 0
				WHEN growth > 0 AND file_max_size_mb = -1 THEN 2097152 - file_size_mb
				ELSE file_max_size_mb - file_size_mb
			END
		) AS file_max_growth_mb
	FROM
		dbo.mDataFile (NOLOCK)
	WHERE
		monitor_time = (SELECT MAX(monitor_time) FROM dbo.mDataFile (NOLOCK))
		AND file_type = 'LOG'
	GROUP BY
		server_name, database_name, drive_name
)
INSERT INTO dbo.mTransactionLogCurrentUsage (
	monitor_time,
	server_name,
	database_name,
	tracking_guid,
	log_size_mb,
	log_usage_pct,
	log_reuse_wait_desc,
	recovery_model_desc,
	log_max_growth_mb
)
SELECT
	a.monitor_time,
	a.server_name,
	a.database_name,
	CONVERT(UNIQUEIDENTIFIER, HASHBYTES('MD5', 'TransactionLogUsage_' + a.server_name + a.database_name)) AS tracking_guid,
	a.log_size_mb,
	a.log_usage_pct,
	a.log_reuse_wait_desc,
	a.recovery_model_desc,
	SUM(CASE
			WHEN drive_free_mb > file_max_growth_mb THEN file_max_growth_mb
			ELSE drive_free_mb
		END
	) AS log_max_growth_mb
FROM
	tlog a
	INNER JOIN last_datafile b
		ON a.server_name = b.server_name AND a.database_name = b.database_name
	INNER JOIN last_disk c
		ON b.server_name = c.server_name AND b.drive_name = c.drive_name
GROUP BY
	a.monitor_time, a.server_name, a.database_name, a.log_size_mb,
	a.log_usage_pct, a.log_reuse_wait_desc, a.recovery_model_desc;

COMMIT TRANSACTION;
GO
