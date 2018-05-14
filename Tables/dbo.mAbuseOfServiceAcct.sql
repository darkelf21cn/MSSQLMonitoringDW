SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mAbuseOfServiceAcct] (
		[server_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[login_time]       [datetime] NOT NULL,
		[login_name]       [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[host_name]        [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[program_name]     [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CIX_mAbuseOfServiceAcct]
	ON [dbo].[mAbuseOfServiceAcct] ([login_time])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_mAbuseOfServiceAcct_ServerName_LoginTime]
	ON [dbo].[mAbuseOfServiceAcct] ([server_name], [login_time])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mAbuseOfServiceAcct] SET (LOCK_ESCALATION = TABLE)
GO
