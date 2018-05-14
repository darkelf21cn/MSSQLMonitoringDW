SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwReplicationStatusError]
AS
SELECT
	a.monitor_time,
    a.publisher,
    a.publisher_db,
    a.distributor,
    a.publication_name,
    a.subscriber,
    a.subscriber_db,
    a.subscription_type,
    a.delivery_rate,
    a.pending_cmds,
    a.latency_sec,
    a.error_code,
    a.error_text
FROM
	dbo.mReplicationStatus a (NOLOCK)
	INNER JOIN dbo.vwServerMonitors b (NOLOCK)
		ON a.distributor = b.server_name
WHERE
	(
		a.error_code IS NOT NULL
		OR (
			a.pending_cmds > 100000
			AND a.latency_sec > 600
		)
		OR (
			a.delivery_rate IS NULL
			AND a.latency_sec IS NULL
		)
	)
	AND b.monitor_name = 'ReplicationStatus'
	AND NOT EXISTS (SELECT 'X' FROM dbo.cMaintenanceMode (NOLOCK) WHERE server_id = b.server_id AND GETDATE() BETWEEN maintenance_start_datetime AND maintenance_end_datetime)
	AND NOT EXISTS (SELECT 'X' FROM dbo.cAutoSuppression (NOLOCK) WHERE server_id = b.server_id AND monitor_id = b.monitor_id AND GETDATE() BETWEEN suppress_start_datetime AND suppress_end_datetime)
GO
