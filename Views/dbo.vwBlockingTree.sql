SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwBlockingTree]
AS
SELECT TOP 10000000 --Force order
    CONVERT(VARCHAR(19), a.monitor_time, 120) AS monitor_time,
    a.server_name,
    a.database_name,
    a.blocking_tree,
	blocking_tree_order,
    a.host_name,
    a.login_name,
	a.program_name,
	a.status,
    a.last_wait_type,
    a.wait_time_ms,
	a.wait_resource,
	CASE
		WHEN LEN(a.individual_query) > 200 THEN LEFT(a.individual_query, 200) + '...'
		ELSE a.individual_query
	END AS individual_query,
	CASE
		WHEN LEN(a.entire_query) > 200 THEN LEFT(a.entire_query, 200) + '...'
		ELSE a.entire_query
	END AS entire_query
FROM
    dbo.mBlocking a (NOLOCK)
    INNER JOIN dbo.vwServerMonitors b (NOLOCK)
        ON a.server_name = b.server_name
WHERE
    b.monitor_name = 'Blocking'
    AND NOT EXISTS (SELECT 'X' FROM dbo.cMaintenanceMode (NOLOCK) WHERE server_id = b.server_id AND GETDATE() BETWEEN maintenance_start_datetime AND maintenance_end_datetime)
    AND NOT EXISTS (SELECT 'X' FROM dbo.cAutoSuppression (NOLOCK) WHERE server_id = b.server_id AND monitor_id = b.monitor_id AND GETDATE() BETWEEN suppress_start_datetime AND suppress_end_datetime)
ORDER BY
	a.server_name,
    a.blocking_tree_order;
GO
