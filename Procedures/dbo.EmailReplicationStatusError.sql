SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EmailReplicationStatusError]
AS
BEGIN
IF NOT EXISTS (SELECT 1 FROM dbo.vwReplicationStatusError)
	GOTO Ending

DECLARE @MailProfileName NVARCHAR(128);
DECLARE @SmsMailBox NVARCHAR(128);
DECLARE @SmsSubject NVARCHAR(128);
DECLARE @EmailSubject NVARCHAR(128);
DECLARE @EmailBody NVARCHAR(MAX);
DECLARE @HtmlTable NVARCHAR(MAX);
DECLARE @TO NVARCHAR(MAX);
DECLARE @CC NVARCHAR(MAX);
DECLARE @BCC NVARCHAR(MAX);
DECLARE @DBName NVARCHAR(128) = DB_NAME();
DECLARE @MonitorID INT;
DECLARE @SuppressMinutes INT;

SELECT TOP 1 
	@MailProfileName = db_mail_profile_name,
	@TO = recipients,
	@CC = copy_recipients,
	@BCC = blind_copy_recipients,
	@SmsMailBox = sms_mail_box
FROM
	dbo.bEmailConfigurations
WHERE
	email_group_name = 'dba'

SELECT
	@MonitorID = monitor_id,
	@EmailSubject = email_subject,
	@SmsSubject = sms_subject,
	@SuppressMinutes = auto_suppression_minutes
FROM
	bMonitoringObjects
WHERE
	monitor_name = 'ReplicationStatus';

--Send Email
EXEC dbo.Utility_GenerateHtmlTable 
    @DatabaseName = @DBName,
	@SchemaName = 'dbo',
    @ObjectName = 'vwReplicationStatusError',
    @OrderBy = '1 ASC, 2 ASC',
    @WithCss = 1,
    @Html = @HtmlTable output;
SET @EmailBody = N'<h3 style="font-family:Arial,Verdana; font-size:13px; color:red">Please check the replication monitor to see detail information.</h3>
';
SET @EmailBody += @HtmlTable;
IF @SuppressMinutes > 0
	SET @EmailBody += N'<h4 style="font-family:Arial,Verdana; font-size:13px;">Alert for this issue has been suppressed for [' + CONVERT(NVARCHAR(4), @SuppressMinutes) + '] minutes to prevent noise.</h4>';
PRINT @EmailBody;

EXEC msdb.dbo.sp_send_dbmail
	@profile_name = @MailProfileName,
    @recipients = @TO,
	@copy_recipients = @CC,
	@blind_copy_recipients = @BCC,
    @subject = @EmailSubject,  
    @body = @EmailBody , 
    @body_format = 'HTML';

--Suppress to aviod duplicate alerts based on the configuration of auto_suppression_minutes in dbo.bMonitoringObjects.
IF @SuppressMinutes > 0
BEGIN
	INSERT INTO cAutoSuppression (server_id, monitor_id, suppress_start_datetime, suppress_end_datetime)
	SELECT DISTINCT b.server_id, @MonitorID, GETDATE(), DATEADD(MINUTE, @SuppressMinutes, GETDATE())
	FROM
		dbo.vwReplicationStatusError a
		INNER JOIN dbo.bServerInventory b (NOLOCK)
			ON a.distributor = b.server_name
END

Ending:
END
GO
