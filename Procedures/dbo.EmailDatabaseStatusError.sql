SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[EmailDatabaseStatusError]
AS
BEGIN

IF NOT EXISTS (SELECT 1 FROM dbo.vwDatabaseStatusError)
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
	monitor_name = 'DatabaseStatus';

--Send Email
EXEC dbo.Utility_GenerateHtmlTable 
    @DatabaseName = @DBName,
	@SchemaName = 'dbo',
    @ObjectName = 'vwDatabaseStatusError',
    @OrderBy = '1 ASC, 2 ASC',
    @WithCss = 1,
    @Html = @HtmlTable output;
SET @EmailBody = N'<h3 style="font-family:Arial,Verdana; font-size:13px; color:red">Please check the SQL error log to see why the database status flipped.</h3>
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

--Send SMS
--[SEV1] [%1][%2] Database running into [%3] status.
DECLARE @ServerName NVARCHAR(128);
DECLARE @DatabaseName NVARCHAR(128);
DECLARE @DatabaseStatus NVARCHAR(128);
DECLARE cursor_by_server CURSOR FOR
SELECT server_name, database_name, database_status FROM dbo.vwDatabaseStatusError;

OPEN cursor_by_server;
FETCH NEXT FROM cursor_by_server INTO @ServerName, @DatabaseName, @DatabaseStatus
WHILE (@@FETCH_STATUS = 0)
BEGIN
	SET @SmsSubject = REPLACE(REPLACE(REPLACE(@SmsSubject, '%1', @ServerName), '%2', @DatabaseName), '%3', @DatabaseStatus);
	PRINT @SmsSubject;
	EXEC msdb.dbo.sp_send_dbmail
		@profile_name = @MailProfileName,
		@recipients = @SmsMailBox,  
		@subject = @SmsSubject,  
		@body = '' , 
		@body_format = 'HTML';
	FETCH NEXT FROM cursor_by_server INTO @ServerName, @DatabaseName, @DatabaseStatus
END;
CLOSE cursor_by_server;
DEALLOCATE cursor_by_server;

--Suppress to aviod duplicate alerts based on the configuration of auto_suppression_minutes in dbo.bMonitoringObjects.
IF @SuppressMinutes > 0
BEGIN
	INSERT INTO cAutoSuppression (server_id, monitor_id, suppress_start_datetime, suppress_end_datetime)
	SELECT DISTINCT b.server_id, @MonitorID, GETDATE(), DATEADD(MINUTE, @SuppressMinutes, GETDATE())
	FROM
		dbo.vwDatabaseStatusError a
		INNER JOIN dbo.bServerInventory b (NOLOCK)
			ON a.server_name = b.server_name
END;

Ending:
END









GO
