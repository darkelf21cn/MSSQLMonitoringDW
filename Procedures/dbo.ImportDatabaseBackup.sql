SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ImportDatabaseBackup]
AS
SET XACT_ABORT ON
BEGIN

DECLARE @ArchiveStartDate SMALLDATETIME;
DECLARE @RetentionStartDate SMALLDATETIME;
DECLARE @Now DATETIME = GETDATE();
SELECT
	@ArchiveStartDate = DATEADD(DAY, 0 - archive_days, @Now),
	@RetentionStartDate = DATEADD(DAY, 0 - retention_days, @Now)
FROM bMonitoringObjects WHERE monitor_name = 'DatabaseBackup';

BEGIN TRANSACTION;

DELETE FROM dbo.mDatabaseBackupHist
WHERE backup_start_date < @RetentionStartDate;

INSERT INTO dbo.mDatabaseBackupHist
SELECT * FROM dbo.mDatabaseBackup
WHERE backup_start_date < @ArchiveStartDate;

DELETE FROM dbo.mDatabaseBackup
WHERE backup_start_date < @ArchiveStartDate;
		
INSERT INTO dbo.mDatabaseBackup
SELECT
	a.server_name,
	a.database_name,
	a.backup_set_id,
	a.family_sequence_number,
	a.backup_start_date,
	a.backup_finish_date,
	a.size_kb,
	a.duration_s,
	a.backup_type,
	a.physical_path,
	a.physical_device_name,
	a.first_lsn,
	a.last_lsn,
	a.recovery_model
FROM
	dbo.iDatabaseBackup a
	LEFT JOIN (
		SELECT server_name, MAX(backup_set_id) AS max_backup_set_id
		FROM dbo.mDatabaseBackup
		GROUP BY server_name
	) b
		ON a.server_name = b.server_name
WHERE
	(b.server_name IS NULL --New server handling
	OR a.backup_set_id > max_backup_set_id) --Insert data only when backup_set_id is newer than existing data.
	AND a.backup_start_date > @ArchiveStartDate;

TRUNCATE TABLE dbo.iDatabaseBackup;

COMMIT TRANSACTION;

END;
GO
