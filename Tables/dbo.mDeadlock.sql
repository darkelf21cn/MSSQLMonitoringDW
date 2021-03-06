SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mDeadlock] (
		[monitor_time]        [datetime] NOT NULL,
		[server_name]         [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[detect_time_utc]     [datetime] NULL,
		[detect_time]         [datetime] NULL,
		[x_hash]              [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[x_deadlock]          [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[mDeadlock]
	ADD
	CONSTRAINT [PK_mDeadlock]
	PRIMARY KEY
	CLUSTERED
	([monitor_time], [server_name], [x_hash])
	ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_mDeadlock_XHash]
	ON [dbo].[mDeadlock] ([x_hash])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mDeadlock] SET (LOCK_ESCALATION = TABLE)
GO
