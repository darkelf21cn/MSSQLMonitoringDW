SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CheckTransactionLogFull]
AS
BEGIN
	--Create an issue if the issue is not being tracked.
	INSERT INTO dbo.lIssues (
		creation_dt,
		server_instance,
		client_name,
		monitor_id,
		tracking_guid,
		alert_guid,
		is_alerted
	)
	SELECT
		a.monitor_time,
		a.server_name AS server_instance,
		NULL AS client_name,
		c.monitor_id,
		a.tracking_guid,
		NEWID() AS alert_guid,
		0 AS is_alerted
	FROM
		dbo.vwTransactionLogFull a (NOLOCK)
		LEFT JOIN dbo.lIssues b (NOLOCK)
			ON a.tracking_guid = b.tracking_guid
		INNER JOIN dbo.bMonitoringObjects c (NOLOCK)
			ON c.monitor_name = 'TransactionLogUsage'
	WHERE
		b.tracking_guid IS NULL;

	--Close the issue if the issue has been resolved
	INSERT INTO dbo.lIssuesResolved (
		creation_dt,
		issue_id,
		server_instance,
		client_name,
		monitor_id,
		tracking_guid,
		alert_guid,
		resolved_dt
	)
	SELECT
		a.creation_dt,
		a.issue_id,
		a.server_instance,
		a.client_name,
		a.monitor_id,
		a.tracking_guid,
		a.alert_guid,
		GETDATE()
	FROM
		dbo.lIssues a
		INNER JOIN dbo.vwTransactionLogUsage b
			ON a.tracking_guid = b.tracking_guid
		LEFT JOIN dbo.vwTransactionLogFull c
			ON a.tracking_guid = c.tracking_guid
	WHERE
		c.tracking_guid IS NULL;

	DELETE a
	FROM
		dbo.lIssues a
		INNER JOIN dbo.vwTransactionLogUsage b
			ON a.tracking_guid = b.tracking_guid
		LEFT JOIN dbo.vwTransactionLogFull c
			ON a.tracking_guid = c.tracking_guid
	WHERE
		c.tracking_guid IS NULL;
END
GO
