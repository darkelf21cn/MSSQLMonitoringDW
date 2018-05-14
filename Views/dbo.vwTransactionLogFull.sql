SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTransactionLogFull]
AS
WITH tlog
AS (
	SELECT
		a.*
	FROM
		dbo.vwTransactionLogUsage a
		INNER JOIN dbo.vwServerMonitors b (NOLOCK)
			ON a.server_name = b.server_name
	WHERE
		b.monitor_name = 'TransactionLogUsage'
		AND NOT EXISTS (SELECT 'X' FROM dbo.cMaintenanceMode (NOLOCK) WHERE server_id = b.server_id AND GETDATE() BETWEEN maintenance_start_datetime AND maintenance_end_datetime)
		AND NOT EXISTS (SELECT 'X' FROM dbo.cAutoSuppression (NOLOCK) WHERE server_id = b.server_id AND monitor_id = b.monitor_id AND GETDATE() BETWEEN suppress_start_datetime AND suppress_end_datetime)
)
SELECT
	*
FROM
	tlog
WHERE
	--Log reuse is waiting for active transactions and usage is high and disk could not provide enough space to auto extend.
	(log_reuse_wait_desc IN ('ACTIVE_TRANSACTION')
	AND log_usage_pct > 80
	AND log_size_mb / 100.0 * (100 - log_usage_pct) < 51200
	AND log_max_growth_mb < 30720)
	--Log reuse is waiting for something else than active transaction and usage is high.
	OR 
	(log_reuse_wait_desc NOT IN ('NOTHING', 'ACTIVE_TRANSACTION')
	AND log_usage_pct > 90
	AND log_size_mb / 100.0 * (100 - log_usage_pct) < 20480
	AND log_max_growth_mb < 20480)
GO
