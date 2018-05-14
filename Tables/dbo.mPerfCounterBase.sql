SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mPerfCounterBase] (
		[monitor_time]      [datetime] NOT NULL,
		[ms_ticks]          [bigint] NULL,
		[server_name]       [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[object_name]       [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[counter_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[instance_name]     [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[cntr_type]         [int] NOT NULL,
		[cntr_value]        [bigint] NOT NULL,
		[cntr_base]         [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mPerfCounterBase] SET (LOCK_ESCALATION = TABLE)
GO
