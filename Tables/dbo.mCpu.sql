SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mCpu] (
		[monitor_time]     [datetime] NOT NULL,
		[server_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[cpu_sql]          [int] NULL,
		[cpu_other]        [int] NULL,
		[cpu_idle]         [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mCpu]
	ADD
	CONSTRAINT [PK_mCpu]
	PRIMARY KEY
	CLUSTERED
	([monitor_time], [server_name])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_mCpu_ServerName_MonitorTime]
	ON [dbo].[mCpu] ([server_name], [monitor_time])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mCpu] SET (LOCK_ESCALATION = TABLE)
GO
