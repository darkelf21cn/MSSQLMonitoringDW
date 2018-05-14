SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwConnectivityError]
AS
SELECT
	a.monitor_time,
	a.server_name,
	a.result AS error_msg
FROM
	dbo.vwConnectivity a (NOLOCK)
	INNER JOIN dbo.lIssues b (NOLOCK)
		ON a.tracking_guid = b.tracking_guid
WHERE
	b.tracking_guid IS NULL
	OR b.suppress_until < GETDATE()
	OR b.is_alerted = 0;
GO
