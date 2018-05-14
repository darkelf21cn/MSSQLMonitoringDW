SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ImportADGroupMembers]
AS
SET XACT_ABORT ON
BEGIN TRANSACTION
-- Record log for new joined members
INSERT INTO dbo.mADGroupMembersChangeLog (
	monitor_time,
	security_group_name,
	member_account,
	member_name,
	action
)
SELECT
	GETDATE(),
	a.security_group_name,
	a.member_account,
	a.member_name,
	'JOIN'
FROM
	dbo.iADGroupMembers a
	LEFT JOIN dbo.mADGroupMembers b
		ON a.security_group_name = b.security_group_name
		   AND a.member_account = b.member_account
WHERE
	b.security_group_name IS NULL;

-- Record log for left members
INSERT INTO dbo.mADGroupMembersChangeLog (
	monitor_time,
	security_group_name,
	member_account,
	member_name,
	action
)
SELECT
	GETDATE(),
	a.security_group_name,
	a.member_account,
	a.member_name,
	'LEAVE'
FROM
	dbo.mADGroupMembers a
	LEFT JOIN dbo.iADGroupMembers b
		ON a.security_group_name = b.security_group_name
		   AND a.member_account = b.member_account
WHERE
	b.security_group_name IS NULL;

TRUNCATE TABLE dbo.mADGroupMembers;
INSERT INTO dbo.mADGroupMembers (
	monitor_time,
	security_group_name,
	member_account,
	member_name
)
SELECT
	monitor_time,
	security_group_name,
	member_account,
	member_name
FROM
	dbo.iADGroupMembers

COMMIT TRANSACTION
GO
