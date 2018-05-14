SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.RetentionMonitorErrors (
	@Hours INT = 48
)
AS

DECLARE @StartDate NVARCHAR(19) = CONVERT(NVARCHAR(19), DATEADD(HOUR, 1 - @Hours, GETDATE()), 120);
DECLARE @LogTable NVARCHAR(128);
DECLARE @Cmd NVARCHAR(MAX);
DECLARE logtable_cursor CURSOR FOR
SELECT DISTINCT load_log FROM dbo.bMonitoringObjects WHERE is_active = 1 AND load_log IS NOT NULL;
OPEN logtable_cursor;
FETCH NEXT FROM logtable_cursor INTO @LogTable;
WHILE (@@FETCH_STATUS = 0)
BEGIN
	SET @Cmd = 
N'DELETE FROM ' + @LogTable + N'
WHERE monitor_time < ''' + @StartDate + '''';
	PRINT @Cmd;
	EXEC (@Cmd);
	FETCH NEXT FROM logtable_cursor INTO @LogTable;
END;
CLOSE logtable_cursor;
DEALLOCATE logtable_cursor;
GO
