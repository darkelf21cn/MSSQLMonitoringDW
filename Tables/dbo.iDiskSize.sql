SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iDiskSize] (
		[server_name]           [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[drive_name]            [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[drive_free_mb]         [bigint] NULL,
		[drive_capacity_mb]     [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[iDiskSize] SET (LOCK_ESCALATION = TABLE)
GO
