SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PushAlerts]
AS
BEGIN
	DECLARE @DateTime DATETIME;
	DECLARE @MonitorName NVARCHAR(128);
	DECLARE @PreventDuplicateAlert BIT;
	DECLARE @AutoSuppressionMinutes INT;
	DECLARE @ServerInstance NVARCHAR(128);
	DECLARE @AlertGuid UNIQUEIDENTIFIER;
	DECLARE @SmsMsg VARCHAR(140);

	--Push new triggered ALERT message 
	DECLARE alert_cur CURSOR LOCAL FAST_FORWARD FOR
	SELECT
		a.creation_dt,
		b.monitor_name,
		b.prevent_duplicate_alert,
		b.auto_suppression_minutes,
		a.server_instance,
		a.alert_guid
	FROM
		dbo.lIssues a
		INNER JOIN dbo.bMonitoringObjects b (NOLOCK)
			ON a.monitor_id = b.monitor_id
	WHERE
		a.is_alerted = 0

	OPEN alert_cur;
	FETCH NEXT FROM alert_cur INTO @DateTime, @MonitorName, @PreventDuplicateAlert, @AutoSuppressionMinutes, @ServerInstance, @AlertGuid;
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		--[ALERT!] SqlConnectivity error on [aaaaaaaaaaaaaaaaaaa] was detected at 2017-01-01 00:00:00
		SET @SmsMsg = LEFT('[ALERT!] ' + @MonitorName + ' error on [' + @ServerInstance + '] was detected at ' + CONVERT(CHAR(19), @DateTime, 120), 140)
		--PRINT @SmsMsg

		EXEC dbo.ClrCreateAlert
			@InstanceName = @ServerInstance,
			@ClientName = NULL,
			@Category = @MonitorName,
			@TraceId = @AlertGuid,
			@SmsBody = @SmsMsg,
			@EmailBody = NULL;

		UPDATE lIssues
		SET
			is_alerted = 1,
			suppress_until = CASE
				WHEN @PreventDuplicateAlert = 1 THEN NULL
				WHEN @PreventDuplicateAlert = 0 THEN DATEADD(MINUTE, @AutoSuppressionMinutes, GETDATE())
			END
		WHERE
			alert_guid = @AlertGuid

		FETCH NEXT FROM alert_cur INTO @DateTime, @MonitorName, @PreventDuplicateAlert, @AutoSuppressionMinutes, @ServerInstance, @AlertGuid;
	END
	CLOSE alert_cur;
	DEALLOCATE alert_cur;

	--Push remind message if the issue still persist and suppression period is over
	DECLARE remind_cur CURSOR LOCAL FAST_FORWARD FOR
	SELECT
		a.creation_dt,
		b.monitor_name,
		b.prevent_duplicate_alert,
		b.auto_suppression_minutes,
		a.server_instance,
		a.alert_guid
	FROM
		dbo.lIssues a
		INNER JOIN dbo.bMonitoringObjects b (NOLOCK)
			ON a.monitor_id = b.monitor_id
	WHERE
		a.is_alerted = 1
		AND a.suppress_until < GETDATE()

	OPEN remind_cur;
	FETCH NEXT FROM remind_cur INTO @DateTime, @MonitorName, @PreventDuplicateAlert, @AutoSuppressionMinutes, @ServerInstance, @AlertGuid;
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		--[REMIND] SqlConnectivity error on [aaaaaaaaaaaaaaaaaaa] has persisted for 10 minutes
		SET @SmsMsg = LEFT('[REMIND] ' + @MonitorName + ' error on [' + @ServerInstance + '] has persisted for ' + DATEDIFF(MINUTE, GETDATE(), @DateTime) + 'minutes', 140)
		--PRINT @SmsMsg

		EXEC dbo.ClrCreateAlert
			@InstanceName = @ServerInstance,
			@ClientName = NULL,
			@Category = @MonitorName,
			@TraceId = @AlertGuid,
			@SmsBody = @SmsMsg,
			@EmailBody = NULL;

		UPDATE lIssues
		SET
			is_alerted = 1,
			suppress_until = CASE
				WHEN @PreventDuplicateAlert = 1 THEN NULL
				WHEN @PreventDuplicateAlert = 0 THEN DATEADD(MINUTE, @AutoSuppressionMinutes, GETDATE())
			END
		WHERE
			alert_guid = @AlertGuid

		FETCH NEXT FROM remind_cur INTO @DateTime, @MonitorName, @PreventDuplicateAlert, @AutoSuppressionMinutes, @ServerInstance, @AlertGuid;
	END
	CLOSE remind_cur;
	DEALLOCATE remind_cur;

	--Push alert close message for those issues already resolved
	DECLARE close_cur CURSOR LOCAL FAST_FORWARD FOR
	SELECT
		a.resolved_dt,
		b.monitor_name,
		b.prevent_duplicate_alert,
		b.auto_suppression_minutes,
		a.server_instance,
		a.alert_guid
	FROM
		dbo.lIssuesResolved a
		INNER JOIN dbo.bMonitoringObjects b (NOLOCK)
			ON a.monitor_id = b.monitor_id;

	OPEN close_cur;
	FETCH NEXT FROM close_cur INTO @DateTime, @MonitorName, @PreventDuplicateAlert, @AutoSuppressionMinutes, @ServerInstance, @AlertGuid;
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		--[RESOLVED] SqlConnectivity error on [aaaaaaaaaaaaaaaaaaa] was resolved at 2017-01-01 00:00:00
		SET @SmsMsg = LEFT('[RESOLVED] ' + @MonitorName + ' error on [' + @ServerInstance + '] was resolved at ' + CONVERT(CHAR(19), @DateTime, 120), 140)
		--PRINT @SmsMsg

		EXEC dbo.ClrCloseAlert
			@InstanceName = @ServerInstance,
			@ClientName = NULL,
			@Category = @MonitorName,
			@TraceId = @AlertGuid,
			@SmsBody = @SmsMsg,
			@EmailBody = NULL;

		INSERT INTO dbo.lIssuesHist (
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
			creation_dt,
			issue_id,
			server_instance,
			client_name,
			monitor_id,
			tracking_guid,
			alert_guid,
			resolved_dt
		FROM
			dbo.lIssuesResolved
		WHERE
			alert_guid = @AlertGuid;

		DELETE FROM dbo.lIssuesResolved WHERE alert_guid = @AlertGuid;

		FETCH NEXT FROM close_cur INTO @DateTime, @MonitorName, @PreventDuplicateAlert, @AutoSuppressionMinutes, @ServerInstance, @AlertGuid;
	END
	CLOSE close_cur;
	DEALLOCATE close_cur;
END
GO
