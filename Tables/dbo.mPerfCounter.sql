SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mPerfCounter] (
		[monitor_time]         [datetime] NOT NULL,
		[monitor_time_raw]     [datetime] NOT NULL,
		[server_name]          [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[counter_id]           [int] NOT NULL,
		[instance_name]        [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[cntr_value]           [bigint] NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [CIX_mPerfCounter]
	ON [dbo].[mPerfCounter] ([monitor_time], [server_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mPerfCounter] SET (LOCK_ESCALATION = TABLE)
GO
