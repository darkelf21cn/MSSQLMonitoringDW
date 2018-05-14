SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mDataFileHist] (
		[monitor_time]          [datetime] NOT NULL,
		[server_name]           [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[database_name]         [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[file_group_name]       [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[file_id]               [int] NULL,
		[file_type]             [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[logical_name]          [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[drive_name]            [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[file_path]             [nvarchar](1022) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[file_name]             [nvarchar](254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[reads_per_sec]         [bigint] NULL,
		[read_mb_per_sec]       [bigint] NULL,
		[read_wait_ms]          [bigint] NULL,
		[writes_per_sec]        [bigint] NULL,
		[write_mb_per_sec]      [bigint] NULL,
		[write_wait_ms]         [bigint] NULL,
		[file_size_mb]          [bigint] NULL,
		[file_used_mb]          [bigint] NULL,
		[growth]                [int] NULL,
		[is_percent_growth]     [bit] NULL,
		[file_max_size_mb]      [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mDataFileHist]
	ADD
	CONSTRAINT [PK_mDataFileHist]
	PRIMARY KEY
	CLUSTERED
	([monitor_time], [server_name], [database_name], [logical_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mDataFileHist] SET (LOCK_ESCALATION = TABLE)
GO
