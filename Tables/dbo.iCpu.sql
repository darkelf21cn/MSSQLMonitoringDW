SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iCpu] (
		[server_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[record_id]        [int] NULL,
		[monitor_time]     [datetime] NULL,
		[cpu_sql]          [int] NULL,
		[cpu_other]        [int] NULL,
		[cpu_idle]         [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[iCpu] SET (LOCK_ESCALATION = TABLE)
GO
