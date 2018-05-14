SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTransactionLogFull]
AS
SELECT
	monitor_time,
	server_name,
	database_name,
	tracking_guid,
	log_size_mb,
	log_usage_pct,
	log_reuse_wait_desc,
	recovery_model_desc,
	log_max_growth_mb
FROM
	dbo.vwTransactionLogUsage
WHERE
	-- Log is unable to reuse and the log usage > 85% and meet at lease one of the following conditions:
	-- 1) log file is not able to extend.
	-- 2) log file has already exceeded 200GB. 
	log_reuse_wait_desc NOT IN ('NOTHING')
	AND log_usage_pct > 85
	AND (
		(log_size_mb / 100.0 * (100 - log_usage_pct) < 20480 AND log_max_growth_mb < 20480)
		OR (log_size_mb > 204800)
	)
GO
