SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mDataFileBase] (
		[monitor_time]      [datetime] NOT NULL,
		[server_name]       [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[database_name]     [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[file_id]           [int] NOT NULL,
		[read_counts]       [bigint] NULL,
		[read_mb]           [bigint] NULL,
		[read_wait_ms]      [bigint] NULL,
		[write_counts]      [bigint] NULL,
		[write_mb]          [bigint] NULL,
		[write_wait_ms]     [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mDataFileBase]
	ADD
	CONSTRAINT [PK_mDataFileBase]
	PRIMARY KEY
	CLUSTERED
	([server_name], [database_name], [file_id])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mDataFileBase] SET (LOCK_ESCALATION = TABLE)
GO
