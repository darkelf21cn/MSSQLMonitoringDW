SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[EmailMonitorErrors]
AS

IF (OBJECT_ID('dbo.tmpMonitorError')) IS NOT NULL
	DROP TABLE dbo.tmpMonitorError;
CREATE TABLE dbo.tmpMonitorError (
	monitor_time nvarchar(19) NULL,
	log_category nvarchar(128) NULL,
	server_name nvarchar(128) NULL,
	instance_name nvarchar(128) NULL,
	port nvarchar(128) NULL,
	status nvarchar(10) NULL,
	message nvarchar(max) NULL,
	elapsed_sec decimal(8, 1) NULL
);
CREATE CLUSTERED INDEX CIX_tmpMonitorError ON dbo.tmpMonitorError(monitor_time DESC, log_category ASC);

DECLARE @StartDate NVARCHAR(19) = CONVERT(NVARCHAR(19), DATEADD(HOUR, -1, GETDATE()), 120);
DECLARE @LogTable NVARCHAR(128);
DECLARE @Cmd NVARCHAR(MAX);
DECLARE logtable_cursor CURSOR FOR
SELECT DISTINCT load_log FROM dbo.bMonitoringObjects WHERE is_active = 1 AND load_log IS NOT NULL;
OPEN logtable_cursor;
FETCH NEXT FROM logtable_cursor INTO @LogTable;
WHILE (@@FETCH_STATUS = 0)
BEGIN
	SET @Cmd = 
N'INSERT INTO dbo.tmpMonitorError
SELECT TOP 200 CONVERT(NVARCHAR(19), monitor_time, 120), log_category, server_name, instance_name, port, status, message, elapsed_sec
FROM ' + @LogTable + N'
WHERE monitor_time > ''' + @StartDate + ''' AND status <> ''Completed''
ORDER BY monitor_time DESC';
	PRINT @Cmd;
	EXEC (@Cmd);
	FETCH NEXT FROM logtable_cursor INTO @LogTable;
END;
CLOSE logtable_cursor;
DEALLOCATE logtable_cursor;

IF NOT EXISTS (SELECT 1 FROM dbo.tmpMonitorError)
	GOTO Ending

--SELECT * FROM #monitor_error
DECLARE @DBName NVARCHAR(128) = DB_NAME();
DECLARE @MailProfileName NVARCHAR(128);
DECLARE @EmailSubject NVARCHAR(128);
DECLARE @EmailBody NVARCHAR(MAX);
DECLARE @HtmlTable NVARCHAR(MAX);
DECLARE @TO NVARCHAR(MAX);
DECLARE @CC NVARCHAR(MAX);
DECLARE @BCC NVARCHAR(MAX);
SELECT
	@EmailSubject = N'Top 200 Monitor Error In Last Hour',
	@MailProfileName = db_mail_profile_name,
	@TO = recipients,
	@CC = copy_recipients,
	@BCC = blind_copy_recipients
FROM
	dbo.bEmailConfigurations
WHERE
	email_group_name = 'dba'

--Send Email
EXEC dbo.Utility_GenerateHtmlTable 
    @DatabaseName = @DBName,
	@SchemaName = 'dbo',
    @ObjectName = 'tmpMonitorError',
    @OrderBy = '1 ASC, 2 ASC',
    @WithCss = 1,
    @Html = @HtmlTable output;
SET @EmailBody = N'';
SET @EmailBody += @HtmlTable;
PRINT @EmailBody;

EXEC msdb.dbo.sp_send_dbmail
	@profile_name = @MailProfileName,
    @recipients = @TO,
	@copy_recipients = @CC,
	@blind_copy_recipients = @BCC,
    @subject = @EmailSubject,  
    @body = @EmailBody , 
    @body_format = 'HTML';

Ending:
GO
