SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportSqlConnectivity]
AS
SET XACT_ABORT ON

DECLARE @RetentionStartDate SMALLDATETIME;
DECLARE @Now DATETIME = GETDATE();
SELECT @RetentionStartDate = DATEADD(DAY, 0 - retention_days, @Now) FROM bMonitoringObjects WHERE monitor_name = 'SqlConnectivity';

BEGIN TRANSACTION;

DELETE FROM dbo.mConnectivityHist
WHERE monitor_time < @RetentionStartDate;

INSERT INTO dbo.mConnectivityHist (monitor_time, server_name, result)
SELECT monitor_time, server_name, result FROM dbo.mConnectivity;
		
TRUNCATE TABLE dbo.mConnectivity;
		
INSERT INTO dbo.mConnectivity (monitor_time, server_name, result)
SELECT
	monitor_time,
	server_name,
	CASE
		WHEN (status = 'Completed') THEN 'CONNECTED'
		ELSE ISNULL(message, '')
	END AS result
FROM
	iConnectivity;

TRUNCATE TABLE dbo.iConnectivity;

COMMIT TRANSACTION;

GO
