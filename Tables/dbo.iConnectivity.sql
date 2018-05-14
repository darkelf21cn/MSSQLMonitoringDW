SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iConnectivity] (
		[monitor_time]      [datetime] NULL,
		[log_category]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[server_name]       [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[instance_name]     [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[port]              [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[status]            [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[message]           [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[elapsed_sec]       [decimal](8, 1) NULL,
		[rows]              [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CIX_iConnectivity]
	ON [dbo].[iConnectivity] ([monitor_time], [log_category])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[iConnectivity] SET (LOCK_ESCALATION = TABLE)
GO
