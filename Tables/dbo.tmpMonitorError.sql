SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpMonitorError] (
		[monitor_time]      [nvarchar](19) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[log_category]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[server_name]       [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[instance_name]     [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[port]              [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[status]            [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[message]           [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[elapsed_sec]       [decimal](8, 1) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CIX_tmpMonitorError]
	ON [dbo].[tmpMonitorError] ([monitor_time] DESC, [log_category])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[tmpMonitorError] SET (LOCK_ESCALATION = TABLE)
GO
