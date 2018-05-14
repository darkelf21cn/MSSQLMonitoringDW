SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [rpt].[vwCurrentDiskUsage]
AS
SELECT
	monitor_time,
	server_name,
	drive_name,
	drive_free_mb,
	drive_capacity_mb
FROM
	dbo.mDiskSize (NOLOCK)
WHERE
	monitor_time = (SELECT MAX(monitor_time) FROM dbo.mDiskSize (NOLOCK))
GO
