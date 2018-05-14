SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [rpt].[ProcessDatabaseDailyGrowth]
AS
DECLARE @LastRecordDate DATE;
DECLARE @ProcessStartDate DATE;
SELECT @LastRecordDate = MAX(monitor_date) FROM rpt.DatabaseAggByDay;
SELECT @ProcessStartDate = ISNULL(DATEADD(DAY, 1, @LastRecordDate), '2016-01-01');
PRINT @LastRecordDate;
PRINT @ProcessStartDate;

--Due to the bug of sys.databases, some of the datafile information might be miss collected.
--To make the result more accurate, we find the monitor time when it get most mnumber of datafiles within a day.
--Then just use that time to repensent the datafile useage for the entire day.
WITH datafile_count
AS (
	SELECT
		CONVERT(DATE, monitor_time) AS monitor_date,
		monitor_time,
		server_name,
		COUNT(*) AS datafiles
	FROM
		dbo.mDataFile (NOLOCK)
	WHERE
		monitor_time >= @ProcessStartDate
	GROUP BY
		monitor_time,
		server_name),
exact_monitortime
AS (
	SELECT
		a.monitor_date,
		a.server_name,
		MIN(a.monitor_time) AS monitor_time
	FROM
		datafile_count a
		INNER JOIN (SELECT monitor_date, server_name, MAX(datafiles) AS max_datafiles FROM datafile_count GROUP BY monitor_date, server_name) b
			ON a.monitor_date = b.monitor_date
				AND a.server_name = b.server_name
				AND a.datafiles = b.max_datafiles
	GROUP BY
		a.monitor_date,
		a.server_name)
INSERT INTO rpt.DatabaseAggByDay
SELECT
	a.monitor_time,
	a.server_name,
	a.database_name,
	a.file_type AS data_type,
	SUM(a.file_size_mb) AS allocated_mb,
	SUM(a.file_used_mb) AS used_mb
FROM
	dbo.mDataFile AS a WITH (NOLOCK)
	INNER JOIN exact_monitortime b
		ON a.monitor_time = b.monitor_time
			AND a.server_name = b.server_name
GROUP BY
	a.monitor_time,
	a.server_name,
	a.database_name,
	a.file_type

GO
