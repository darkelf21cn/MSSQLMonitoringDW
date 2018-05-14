SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwDatabaseBackup]
AS
SELECT
	a.server_name,
	a.database_name,
	a.recovery_model_desc,
	c.last_full_backup_date,
	c.last_diff_backup_date,
	c.last_log_backup_date
FROM
	dbo.vwTransactionLogUsage a
	INNER JOIN sl.vwDatabaseBackup b
		ON a.server_name = b.server_name
	LEFT JOIN (
		SELECT
			server_name,
			database_name,
			MAX(CASE WHEN backup_type = 'D' THEN backup_finish_date END) AS last_full_backup_date,
			MAX(CASE WHEN backup_type = 'I' THEN backup_finish_date END) AS last_diff_backup_date,
			MAX(CASE WHEN backup_type = 'L' THEN backup_finish_date END) AS last_log_backup_date
		FROM
			dbo.mDatabaseBackup
		GROUP BY
			server_name,
			database_name
	) c
		ON a.server_name = c.server_name
			AND a.database_name = c.database_name
WHERE
	a.database_name NOT IN ('tempdb', 'model')
GO
