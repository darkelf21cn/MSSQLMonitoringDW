SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iDatabaseStatus] (
		[server_name]          [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[database_name]        [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[user_access_desc]     [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[state_desc]           [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[iDatabaseStatus] SET (LOCK_ESCALATION = TABLE)
GO
