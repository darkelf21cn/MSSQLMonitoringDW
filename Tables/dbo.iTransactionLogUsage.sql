SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iTransactionLogUsage] (
		[server_name]             [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[database_name]           [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[log_size_mb]             [float] NULL,
		[log_usage_pct]           [nvarchar](17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[log_reuse_wait_desc]     [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[recovery_model_desc]     [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[iTransactionLogUsage] SET (LOCK_ESCALATION = TABLE)
GO
