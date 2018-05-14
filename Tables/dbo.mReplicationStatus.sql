SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mReplicationStatus] (
		[monitor_time]          [datetime] NOT NULL,
		[publisher]             [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[publisher_db]          [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[distributor]           [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[publication_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[subscriber]            [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[subscriber_db]         [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[subscription_type]     [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[delivery_rate]         [bigint] NULL,
		[pending_cmds]          [bigint] NULL,
		[latency_sec]           [bigint] NULL,
		[error_code]            [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[error_text]            [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CIX_mReplicationStatus]
	ON [dbo].[mReplicationStatus] ([monitor_time], [publisher], [publisher_db])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mReplicationStatus] SET (LOCK_ESCALATION = TABLE)
GO
