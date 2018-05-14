SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mWaitStatistics] (
		[batch_id]                [bigint] NOT NULL,
		[monitor_time]            [datetime] NOT NULL,
		[server_name]             [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[wait_type]               [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[waiting_tasks_count]     [bigint] NOT NULL,
		[wait_time_ms]            [bigint] NOT NULL,
		[max_wait_time_ms]        [bigint] NOT NULL,
		[signal_wait_time_ms]     [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mWaitStatistics]
	ADD
	CONSTRAINT [PK_mWaitStatistics]
	PRIMARY KEY
	CLUSTERED
	([monitor_time], [server_name], [wait_type])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_mWaitStatistics_BatchID]
	ON [dbo].[mWaitStatistics] ([batch_id])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mWaitStatistics] SET (LOCK_ESCALATION = TABLE)
GO
