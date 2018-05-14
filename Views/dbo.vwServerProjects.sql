SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwServerProjects]
AS
SELECT
	a.server_id,
	a.server_name,
	a.instance_name,
	c.project_id,
	c.project_name,
	c.email_group_name
FROM
	dbo.bServerInventory a (NOLOCK)
	INNER JOIN dbo.rServerProject b (NOLOCK)
		ON a.server_id = b.server_id
	INNER JOIN dbo.bProjects c (NOLOCK)
		ON b.project_id = c.project_id
WHERE
	a.is_active = 1
	AND b.is_active = 1
	AND c.is_active = 1
GO
