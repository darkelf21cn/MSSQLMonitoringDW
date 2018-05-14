SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mADGroupMembersChangeLog] (
		[id]                      [bigint] IDENTITY(1, 1) NOT NULL,
		[monitor_time]            [datetime] NULL,
		[security_group_name]     [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[member_account]          [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[member_name]             [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[action]                  [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mADGroupMembersChangeLog]
	ADD
	CONSTRAINT [PK_mADGroupMembersChangeLog]
	PRIMARY KEY
	NONCLUSTERED
	([id])
	ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CIX_mADGroupMembersChangeLog]
	ON [dbo].[mADGroupMembersChangeLog] ([monitor_time])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mADGroupMembersChangeLog] SET (LOCK_ESCALATION = TABLE)
GO
