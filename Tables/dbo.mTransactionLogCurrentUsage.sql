SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mTransactionLogCurrentUsage] (
		[monitor_time]            [datetime] NOT NULL,
		[server_name]             [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[database_name]           [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[tracking_guid]           [uniqueidentifier] NULL,
		[log_size_mb]             [bigint] NULL,
		[log_usage_pct]           [decimal](5, 1) NULL,
		[log_reuse_wait_desc]     [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[recovery_model_desc]     [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[log_max_growth_mb]       [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mTransactionLogCurrentUsage]
	ADD
	CONSTRAINT [PK_mTransactionLogCurrentUsage]
	PRIMARY KEY
	CLUSTERED
	([server_name], [database_name])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_mTransactionLogCurrentUsage_TrackingGuid]
	ON [dbo].[mTransactionLogCurrentUsage] ([tracking_guid])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mTransactionLogCurrentUsage] SET (LOCK_ESCALATION = TABLE)
GO
