SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- ======================================================================================
-- Author: kimiwang
-- Description: This sp is used for generating html table from table or view. 
-- Release History:
--   2.1 2016-12-19 Replace /n [CHAR(10)] with <br />.
--   2.0 2016-10-14 Remove unnecessary parameter and optmize the logical. 
--   1.1 2014-03-21 Add @columns parameter to let user filter the columns.
--                  Add @WithCss option to let user control whether generate CSS code.
--   1.0 2013-06-09 First version
-- ======================================================================================
CREATE PROCEDURE [dbo].[Utility_GenerateHtmlTable](
    @DatabaseName NVARCHAR(128) = NULL,  --Put database name here, no default value
    @SchemaName NVARCHAR(128) = 'dbo', --Put schema name here, default: dbo
    @ObjectName NVARCHAR(128), --Put table/view name here, no default value
    @OrderBy NVARCHAR(MAX) = '', --Put order by expression here, default: empty, example: column1 desc, column2 asc) 
    @WithCss BIT = 1, --Put 0 if you do NOT want to have html with css style, default: 1
    @Html NVARCHAR(MAX) = '' OUTPUT      
)
AS 

SET NOCOUNT ON;

SET @DatabaseName = ISNULL(@DatabaseName, DB_NAME());

--Define CSS style 
DECLARE @Css NVARCHAR(MAX) = N'';
IF (@WithCss = 1)
BEGIN
    SET @Css = 
N'<style type="text/css" font-family : Arial, Verdana;font-size:13px> 
    table.tftable {font-family:Arial,Verdana; font-size:12px; padding:4px; border-collapse:collapse; border-style:solid; text-align:left;}
    table.tftable th {background-color:#abd28e; border-color:#abd28e; text-align:center;}
    table.tftable tr {background-color:#ffffff;}
    table.tftable td {border-color:#abd28e;}
</style>
'
END

--Create a temp table to store the name and type of columns.
IF Object_id('tempdb..#columns') IS NOT NULL 
    DROP TABLE #columns;
CREATE TABLE #columns 
( 
    column_name NVARCHAR(128)
);

--Fetch column information from sys.columns
DECLARE @Cmd NVARCHAR (MAX);
SET @Cmd = 
'SELECT c.name 
FROM
    [' + @DatabaseName + '].sys.columns c
    INNER JOIN [' + @DatabaseName + '].sys.objects o
        ON c.object_id = o.object_id
    INNER JOIN [' + @DatabaseName + '].sys.schemas s
        ON o.schema_id = s.schema_id
WHERE
    s.name = ''' + @SchemaName + '''
    AND o.name = ''' + @ObjectName + '''';

INSERT INTO #columns (column_name)
EXEC (@Cmd);
IF NOT EXISTS (SELECT 1 FROM #columns)
BEGIN  
    RAISERROR('The table or view you specified does not exist.', 16, 1);
    RETURN;
END  

DECLARE @ColumnName NVARCHAR(128);
DECLARE @TableHeader NVARCHAR(MAX) = 
N'<tr>
';

--Generate table header
DECLARE column_name_cursor CURSOR FOR 
SELECT column_name FROM #columns;
OPEN column_name_cursor;
FETCH next FROM column_name_cursor INTO @ColumnName;
WHILE @@FETCH_STATUS = 0 
BEGIN 
    SET @TableHeader = @TableHeader + 
N'    <th>' + @ColumnName + N'</th>
';
    FETCH next FROM column_name_cursor INTO @ColumnName;
END 
CLOSE column_name_cursor 
SET @TableHeader = @TableHeader + 
N'</tr>
';

--PRINT @TableHeader;

--Generate table body
SET @Cmd = N'SELECT @a = ISNULL(CAST((SELECT ' 
OPEN column_name_cursor 
FETCH next FROM column_name_cursor INTO @ColumnName 
WHILE @@FETCH_STATUS = 0 
BEGIN 
    SET @Cmd = @Cmd + N'td = CASE WHEN [' + @ColumnName + N'] IS NULL THEN ''NULL'' ELSE CONVERT(NVARCHAR(MAX), [' + @ColumnName + N']) END,'''',' 
    FETCH next FROM column_name_cursor INTO @ColumnName;
END;
CLOSE column_name_cursor;
DEALLOCATE column_name_cursor;
SET @Cmd = SUBSTRING (@Cmd, 0, LEN(@Cmd));
SET @Cmd = @Cmd + N' FROM [' + @DatabaseName + N'].[' + @SchemaName + N'].[' + @ObjectName + N']' ;
IF ( @OrderBy <> '' ) 
    SET @Cmd = @Cmd + ' ORDER BY ' + @OrderBy;
SET @Cmd = @Cmd + N' FOR XML PATH(''tr''),TYPE) AS NVARCHAR(MAX) ),'''')';

--PRINT @Cmd;
DECLARE @TableBody NVARCHAR(MAX);
EXEC sp_executesql @Cmd, N'@a NVARCHAR(max) output', @TableBody output;

SET @TableBody = REPLACE(REPLACE(REPLACE(@TableBody, N' ', N'&nbsp;'), N'"', N'&quot;'), CHAR(10), '<br />');
--PRINT @TableBody

--Combine the Html of Css, TableHeader and TableBody
    --Set Table header   
SET @Html = @Css + 
N'<table class="tftable" border="1">
';
SET @Html = @Html + @TableHeader + @TableBody + 
N'</table>
';

DROP TABLE #columns;
SET NOCOUNT OFF;



GO
