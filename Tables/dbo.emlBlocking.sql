SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[emlBlocking] (
		[monitor_time]         [varchar](19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[server_name]          [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[database_name]        [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[blocking_tree]        [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[host_name]            [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[login_name]           [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[program_name]         [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[status]               [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[last_wait_type]       [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[wait_time_ms]         [bigint] NULL,
		[wait_resource]        [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[individual_query]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[entire_query]         [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[emlBlocking] SET (LOCK_ESCALATION = TABLE)
GO
