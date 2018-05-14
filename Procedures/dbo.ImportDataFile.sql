SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportDataFile]
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
FROM bMonitoringObjects WHERE monitor_name = 'DataFile';

BEGIN TRANSACTION;

DELETE FROM dbo.mDataFileHist
WHERE monitor_time < @RetentionStartDate;

INSERT INTO dbo.mDataFileHist
SELECT * FROM dbo.mDataFile
WHERE monitor_time < @ArchiveStartDate;

DELETE FROM dbo.mDataFile
WHERE monitor_time < @ArchiveStartDate;

INSERT INTO dbo.mDataFile(
	monitor_time,
	server_name,
	database_name,
	file_group_name,
	file_id,
	file_type,
	logical_name,
	drive_name,
	file_path,
	file_name,
	reads_per_sec,
	read_mb_per_sec,
	read_wait_ms,
	writes_per_sec,
	write_mb_per_sec,
	write_wait_ms,
	file_size_mb,
	file_used_mb,
	growth,
	is_percent_growth,
	file_max_size_mb)
SELECT
	dbo.TrimTime(a.monitor_time, 5),
	RTRIM(a.server_name),
	RTRIM(a.database_name),
	RTRIM(a.file_group_name),
	a.file_id,
	RTRIM(a.file_type),
	RTRIM(a.logical_name),
	RTRIM(a.drive_name),
	RTRIM(a.file_path),
	RTRIM(a.file_name),
    CASE
        WHEN a.read_counts >= b.read_counts THEN (a.read_counts - b.read_counts) / DATEDIFF(SECOND, b.monitor_time, a.monitor_time)
        ELSE NULL
    END AS reads_per_sec,
    CASE
        WHEN a.read_mb >= b.read_mb THEN (a.read_mb - b.read_mb) / DATEDIFF(SECOND, b.monitor_time, a.monitor_time)
        ELSE NULL
    END AS read_mb_per_sec,
	CASE
        WHEN a.read_wait_ms >= b.read_wait_ms THEN a.read_wait_ms - b.read_wait_ms
        ELSE NULL
    END AS read_wait_ms,
    CASE
        WHEN a.write_counts >= b.write_counts THEN (a.write_counts - b.write_counts) / DATEDIFF(SECOND, b.monitor_time, a.monitor_time)
        ELSE NULL
    END AS writes_per_sec,
    CASE
        WHEN a.write_mb >= b.write_mb THEN (a.write_mb - b.write_mb) / DATEDIFF(SECOND, b.monitor_time, a.monitor_time)
        ELSE NULL
    END AS write_mb_per_sec,
	CASE
        WHEN a.write_wait_ms >= b.write_wait_ms THEN a.write_wait_ms - b.write_wait_ms
        ELSE NULL
    END AS write_wait_ms,
	a.file_size_mb,
	a.file_used_mb,
	a.growth,
	a.is_percent_growth,
	a.file_max_size_mb
FROM
    dbo.iDataFile a
    LEFT JOIN dbo.mDataFileBase b
        ON a.server_name = b.server_name
           AND a.database_name = b.database_name
           AND a.file_id = b.file_id

TRUNCATE TABLE dbo.mDataFileBase;
INSERT INTO dbo.mDataFileBase (
	monitor_time,
	server_name,
	database_name,
	file_id,
	read_counts,
	read_mb,
	read_wait_ms,
	write_counts,
	write_mb,
	write_wait_ms
)
SELECT
    monitor_time,
	server_name,
	database_name,
	file_id,
	read_counts,
	read_mb,
	read_wait_ms,
	write_counts,
	write_mb,
	write_wait_ms
FROM
    dbo.iDataFile

TRUNCATE TABLE dbo.iDataFile;

COMMIT TRANSACTION;
GO
