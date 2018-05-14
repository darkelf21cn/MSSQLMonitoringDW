SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mTransactionLogUsage] (
		[monitor_time]            [datetime] NOT NULL,
		[server_name]             [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[database_name]           [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[log_size_mb]             [bigint] NULL,
		[log_usage_pct]           [decimal](5, 1) NULL,
		[log_reuse_wait_desc]     [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[recovery_model_desc]     [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mTransactionLogUsage]
	ADD
	CONSTRAINT [PK_mTransactionLogUsage]
	PRIMARY KEY
	CLUSTERED
	([monitor_time], [server_name], [database_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mTransactionLogUsage] SET (LOCK_ESCALATION = TABLE)
GO
