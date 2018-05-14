SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [rpt].[vwDatabaseAggByDay]
AS
--The transaction log usage will always be consided as 100%.
SELECT
	monitor_date,
	server_name,
	database_name,
	SUM(
		CASE
			WHEN data_type = 'LOG' THEN 0
			ELSE allocated_mb
		END) AS data_allocated_mb,
	SUM(
		CASE
			WHEN data_type = 'LOG' THEN 0
			ELSE used_mb
		END) AS data_used_mb,
	SUM(
		CASE
			WHEN data_type = 'LOG' THEN allocated_mb
			ELSE 0
		END) AS tlog_mb
FROM
	rpt.DatabaseAggByDay (NOLOCK)
GROUP BY
	monitor_date,
	server_name,
	database_name

--Bad approach for demo purpose only
--SELECT
--	a.monitor_date,
--	a.server_name,
--	a.database_name,
--	SUM(b.allocated_mb) AS data_allocated_mb,
--	SUM(b.used_mb) AS data_used_mb,
--	SUM(a.allocated_mb) AS tlog_mb
--FROM
--	(SELECT * FROM rpt.DatabaseDailyGrowth (NOLOCK) WHERE data_type = 'LOG') a
--	INNER JOIN (SELECT * FROM rpt.DatabaseDailyGrowth (NOLOCK) WHERE data_type <> 'LOG') b
--		ON a.monitor_date = b.monitor_date
--			AND a.server_name = b.server_name
--			AND a.database_name = b.database_name
--GROUP BY
--	a.monitor_date,
--	a.server_name,
--	a.database_name



GO
