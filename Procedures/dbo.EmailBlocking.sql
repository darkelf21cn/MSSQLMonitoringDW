SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EmailBlocking]
AS
BEGIN

IF NOT EXISTS (SELECT 1 FROM dbo.vwBlockingTree)
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
DECLARE @EmailGroupName NVARCHAR(128);

DECLARE Clients CURSOR FOR 
SELECT DISTINCT
	email_group_name
FROM
	dbo.vwBlockingTree a
	INNER JOIN dbo.vwServerProjects b
		ON a.server_name = b.server_name;

OPEN Clients;
FETCH NEXT FROM Clients INTO @EmailGroupName;

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT TOP 1 
		@MailProfileName = db_mail_profile_name,
		@TO = recipients,
		@CC = copy_recipients + N'jaxiao@acxiom.com;' ,
		@BCC = blind_copy_recipients,
		@SmsMailBox = sms_mail_box
	FROM
		dbo.bEmailConfigurations
	WHERE
		email_group_name = @EmailGroupName;

	IF (@TO IS NULL)
	BEGIN
		FETCH NEXT FROM Clients INTO @EmailGroupName;
		CONTINUE;
	END

	SELECT
		@MonitorID = monitor_id,
		@EmailSubject = email_subject,
		@SmsSubject = sms_subject,
		@SuppressMinutes = auto_suppression_minutes
	FROM
		bMonitoringObjects
	WHERE
		monitor_name = 'Blocking';
	
	TRUNCATE TABLE dbo.emlBlocking
	INSERT INTO dbo.emlBlocking (
		monitor_time,
		server_name,
		database_name,
		blocking_tree,
		host_name,
		login_name,
		program_name,
		status,
		last_wait_type,
		wait_time_ms,
		wait_resource,
		individual_query,
		entire_query
	)
	SELECT
		a.monitor_time,
		a.server_name,
		a.database_name,
		a.blocking_tree,
		a.host_name,
		a.login_name,
		a.program_name,
		a.status,
		a.last_wait_type,
		a.wait_time_ms,
		a.wait_resource,
		a.individual_query,
		a.entire_query
	FROM
		dbo.vwBlockingTree a
		INNER JOIN dbo.vwServerProjects b
			ON a.server_name = b.server_name
	WHERE
		b.email_group_name = @EmailGroupName
	ORDER BY
		a.monitor_time,
		a.server_name,
		a.blocking_tree_order;

	--Send Email
	EXEC dbo.Utility_GenerateHtmlTable 
		@DatabaseName = @DBName,
		@SchemaName = 'dbo',
		@ObjectName = 'emlBlocking',
		@OrderBy = '1 ASC',
		@WithCss = 1,
		@Html = @HtmlTable output;
	SET @EmailBody = N'<h3 style="font-family:Arial,Verdana; font-size:13px;">Following sessions has been blocked more than 60s. Please find more details from URL below:</h3>
	                   <h3 style="font-family:Arial,Verdana; font-size:13px;">http://ntgsqlmonitor02/ReportServer/Pages/ReportViewer.aspx?%2fDatabaseDashboard%2fSQLServerBlocking&rs:Command=Render</h3>
	';
	SET @EmailBody += @HtmlTable;
	IF @SuppressMinutes > 0
		SET @EmailBody += N'<h4 style="font-family:Arial,Verdana; font-size:13px;">Alert for this issue has been suppressed for [' + CONVERT(NVARCHAR(4), @SuppressMinutes) + '] minutes to prevent noise.</h4>';
	--PRINT @EmailBody;

	EXEC msdb.dbo.sp_send_dbmail
		@profile_name = @MailProfileName,
		@recipients = @TO,
		@copy_recipients = @CC,
		@blind_copy_recipients = @BCC,
		@subject = @EmailSubject,  
		@body = @EmailBody , 
		@body_format = 'HTML';

	FETCH NEXT FROM Clients INTO @EmailGroupName;
END

CLOSE Clients;
DEALLOCATE Clients;

--Suppress to aviod duplicate alerts based on the configuration of auto_suppression_minutes in dbo.bMonitoringObjects.
IF @SuppressMinutes > 0
BEGIN
	INSERT INTO cAutoSuppression (server_id, monitor_id, suppress_start_datetime, suppress_end_datetime)
	SELECT DISTINCT b.server_id, @MonitorID, GETDATE(), DATEADD(MINUTE, @SuppressMinutes, GETDATE())
	FROM
		dbo.vwBlockingTree a
		INNER JOIN dbo.bServerInventory b (NOLOCK)
			ON a.server_name = b.server_name
END;

Ending:
END
GO
