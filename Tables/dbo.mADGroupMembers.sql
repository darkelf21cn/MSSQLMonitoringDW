SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mADGroupMembers] (
		[monitor_time]            [datetime] NULL,
		[security_group_name]     [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[member_account]          [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[member_name]             [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mADGroupMembers] SET (LOCK_ESCALATION = TABLE)
GO
