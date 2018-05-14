SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddServer](
	@ServerName NVARCHAR(128),
	@Comments NVARCHAR(128)
)
AS

BEGIN
INSERT INTO dbo.bServerInventory (server_name, comments, cida_zone, is_active)
VALUES (@ServerName, @Comments, 1, 1);

INSERT INTO dbo.rServerMonitor (server_id, monitor_id, is_active)
SELECT a.server_id, monitor_id, 1 
FROM dbo.bServerInventory a, dbo.bMonitoringObjects b
WHERE a.server_name = @ServerName
END
GO
