SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW sl.vwDeadlock
AS
SELECT
	server_name,
	instance_name,
	NULL AS port,
	'master' AS database_name
FROM
	dbo.vwServerMonitors
WHERE
	monitor_name = 'Deadlock'
GO
