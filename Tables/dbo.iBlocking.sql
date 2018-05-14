SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iBlocking] (
		[server_name]          [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[session_id]           [smallint] NULL,
		[blocked_by]           [int] NULL,
		[level]                [int] NULL,
		[blocking_tree]        [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[blocking_path]        [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[host_name]            [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[login_name]           [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[program_name]         [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[database_name]        [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[status]               [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[wait_time_ms]         [bigint] NOT NULL,
		[last_wait_type]       [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[wait_resource]        [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[open_tran]            [smallint] NOT NULL,
		[cpu]                  [int] NOT NULL,
		[physical_io]          [bigint] NOT NULL,
		[individual_query]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[entire_query]         [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[iBlocking] SET (LOCK_ESCALATION = TABLE)
GO
