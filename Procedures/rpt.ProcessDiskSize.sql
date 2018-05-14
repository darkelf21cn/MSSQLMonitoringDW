SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [rpt].[ProcessDiskSize]
AS
DECLARE @ProcessStartDate DATE;
SELECT @ProcessStartDate = ISNULL(DATEADD(DAY, 1, MAX(monitor_date)), '2016-01-01') FROM rpt.DiskSizeAggByDay;

WITH exact_monitortime
AS (
SELECT ROW_NUMBER() OVER (ORDER BY MIN(monitor_time)) AS rid, MIN(monitor_time) AS monitor_time
	FROM dbo.mDiskSize WITH (NOLOCK)
	WHERE monitor_time > @ProcessStartDate
	GROUP BY CONVERT(CHAR(10), monitor_time, 120)
)
INSERT INTO rpt.DiskSizeAggByDay
SELECT
	CONVERT(DATE, a.monitor_time) AS monitor_date,
	server_name,
	drive_name,
	drive_free_mb,
	drive_capacity_mb
FROM
	dbo.mDiskSize AS a WITH (NOLOCK)
	INNER JOIN exact_monitortime b
		ON a.monitor_time = b.monitor_time
WHERE
	a.monitor_time > @ProcessStartDate
	AND drive_name NOT IN ('C')
ORDER BY
	monitor_date,
	server_name


GO
