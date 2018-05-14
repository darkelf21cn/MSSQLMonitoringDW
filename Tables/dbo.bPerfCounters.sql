SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bPerfCounters] (
		[counter_id]                [int] NOT NULL,
		[counter_category]          [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[object_name]               [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[counter_name]              [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[counter_friendly_name]     [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[counter_explanation]       [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[bPerfCounters]
	ADD
	CONSTRAINT [PK_bPerfCounters]
	PRIMARY KEY
	CLUSTERED
	([counter_id])
	ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_ObjectName_CounterName]
	ON [dbo].[bPerfCounters] ([object_name], [counter_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[bPerfCounters] SET (LOCK_ESCALATION = TABLE)
GO
