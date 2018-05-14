SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iDatabaseBackup] (
		[server_name]                [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[database_name]              [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[backup_set_id]              [int] NOT NULL,
		[family_sequence_number]     [tinyint] NOT NULL,
		[backup_start_date]          [datetime] NULL,
		[backup_finish_date]         [datetime] NULL,
		[size_kb]                    [bigint] NULL,
		[duration_s]                 [int] NULL,
		[backup_type]                [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[physical_path]              [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[physical_device_name]       [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[first_lsn]                  [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[last_lsn]                   [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[recovery_model]             [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[iDatabaseBackup] SET (LOCK_ESCALATION = TABLE)
GO
