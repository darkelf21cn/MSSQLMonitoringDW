SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mDatabaseStatus] (
		[monitor_time]         [datetime] NOT NULL,
		[server_name]          [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[database_name]        [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[user_access_desc]     [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[state_desc]           [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mDatabaseStatus]
	ADD
	CONSTRAINT [PK_mDatabaseStatus]
	PRIMARY KEY
	CLUSTERED
	([monitor_time], [server_name], [database_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mDatabaseStatus] SET (LOCK_ESCALATION = TABLE)
GO
