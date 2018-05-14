SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vwDatabaseStatusError]
AS
SELECT
	a.server_name,
	a.database_name,
	a.user_access_desc AS user_access,
	a.state_desc AS database_status
FROM
	dbo.mDatabaseStatus a (NOLOCK)
	INNER JOIN dbo.vwServerMonitors b (NOLOCK)
		ON a.server_name = b.server_name
WHERE
	b.monitor_name = 'DatabaseStatus'
	AND a.monitor_time = (SELECT MAX(monitor_time) FROM dbo.mDatabaseStatus (NOLOCK))
	AND a.state_desc NOT IN ('ONLINE', 'RESTORING')
	AND NOT EXISTS (SELECT 'X' FROM dbo.cMaintenanceMode (NOLOCK) WHERE server_id = b.server_id AND GETDATE() BETWEEN maintenance_start_datetime AND maintenance_end_datetime)
	AND NOT EXISTS (SELECT 'X' FROM dbo.cAutoSuppression (NOLOCK) WHERE server_id = b.server_id AND monitor_id = b.monitor_id AND GETDATE() BETWEEN suppress_start_datetime AND suppress_end_datetime)



GO
