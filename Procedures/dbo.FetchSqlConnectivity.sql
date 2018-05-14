SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[FetchSqlConnectivity]
AS
BEGIN

SET NOCOUNT ON;

DECLARE @MonitorName NVARCHAR(128) = N'SqlConnectivity';
DECLARE @ServerName NVARCHAR(128) = N'NTGSQLMONITOR02';
DECLARE @MonitorDW NVARCHAR(128) = DB_NAME();
DECLARE @ScriptName NVARCHAR(128);
DECLARE @ScriptPath NVARCHAR(255);
DECLARE @ServerList NVARCHAR(255);
DECLARE @LoadDestination NVARCHAR(255);
DECLARE @Cmd NVARCHAR(MAX);

--Get monitor configurations
SELECT
	@ScriptName = script_name,
	@ScriptPath = script_path,
	@ServerList = server_list,
	@LoadDestination = load_destination_temp
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
SET @LoadDestination = N' /L:' + @ServerName + N'.' + @MonitorDW + '.' + @LoadDestination + N'.' + @MonitorName;
SET @Cmd = N'SqlcmdPlus.exe'+ @ServerList + @ScriptName + @LoadDestination + N' /Y:MSSQL /A:FALSE /S:TRUE'
SET @Cmd = N'EXEC xp_cmdshell ''' + @Cmd + N''';';
		
PRINT (@Cmd);
EXEC (@Cmd);
SET NOCOUNT OFF;
END;
GO
