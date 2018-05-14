SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mDatabaseRoleMembershipChangeLog] (
		[monitor_time]       [datetime] NULL,
		[action_type]        [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[server_name]        [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[principal_id]       [int] NULL,
		[login_name]         [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[login_type]         [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[database_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[role_name]          [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[is_server_role]     [int] NOT NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CIX_mDatabaseRoleMembershipChangeLog]
	ON [dbo].[mDatabaseRoleMembershipChangeLog] ([server_name], [monitor_time])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mDatabaseRoleMembershipChangeLog] SET (LOCK_ESCALATION = TABLE)
GO
