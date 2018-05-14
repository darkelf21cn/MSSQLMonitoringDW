SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportDatabaseRoleMembership]
AS
SET XACT_ABORT ON
BEGIN

BEGIN TRANSACTION
--Record for the new added permissions
INSERT INTO dbo.mDatabaseRoleMembershipChangeLog (
	monitor_time,
	action_type,
	server_name,
	principal_id,
	login_name,
	login_type,
	database_name,
	role_name,
	is_server_role
)
SELECT
	a.monitor_time,
	'ADD' AS action_type,
	a.server_name,
	a.principal_id,
	a.login_name,
	a.login_type,
	a.database_name,
	a.role_name,
	a.is_server_role
FROM
	dbo.iDatabaseRoleMembership a
	LEFT JOIN dbo.mDatabaseRoleMembership b
		ON a.server_name = b.server_name
			AND a.principal_id = b.principal_id
			AND a.login_name = b.login_name
			AND ISNULL(a.database_name, '') = ISNULL(b.database_name, '')
			AND a.role_name = b.role_name
WHERE
	b.server_name IS NULL;

--Record for the deleted permissions
INSERT INTO dbo.mDatabaseRoleMembershipChangeLog (
	monitor_time,
	action_type,
	server_name,
	principal_id,
	login_name,
	login_type,
	database_name,
	role_name,
	is_server_role
)
SELECT
	dbo.TrimTime(GETDATE(), 5),
	'DEL' AS action_type,
	a.server_name,
	a.principal_id,
	a.login_name,
	a.login_type,
	a.database_name,
	a.role_name,
	a.is_server_role
FROM
	dbo.mDatabaseRoleMembership a
	LEFT JOIN dbo.iDatabaseRoleMembership b
		ON a.server_name = b.server_name
			AND a.principal_id = b.principal_id
			AND a.login_name = b.login_name
			AND ISNULL(a.database_name, '') = ISNULL(b.database_name, '')
			AND a.role_name = b.role_name
WHERE
	b.server_name IS NULL;

--Flush dbo.mDatabaseRoleMembership	
TRUNCATE TABLE dbo.mDatabaseRoleMembership;
INSERT INTO dbo.mDatabaseRoleMembership(
	monitor_time,
	server_name,
	principal_id,
	login_name,
	login_type,
	database_name,
	role_name,
	is_server_role
)
SELECT
	monitor_time,
	server_name,
	principal_id,
	login_name,
	login_type,
	database_name,
	role_name,
	is_server_role
FROM
	dbo.iDatabaseRoleMembership;
		
COMMIT TRANSACTION;

END;




GO
