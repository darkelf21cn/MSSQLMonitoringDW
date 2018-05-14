SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [rpt].[vwServerDiskUsageByDB]
AS
WITH disk_info
AS
(
	SELECT
		monitor_date,
		server_name,
		SUM(drive_free_mb) AS server_free_mb,
		SUM(drive_capacity_mb) AS server_capacity_mb
	FROM
		rpt.DiskSizeAggByDay (NOLOCK)
	WHERE
		drive_name NOT IN ('C')
	GROUP BY
		monitor_date,
		server_name
),
db_info
AS (
	SELECT
		ROW_NUMBER() OVER(PARTITION BY monitor_date, server_name ORDER BY size_mb DESC) AS sort,
		* 
	FROM
		(
		SELECT
			monitor_date,
			server_name,
			database_name,
			(data_allocated_mb + tlog_mb) AS size_mb
		FROM
			rpt.vwDatabaseAggByDay (NOLOCK)
		WHERE
			database_name NOT IN ('master', 'msdb', 'tempdb', 'model')) a
	UNION
	SELECT
		0 AS sort,
		monitor_date,
		server_name,
		'SYSTEM' AS database_name,
		SUM(data_allocated_mb + tlog_mb) AS size_mb
	FROM
		rpt.vwDatabaseAggByDay (NOLOCK)
	WHERE
		database_name IN ('master', 'msdb', 'tempdb', 'model')
	GROUP BY
		monitor_date,
		server_name
)
SELECT
	a.monitor_date,
	a.server_name,
	0 AS sort,
	'OTHERS' AS category,
	CASE
		WHEN b.server_capacity_mb < b.server_free_mb + a.size_mb THEN 0
		ELSE (b.server_capacity_mb - b.server_free_mb - a.size_mb) / 1024
	END AS size_gb
FROM
	(SELECT monitor_date, server_name, SUM(size_mb) AS size_mb FROM db_info WHERE sort <= 5 GROUP BY monitor_date, server_name) a
	INNER JOIN disk_info b
		ON a.monitor_date = b.monitor_date
			AND a.server_name = b.server_name
UNION
SELECT
	a.monitor_date,
	a.server_name,
	99 AS sort,
	'FREE' AS category,
	CASE
		WHEN b.server_capacity_mb < b.server_free_mb + a.size_mb THEN (b.server_capacity_mb - a.size_mb) / 1024
		ELSE server_free_mb / 1024
	END AS size_gb
FROM
	(SELECT monitor_date, server_name, SUM(size_mb) AS size_mb FROM db_info WHERE sort <= 5 GROUP BY monitor_date, server_name) a
	INNER JOIN disk_info b
		ON a.monitor_date = b.monitor_date
			AND a.server_name = b.server_name
UNION
SELECT
	monitor_date,
	server_name,
	sort + 10,
	database_name AS category,
	size_mb / 1024 AS size_gb
FROM
	db_info
WHERE
	sort <= 5




GO
