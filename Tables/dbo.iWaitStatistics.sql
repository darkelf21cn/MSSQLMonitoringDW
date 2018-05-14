SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iWaitStatistics] (
		[monitor_time]            [datetime] NOT NULL,
		[server_name]             [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[wait_type]               [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[waiting_tasks_count]     [bigint] NOT NULL,
		[wait_time_ms]            [bigint] NOT NULL,
		[max_wait_time_ms]        [bigint] NOT NULL,
		[signal_wait_time_ms]     [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[iWaitStatistics] SET (LOCK_ESCALATION = TABLE)
GO
