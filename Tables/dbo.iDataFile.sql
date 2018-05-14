SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iDataFile] (
		[monitor_time]          [datetime] NULL,
		[server_name]           [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[database_name]         [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[file_group_name]       [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[file_id]               [int] NULL,
		[file_type]             [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[logical_name]          [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[drive_name]            [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[file_path]             [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[file_name]             [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[sample_ms]             [bigint] NULL,
		[read_counts]           [bigint] NOT NULL,
		[read_mb]               [bigint] NULL,
		[read_wait_ms]          [bigint] NOT NULL,
		[write_counts]          [bigint] NOT NULL,
		[write_mb]              [bigint] NULL,
		[write_wait_ms]         [bigint] NOT NULL,
		[total_wait_ms]         [bigint] NULL,
		[file_size_mb]          [bigint] NULL,
		[file_used_mb]          [bigint] NULL,
		[growth]                [int] NULL,
		[is_percent_growth]     [bit] NULL,
		[file_max_size_mb]      [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[iDataFile] SET (LOCK_ESCALATION = TABLE)
GO
