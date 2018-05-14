SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bServerInventory] (
		[server_id]          [int] IDENTITY(1, 1) NOT NULL,
		[server_name]        [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[instance_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[comments]           [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[start_datetime]     [smalldatetime] NULL,
		[end_datetime]       [smalldatetime] NULL,
		[is_production]      [bit] NULL,
		[is_active]          [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bServerInventory]
	ADD
	CONSTRAINT [PK_bServers]
	PRIMARY KEY
	CLUSTERED
	([server_id])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[bServerInventory]
	ADD
	CONSTRAINT [CHK_bServerInventory_EndTime]
	CHECK
	([is_active]=(0) AND isnull([end_datetime],'1900-01-01 00:00:00')>=[start_datetime] OR [is_active]=(1) AND [end_datetime] IS NULL)
GO
ALTER TABLE [dbo].[bServerInventory]
CHECK CONSTRAINT [CHK_bServerInventory_EndTime]
GO
ALTER TABLE [dbo].[bServerInventory]
	ADD
	CONSTRAINT [DF__bServerIn__start__6F405F80]
	DEFAULT (getdate()) FOR [start_datetime]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_bServerInventory_ServerName]
	ON [dbo].[bServerInventory] ([server_name])
	ON [INDEX]
GO
ALTER TABLE [dbo].[bServerInventory] SET (LOCK_ESCALATION = TABLE)
GO
