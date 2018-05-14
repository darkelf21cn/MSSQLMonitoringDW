SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[FetchMonitoringData] (
	@MonitorName NVARCHAR(128)
)
AS
BEGIN

SET NOCOUNT ON;

DECLARE @ServerName NVARCHAR(128) = 'NTGSQLMONITOR02';
DECLARE @MonitorDW NVARCHAR(128) = DB_NAME();
DECLARE @ScriptName NVARCHAR(128);
DECLARE @ScriptPath NVARCHAR(255);
DECLARE @ServerList NVARCHAR(255);
DECLARE @LoadDestination NVARCHAR(255);
DECLARE @LogTable NVARCHAR(255);
DECLARE @Cmd NVARCHAR(MAX);

--Get monitor configurations
SELECT
	@ScriptName = script_name,
	@ScriptPath = script_path,
	@ServerList = server_list,
	@LoadDestination = load_destination_temp,
	@LogTable = load_log
FROM
	dbo.bMonitoringObjects
WHERE
	monitor_name = @MonitorName;

--Clean all results before data import
SET @Cmd = 
N'IF (OBJECT_ID(''' + @MonitorDW + '.' + @LoadDestination + ''') IS NOT NULL)
    TRUNCATE TABLE ' + @MonitorDW + '.' + @LoadDestination;
PRINT @Cmd;
EXEC (@Cmd);

--Set parameters
SET @ServerList = N' /D:' + @ServerName + N'.' + @MonitorDW + N'.' + @ServerList;
SET @ScriptName = N' /I:"'+ @ScriptPath + @ScriptName + N'"'
SET @LoadDestination = N' /B:'+ @ServerName + N'.' + @MonitorDW + N'.' + @LoadDestination;
SET @LogTable = N' /L:' + @ServerName + N'.' + @MonitorDW + '.' + @LogTable + N'.' + @MonitorName;
SET @Cmd = N'SqlcmdPlus.exe'+ @ServerList + @ScriptName + @LoadDestination + @LogTable + N' /Y:MSSQL /A:FALSE /S:TRUE'
SET @Cmd = N'EXEC xp_cmdshell ''' + @Cmd + N''';';
		
PRINT (@Cmd);
EXEC (@Cmd);
SET NOCOUNT OFF;
END;




GO
