SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[EmailSQLAgentJobStatus]
AS
BEGIN

IF OBJECT_ID('tempdb..#AgentJobStatusAlert') IS NOT NULL
	DROP TABLE #AgentJobStatusAlert;

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
DECLARE @EmailGroup NVARCHAR(128);

SELECT
	@MonitorID = monitor_id,
	@EmailSubject = email_subject,
	@SmsSubject = sms_subject,
	@SuppressMinutes = auto_suppression_minutes
FROM
	bMonitoringObjects
WHERE
	monitor_name = 'SQLAgentJobStatus';

SELECT *
INTO #AgentJobStatusAlert
FROM
	dbo.vwAgentJobStatusAlert
WHERE
	should_alert = 1
	AND DATEADD(MINUTE, @SuppressMinutes, ISNULL(last_email_time, '1900-01-01')) < GETDATE(); --Suppression checking.

IF NOT EXISTS (SELECT 1 FROM #AgentJobStatusAlert)
	GOTO Ending

DECLARE EmailGroupCursor CURSOR FOR
SELECT DISTINCT email_group_name FROM #AgentJobStatusAlert;
OPEN EmailGroupCursor;
FETCH NEXT FROM EmailGroupCursor INTO @EmailGroup;
WHILE (@@FETCH_STATUS = 0)
BEGIN
	--Get email profile 
	SELECT TOP 1 
		@MailProfileName = db_mail_profile_name,
		@TO = recipients,
		@CC = copy_recipients,
		@BCC = blind_copy_recipients,
		@SmsMailBox = sms_mail_box
	FROM
		dbo.bEmailConfigurations
	WHERE
		email_group_name = @EmailGroup
	
	--Aggreate 3 type of alerts into 1.
	TRUNCATE TABLE dbo.tmpAgentJobStatusAlert;
	INSERT INTO dbo.tmpAgentJobStatusAlert
	SELECT
		CONVERT(NCHAR(19), monitor_time, 120) AS monitor_time,
		server_name,
		job_name,
		error_msg
	FROM
		#AgentJobStatusAlert
	WHERE
		email_group_name = @EmailGroup;

	--Send Email
	EXEC dbo.Utility_GenerateHtmlTable 
		@DatabaseName = @DBName,
		@SchemaName = 'dbo',
		@ObjectName = 'tmpAgentJobStatusAlert',
		@OrderBy = '1 ASC',
		@WithCss = 1,
		@Html = @HtmlTable output;
	SET @EmailBody = N'<h3 style="font-family:Arial,Verdana; font-size:13px; color:red">SQL agent job is not running as expected.</h3>
	';
	SET @EmailBody += @HtmlTable;
	IF @SuppressMinutes > 0
		SET @EmailBody += N'<h4 style="font-family:Arial,Verdana; font-size:13px;">Alert will not be sent our for same job failure in next [' + CONVERT(NVARCHAR(4), @SuppressMinutes) + '] minutes.</h4>';
	PRINT @EmailBody;

	EXEC msdb.dbo.sp_send_dbmail
		@profile_name = @MailProfileName,
		@recipients = @TO,
		@copy_recipients = @CC,
		@blind_copy_recipients = @BCC,
		@subject = @EmailSubject,  
		@body = @EmailBody , 
		@body_format = 'HTML';

	--Suppress alerts
	UPDATE a
	SET
		last_error_occurred_time = c.last_run_time,
		last_email_time = GETDATE()
	FROM
		dbo.bCriticalAgentJobs a
		INNER JOIN dbo.bServerInventory b
			ON a.server_id = b.server_id
		INNER JOIN #AgentJobStatusAlert c
			ON b.server_name = c.server_name
				AND a.job_name = c.job_name
	WHERE
		a.email_group_name = @EmailGroup;

	FETCH NEXT FROM EmailGroupCursor INTO @EmailGroup;
END
CLOSE EmailGroupCursor;
DEALLOCATE EmailGroupCursor;

Ending:
END











GO
