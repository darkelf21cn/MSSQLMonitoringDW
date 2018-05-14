SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FetchADGroupMembers]
AS
DECLARE @Ldap NVARCHAR(1024) = 'LDAP://DC=ap,DC=acxiom,DC=net';
DECLARE @DomainName NVARCHAR(50) = 'AP';
DECLARE @SecurityGroupName NVARCHAR(256);
DECLARE @Groups TABLE (
	security_group_name NVARCHAR(256)
);

INSERT INTO @Groups
SELECT DISTINCT
	REPLACE(login_name, @DomainName + '\', '') AS security_group_name
FROM
	dbo.mDatabaseRoleMembership (NOLOCK)
WHERE
	login_type = 'G'
	AND login_name LIKE 'AP\CHN_%';

TRUNCATE TABLE dbo.iADGroupMembers;

DECLARE CurSG CURSOR FAST_FORWARD FOR
SELECT security_group_name FROM @Groups;
OPEN CurSG
FETCH NEXT FROM CurSG INTO @SecurityGroupName;
WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO dbo.iADGroupMembers (security_group_name, member_account, member_name)
	EXEC dbo.Utility_GetADMembers @Ldap = @Ldap, @SecurityGroupName = @SecurityGroupName
	FETCH NEXT FROM CurSG INTO @SecurityGroupName;
END
CLOSE CurSG;
DEALLOCATE CurSG;

UPDATE dbo.iADGroupMembers
SET
	monitor_time = GETDATE(),
	security_group_name = @DomainName + '\' + security_group_name,
	member_account = @DomainName + '\' + member_account;
GO
