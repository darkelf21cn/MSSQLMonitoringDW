SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mBlocking] (
		[monitor_time]            [datetime] NOT NULL,
		[server_name]             [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[session_id]              [int] NULL,
		[blocked_by]              [int] NULL,
		[level]                   [int] NULL,
		[blocking_tree]           [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[blocking_tree_order]     [int] NULL,
		[host_name]               [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[login_name]              [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[program_name]            [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[database_name]           [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[status]                  [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[wait_time_ms]            [bigint] NULL,
		[last_wait_type]          [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[wait_resource]           [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[open_tran]               [int] NULL,
		[cpu]                     [int] NULL,
		[physical_io]             [bigint] NULL,
		[individual_query]        [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[entire_query]            [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CIX_mBlocking]
	ON [dbo].[mBlocking] ([monitor_time], [server_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mBlocking] SET (LOCK_ESCALATION = TABLE)
GO
