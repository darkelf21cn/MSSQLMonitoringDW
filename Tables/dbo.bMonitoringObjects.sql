SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bMonitoringObjects] (
		[monitor_id]                   [int] IDENTITY(1, 1) NOT NULL,
		[monitor_name]                 [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[comments]                     [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[script_name]                  [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[script_path]                  [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[server_list]                  [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[load_destination_temp]        [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[load_destination]             [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[load_destination_hist]        [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[load_log]                     [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[archive_days]                 [int] NOT NULL,
		[retention_days]               [int] NOT NULL,
		[severity]                     [tinyint] NOT NULL,
		[email_subject]                [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[sms_subject]                  [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[prevent_duplicate_alert]      [bit] NOT NULL,
		[auto_suppression_minutes]     [int] NULL,
		[start_datetime]               [smalldatetime] NULL,
		[end_datetime]                 [smalldatetime] NULL,
		[is_active]                    [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bMonitoringObjects]
	ADD
	CONSTRAINT [PK_bMonitoringObjects]
	PRIMARY KEY
	CLUSTERED
	([monitor_id])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[bMonitoringObjects]
	ADD
	CONSTRAINT [CHK_bMonitoringObjects_AutoSuppressionMin]
	CHECK
	([prevent_duplicate_alert]=(1) AND [auto_suppression_minutes] IS NULL OR [prevent_duplicate_alert]=(0) AND [auto_suppression_minutes] IS NOT NULL)
GO
ALTER TABLE [dbo].[bMonitoringObjects]
CHECK CONSTRAINT [CHK_bMonitoringObjects_AutoSuppressionMin]
GO
ALTER TABLE [dbo].[bMonitoringObjects]
	ADD
	CONSTRAINT [CHK_bMonitoringObjects_EndTime]
	CHECK
	([is_active]=(0) AND isnull([end_datetime],'1900-01-01 00:00:00')>=[start_datetime] OR [is_active]=(1) AND [end_datetime] IS NULL)
GO
ALTER TABLE [dbo].[bMonitoringObjects]
CHECK CONSTRAINT [CHK_bMonitoringObjects_EndTime]
GO
ALTER TABLE [dbo].[bMonitoringObjects]
	ADD
	CONSTRAINT [DF_bMonitoringObjects_ArchiveDays]
	DEFAULT ((30)) FOR [archive_days]
GO
ALTER TABLE [dbo].[bMonitoringObjects]
	ADD
	CONSTRAINT [DF_bMonitoringObjects_AutoSuppressionMinutes]
	DEFAULT ((0)) FOR [auto_suppression_minutes]
GO
ALTER TABLE [dbo].[bMonitoringObjects]
	ADD
	CONSTRAINT [DF_bMonitoringObjects_RetentionDays]
	DEFAULT ((90)) FOR [retention_days]
GO
ALTER TABLE [dbo].[bMonitoringObjects]
	ADD
	CONSTRAINT [DF_bMonitoringObjects_StartDatetime]
	DEFAULT (getdate()) FOR [start_datetime]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_bMonitoringObjects_MonitorName]
	ON [dbo].[bMonitoringObjects] ([monitor_name])
	ON [INDEX]
GO
ALTER TABLE [dbo].[bMonitoringObjects] SET (LOCK_ESCALATION = TABLE)
GO
