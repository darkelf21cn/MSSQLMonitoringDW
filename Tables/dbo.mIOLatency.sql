SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mIOLatency] (
		[monitor_time]      [datetime] NOT NULL,
		[server_name]       [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[database_name]     [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[logical_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[drive_name]        [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[file_name]         [nvarchar](254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[time_gap_min]      [int] NULL,
		[write_counts]      [bigint] NULL,
		[write_mb]          [bigint] NULL,
		[write_wait_s]      [bigint] NULL,
		[read_counts]       [bigint] NULL,
		[read_mb]           [bigint] NULL,
		[read_wait_s]       [bigint] NULL,
		[total_wait_s]      [bigint] NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CIX_mIOLatency]
	ON [dbo].[mIOLatency] ([monitor_time], [server_name], [database_name], [logical_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mIOLatency] SET (LOCK_ESCALATION = TABLE)
GO
