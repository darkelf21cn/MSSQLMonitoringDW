SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mDiskSize] (
		[monitor_time]          [datetime] NOT NULL,
		[server_name]           [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[drive_name]            [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[drive_free_mb]         [bigint] NULL,
		[drive_capacity_mb]     [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mDiskSize]
	ADD
	CONSTRAINT [PK_mDiskSize]
	PRIMARY KEY
	CLUSTERED
	([monitor_time], [server_name], [drive_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mDiskSize] SET (LOCK_ESCALATION = TABLE)
GO
