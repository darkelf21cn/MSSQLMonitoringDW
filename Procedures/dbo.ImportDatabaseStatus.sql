SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportDatabaseStatus]
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
FROM bMonitoringObjects WHERE monitor_name = 'DatabaseStatus';

BEGIN TRANSACTION;

DELETE FROM dbo.mDatabaseStatusHist
WHERE monitor_time < @RetentionStartDate;

INSERT INTO dbo.mDatabaseStatusHist
SELECT * FROM dbo.mDatabaseStatus
WHERE monitor_time < @ArchiveStartDate;

DELETE FROM dbo.mDatabaseStatus
WHERE monitor_time < @ArchiveStartDate;

INSERT INTO dbo.mDatabaseStatus(monitor_time, server_name, database_name, user_access_desc, state_desc)
SELECT dbo.TrimTime(@Now, 1), RTRIM(server_name), RTRIM(database_name), RTRIM(user_access_desc), RTRIM(state_desc) FROM dbo.iDatabaseStatus

TRUNCATE TABLE dbo.iDatabaseStatus;

COMMIT TRANSACTION;

GO
