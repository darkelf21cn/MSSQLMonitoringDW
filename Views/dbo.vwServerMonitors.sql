SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwServerMonitors]
AS
SELECT
	a.server_id,
	a.server_name,
	a.instance_name,
	c.monitor_id,
	c.monitor_name
FROM
	dbo.bServerInventory a WITH (NOLOCK)
	INNER JOIN dbo.rServerMonitor b WITH (NOLOCK) ON a.server_id = b.server_id
	INNER JOIN dbo.bMonitoringObjects c WITH (NOLOCK) ON b.monitor_id = c.monitor_id
WHERE
	a.is_active = 1
	AND b.is_active = 1
	AND c.is_active = 1;


GO
