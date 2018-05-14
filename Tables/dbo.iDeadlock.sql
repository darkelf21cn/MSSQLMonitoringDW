SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iDeadlock] (
		[server_name]         [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[detect_time_utc]     [datetime] NULL,
		[x_hash]              [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[x_deadlock]          [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[iDeadlock] SET (LOCK_ESCALATION = TABLE)
GO
