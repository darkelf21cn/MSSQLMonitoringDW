SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [rpt].[vwServerDiskUsageByDataType]
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
		monitor_date,
		server_name,
		SUM(data_allocated_mb - data_used_mb) AS data_free_mb,
		SUM(data_used_mb) AS data_used_mb,
		SUM(tlog_mb) AS tlog_mb,
		SUM(data_allocated_mb + tlog_mb) AS total_mb
	FROM
		rpt.vwDatabaseAggByDay (NOLOCK)
	GROUP BY
		monitor_date,
		server_name
)
SELECT
	a.monitor_date,
	a.server_name,
	CASE
		WHEN (a.server_capacity_mb >= b.total_mb + a.server_free_mb) THEN a.server_free_mb / 1024
		ELSE (a.server_free_mb - (b.total_mb + a.server_free_mb - a.server_capacity_mb)) / 1024
	END AS server_free_gb,
	CASE
		WHEN (a.server_capacity_mb >= b.total_mb + a.server_free_mb) THEN (a.server_capacity_mb - b.total_mb - a.server_free_mb) / 1024
		ELSE 0
	END AS other_gb,
	b.data_free_mb / 1024 AS db_free_gb,
	b.data_used_mb / 1024 AS db_used_gb,
	b.tlog_mb / 1024 AS db_tlog_gb
FROM
	disk_info a
	INNER JOIN db_info b
		ON a.monitor_date = b.monitor_date
			AND a.server_name = b.server_name


GO
