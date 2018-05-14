SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mCpuHist] (
		[monitor_time]     [datetime] NOT NULL,
		[server_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[cpu_sql]          [int] NULL,
		[cpu_other]        [int] NULL,
		[cpu_idle]         [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mCpuHist]
	ADD
	CONSTRAINT [PK_mCpuHist]
	PRIMARY KEY
	CLUSTERED
	([monitor_time], [server_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mCpuHist] SET (LOCK_ESCALATION = TABLE)
GO
