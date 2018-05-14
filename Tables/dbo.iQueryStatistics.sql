SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iQueryStatistics] (
		[monitor_time]               [datetime] NOT NULL,
		[server_name]                [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[database_name]              [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[object_name]                [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[creation_time]              [datetime] NOT NULL,
		[plan_generation_num]        [bigint] NOT NULL,
		[plan_handle]                [varbinary](64) NOT NULL,
		[sql_handle]                 [varbinary](64) NOT NULL,
		[execution_count]            [bigint] NOT NULL,
		[last_execution_time]        [datetime] NOT NULL,
		[last_elapsed_ms]            [bigint] NULL,
		[max_elapsed_ms]             [bigint] NULL,
		[min_elapsed_ms]             [bigint] NULL,
		[total_elapsed_ms]           [bigint] NULL,
		[total_logical_reads]        [bigint] NOT NULL,
		[total_logical_writes]       [bigint] NOT NULL,
		[total_physical_reads]       [bigint] NOT NULL,
		[total_worker_ms]            [bigint] NULL,
		[statement_start_offset]     [int] NOT NULL,
		[statement_end_offset]       [int] NOT NULL,
		[statement_text]             [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CIX_iQueryStatistics]
	ON [dbo].[iQueryStatistics] ([server_name], [sql_handle])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[iQueryStatistics] SET (LOCK_ESCALATION = TABLE)
GO
