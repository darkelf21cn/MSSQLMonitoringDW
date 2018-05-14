SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mDatabaseBackupHist] (
		[server_name]                [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[database_name]              [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[backup_set_id]              [int] NOT NULL,
		[family_sequence_number]     [tinyint] NOT NULL,
		[backup_start_date]          [datetime] NULL,
		[backup_finish_date]         [datetime] NULL,
		[size_kb]                    [bigint] NULL,
		[duration_s]                 [int] NULL,
		[backup_type]                [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[physical_path]              [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[physical_device_name]       [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[first_lsn]                  [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[last_lsn]                   [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[recovery_model]             [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_mDatabaseBackupHist]
	ON [dbo].[mDatabaseBackupHist] ([backup_start_date])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mDatabaseBackupHist] SET (LOCK_ESCALATION = TABLE)
GO
