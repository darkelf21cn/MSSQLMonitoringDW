SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mQueryStatistics] (
		[batch_id]                 [bigint] NULL,
		[monitor_time]             [datetime] NOT NULL,
		[server_name]              [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[execution_count]          [bigint] NOT NULL,
		[last_execution_time]      [datetime] NOT NULL,
		[last_elapsed_ms]          [bigint] NULL,
		[max_elapsed_ms]           [bigint] NULL,
		[min_elapsed_ms]           [bigint] NULL,
		[total_elapsed_ms]         [bigint] NULL,
		[total_logical_reads]      [bigint] NOT NULL,
		[total_logical_writes]     [bigint] NOT NULL,
		[total_physical_reads]     [bigint] NOT NULL,
		[total_worker_ms]          [bigint] NULL,
		[statement_hash]           [char](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CIX_mQueryStatistics]
	ON [dbo].[mQueryStatistics] ([monitor_time], [server_name], [statement_hash])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_mQueryStatistics2_BatchID]
	ON [dbo].[mQueryStatistics] ([batch_id])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mQueryStatistics] SET (LOCK_ESCALATION = TABLE)
GO
