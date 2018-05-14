SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportDeadlock]
AS
SET XACT_ABORT ON

DECLARE @ArchiveStartDate SMALLDATETIME;
DECLARE @RetentionStartDate SMALLDATETIME;
DECLARE @Now DATETIME = GETDATE();
SELECT
	@ArchiveStartDate = DATEADD(DAY, 0 - archive_days, @Now),
	@RetentionStartDate = DATEADD(DAY, 0 - retention_days, @Now)
FROM bMonitoringObjects
WHERE monitor_name = 'Deadlock';

IF OBJECT_ID('tempdb..#Deadlock') IS NOT NULL
	DROP TABLE #Deadlock;
CREATE TABLE #Deadlock(
	server_name NVARCHAR(128) COLLATE SQL_Latin1_General_CP1_CI_AS,
	detect_time_utc DATETIME,
	x_hash NVARCHAR(32) COLLATE SQL_Latin1_General_CP1_CI_AS,
	x_deadlock XML
);

BEGIN TRANSACTION;

DELETE FROM dbo.mDeadlockHist
WHERE monitor_time < @RetentionStartDate;

INSERT INTO dbo.mDeadlockHist
SELECT * FROM dbo.mDeadlock
WHERE monitor_time < @ArchiveStartDate;

DELETE FROM dbo.mDeadlock
WHERE monitor_time < @ArchiveStartDate;
	
INSERT INTO #Deadlock
SELECT
	server_name,
	detect_time_utc,
	x_hash,
	x_deadlock
FROM
	dbo.iDeadlock;

DELETE FROM #Deadlock
WHERE 
	x_deadlock.value('(/deadlock/process-list/process/@clientapp)[1]', 'VARCHAR(128)') IN
		(SELECT property_value FROM dbo.bDeadlockIgnoreList WHERE property_name = 'clientapp')
	OR x_deadlock.value('(/deadlock/process-list/process/@hostname)[1]', 'VARCHAR(128)') IN
		(SELECT property_value FROM dbo.bDeadlockIgnoreList WHERE property_name = 'hostname');

INSERT INTO dbo.mDeadlock
(
	monitor_time,
	server_name,
	detect_time_utc,
	detect_time,
	x_hash,
	x_deadlock
)
SELECT
	dbo.TrimTime(GETDATE(), 5),
	server_name,
	detect_time_utc,
	DATEADD(Hour, DATEDIFF(Hour, GETUTCDATE(), GETDATE()), detect_time_utc) AS detect_time,
	x_hash,
	x_deadlock
FROM
	#Deadlock
WHERE
	x_hash NOT IN (SELECT x_hash FROM dbo.mDeadlock)
ORDER BY
	detect_time_utc;

TRUNCATE TABLE dbo.iDeadlock;

COMMIT TRANSACTION;


GO
