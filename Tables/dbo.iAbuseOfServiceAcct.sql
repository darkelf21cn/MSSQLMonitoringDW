SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iAbuseOfServiceAcct] (
		[server_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[login_time]       [datetime] NOT NULL,
		[login_name]       [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[host_name]        [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[program_name]     [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[iAbuseOfServiceAcct] SET (LOCK_ESCALATION = TABLE)
GO
