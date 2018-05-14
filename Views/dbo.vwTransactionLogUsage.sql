SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwTransactionLogUsage]
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
	dbo.mTransactionLogCurrentUsage
GO
