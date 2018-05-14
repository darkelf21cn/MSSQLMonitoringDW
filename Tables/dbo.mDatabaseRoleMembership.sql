SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mDatabaseRoleMembership] (
		[monitor_time]       [datetime] NULL,
		[server_name]        [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[principal_id]       [int] NULL,
		[login_name]         [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[login_type]         [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[database_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[role_name]          [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[is_server_role]     [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mDatabaseRoleMembership] SET (LOCK_ESCALATION = TABLE)
GO
