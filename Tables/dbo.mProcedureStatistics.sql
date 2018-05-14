SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mProcedureStatistics] (
		[batch_id]                 [bigint] NOT NULL,
		[monitor_time]             [datetime] NOT NULL,
		[server_name]              [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[database_name]            [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[object_name]              [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[creation_time]            [datetime] NOT NULL,
		[plan_handle]              [varbinary](64) NOT NULL,
		[sql_handle]               [varbinary](64) NOT NULL,
		[execution_count]          [bigint] NOT NULL,
		[last_execution_time]      [datetime] NOT NULL,
		[last_elapsed_time]        [bigint] NOT NULL,
		[last_worker_time]         [bigint] NOT NULL,
		[last_logical_reads]       [bigint] NOT NULL,
		[max_elapsed_time]         [bigint] NOT NULL,
		[min_elapsed_time]         [bigint] NOT NULL,
		[total_elapsed_time]       [bigint] NOT NULL,
		[total_logical_reads]      [bigint] NOT NULL,
		[total_logical_writes]     [bigint] NOT NULL,
		[total_physical_reads]     [bigint] NOT NULL,
		[total_worker_time]        [bigint] NOT NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CIX_mProcedureStatistics]
	ON [dbo].[mProcedureStatistics] ([monitor_time], [server_name], [database_name], [object_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mProcedureStatistics] SET (LOCK_ESCALATION = TABLE)
GO
