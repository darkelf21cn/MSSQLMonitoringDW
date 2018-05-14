SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mWorkerThread] (
		[monitor_time]                [datetime] NOT NULL,
		[server_name]                 [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[active_worker_threads]       [int] NULL,
		[current_worker_threads]      [int] NULL,
		[max_worker_threads]          [int] NULL,
		[worker_thread_usage_pct]     [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mWorkerThread]
	ADD
	CONSTRAINT [PK_mWorkerThread]
	PRIMARY KEY
	CLUSTERED
	([monitor_time], [server_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mWorkerThread] SET (LOCK_ESCALATION = TABLE)
GO
