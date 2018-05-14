SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mProcedureStatisticsBak] (
		[batch_id]                 [bigint] NOT NULL,
		[monitor_time]             [datetime] NOT NULL,
		[server_name]              [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[database_name]            [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[object_name]              [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[creation_time]            [datetime] NULL,
		[plan_handle]              [varbinary](64) NOT NULL,
		[sql_handle]               [varbinary](64) NOT NULL,
		[execution_count]          [bigint] NOT NULL,
		[last_execution_time]      [datetime] NULL,
		[last_elapsed_time]        [bigint] NULL,
		[max_elapsed_time]         [bigint] NULL,
		[min_elapsed_time]         [bigint] NULL,
		[total_elapsed_time]       [bigint] NULL,
		[total_logical_reads]      [bigint] NOT NULL,
		[total_logical_writes]     [bigint] NOT NULL,
		[total_physical_reads]     [bigint] NOT NULL,
		[total_worker_time]        [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mProcedureStatisticsBak] SET (LOCK_ESCALATION = TABLE)
GO
