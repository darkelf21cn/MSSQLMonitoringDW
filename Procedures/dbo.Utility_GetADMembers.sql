SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Utility_GetADMembers] (
	@Ldap NVARCHAR(1024),
	@SecurityGroupName NVARCHAR(1024)
)
AS
-- EXEC dbo.Utility_GetADMembers @Ldap = 'LDAP://DC=ap,DC=acxiom,DC=net', @SecurityGroupName = 'CHN_DB_Admins'
DECLARE @Query NVARCHAR(1024);
DECLARE @DistinguishedName NVARCHAR(1024);
SET @Query = '
    SELECT @DistinguishedName = distinguishedName
    FROM OPENQUERY(ADSI, ''
        SELECT distinguishedName 
        FROM ''''' + @Ldap + '''''
        WHERE 
            objectClass = ''''group'''' AND
            sAMAccountName = ''''' + @SecurityGroupName + '''''
    '')';
EXEC SP_EXECUTESQL @Query, N'@DistinguishedName NVARCHAR(1024) OUTPUT', @DistinguishedName = @DistinguishedName OUTPUT 
SET @Query = '
	SELECT
		''' + @SecurityGroupName + ''' AS security_group_name,
		SAMAccountName AS login_name,
		DisplayName AS display_name
	FROM
		OPENQUERY(ADSI, ''
			SELECT sAMAccountName, displayName, givenName, sn, isDeleted 
			FROM ''''' + @Ldap + '''''
			WHERE 
				objectClass = ''''user'''' AND
				memberOf = ''''' + @DistinguishedName + '''''''
		)
	WHERE
		isDeleted IS NULL';
EXEC SP_EXECUTESQL @Query;
GO
