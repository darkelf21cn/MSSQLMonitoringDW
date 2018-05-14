SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ImportAbuseOfServiceAcct]
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
FROM bMonitoringObjects WHERE monitor_name = 'AbuseOfServiceAcct';

BEGIN TRANSACTION;

DELETE FROM dbo.mAbuseOfServiceAcctHist
WHERE login_time < @RetentionStartDate;

INSERT INTO dbo.mAbuseOfServiceAcctHist
SELECT * FROM dbo.mAbuseOfServiceAcct
WHERE login_time < @ArchiveStartDate;

DELETE FROM dbo.mAbuseOfServiceAcct
WHERE login_time < @ArchiveStartDate;

WITH last_monitor_dt AS (
	SELECT
		server_name, 
		MAX(login_time) AS login_time
	FROM 
		dbo.mAbuseOfServiceAcct
	GROUP BY server_name
)
INSERT INTO dbo.mAbuseOfServiceAcct(
	server_name,
	login_time,
	login_name,
	host_name,
	program_name)
SELECT
	a.server_name,
	a.login_time,
	a.login_name,
	a.host_name,
	a.program_name
FROM
	dbo.iAbuseOfServiceAcct a
	LEFT JOIN last_monitor_dt b
		ON a.server_name = b.server_name 
WHERE
	(a.login_time > b.login_time
	OR b.server_name IS NULL)

TRUNCATE TABLE dbo.iAbuseOfServiceAcct;

COMMIT TRANSACTION;


GO
