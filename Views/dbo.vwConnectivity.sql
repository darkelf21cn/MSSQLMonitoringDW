SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW vwConnectivity
AS
SELECT
	monitor_time,
	server_name,
	CONVERT(UNIQUEIDENTIFIER, HASHBYTES('MD5', 'SqlConnectivity_' + server_name)) AS tracking_guid,
	result
FROM
	dbo.mConnectivity (NOLOCK);
GO
