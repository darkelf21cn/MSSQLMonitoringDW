SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportCpu]
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
FROM bMonitoringObjects WHERE monitor_name = 'Cpu';

BEGIN TRANSACTION;

DELETE FROM dbo.mCpuHist
WHERE monitor_time < @RetentionStartDate;

INSERT INTO dbo.mCpuHist
SELECT * FROM dbo.mCpu
WHERE monitor_time < @ArchiveStartDate;

DELETE FROM dbo.mCpu
WHERE monitor_time < @ArchiveStartDate;

INSERT INTO dbo.mCpu(
	monitor_time,
	server_name,
	cpu_sql,
	cpu_other,
	cpu_idle)
SELECT DISTINCT
	dbo.TrimTime(a.monitor_time, 1),
	a.server_name,
	a.cpu_sql,
	a.cpu_other,
	a.cpu_idle
FROM
	dbo.iCpu a
	LEFT JOIN (SELECT server_name, MAX(monitor_time) AS monitor_time FROM dbo.mCpu GROUP BY server_name) b
		ON a.server_name = b.server_name
WHERE
	dbo.TrimTime(a.monitor_time, 1) > b.monitor_time
	OR (b.server_name IS NULL)

TRUNCATE TABLE dbo.iCpu;

COMMIT TRANSACTION;

GO
