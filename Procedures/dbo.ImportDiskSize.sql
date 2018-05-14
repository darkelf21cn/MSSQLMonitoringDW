SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportDiskSize]
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
FROM bMonitoringObjects WHERE monitor_name = 'DiskSize';

BEGIN TRANSACTION;

DELETE FROM dbo.mDiskSizeHist
WHERE monitor_time < @RetentionStartDate;

INSERT INTO dbo.mDiskSizeHist
SELECT * FROM dbo.mDiskSize
WHERE monitor_time < @ArchiveStartDate;

DELETE FROM dbo.mDiskSize
WHERE monitor_time < @ArchiveStartDate;

INSERT INTO dbo.mDiskSize(
	monitor_time,
	server_name,
	drive_name,
	drive_free_mb,
	drive_capacity_mb)
SELECT
	dbo.TrimTime(@Now, 5),
	RTRIM(server_name),
	RTRIM(drive_name),
	drive_free_mb,
	drive_capacity_mb
FROM dbo.iDiskSize

TRUNCATE TABLE dbo.iDiskSize;

COMMIT TRANSACTION;
GO
