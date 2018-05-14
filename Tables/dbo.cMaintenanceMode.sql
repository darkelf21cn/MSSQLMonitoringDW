SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cMaintenanceMode] (
		[server_id]                      [int] NOT NULL,
		[maintenance_start_datetime]     [smalldatetime] NOT NULL,
		[maintenance_end_datetime]       [smalldatetime] NOT NULL,
		[insert_datetime]                [smalldatetime] NOT NULL,
		[insert_by]                      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[reason]                         [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cMaintenanceMode]
	ADD
	CONSTRAINT [PK_cMaintenanceMode]
	PRIMARY KEY
	CLUSTERED
	([server_id])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[cMaintenanceMode]
	ADD
	CONSTRAINT [CHK_cMaintenanceMode_SuppressDuration]
	CHECK
	(datediff(hour,[maintenance_start_datetime],[maintenance_end_datetime])<=(24))
GO
ALTER TABLE [dbo].[cMaintenanceMode]
CHECK CONSTRAINT [CHK_cMaintenanceMode_SuppressDuration]
GO
ALTER TABLE [dbo].[cMaintenanceMode]
	ADD
	CONSTRAINT [CHK_cMaintenanceMode_SuppressEndTime]
	CHECK
	([maintenance_end_datetime]>[maintenance_start_datetime])
GO
ALTER TABLE [dbo].[cMaintenanceMode]
CHECK CONSTRAINT [CHK_cMaintenanceMode_SuppressEndTime]
GO
ALTER TABLE [dbo].[cMaintenanceMode]
	ADD
	CONSTRAINT [DF__cMaintena__inser__052FA09F]
	DEFAULT (getdate()) FOR [insert_datetime]
GO
ALTER TABLE [dbo].[cMaintenanceMode]
	ADD
	CONSTRAINT [DF__cMaintena__inser__0623C4D8]
	DEFAULT (suser_sname()) FOR [insert_by]
GO
ALTER TABLE [dbo].[cMaintenanceMode]
	WITH CHECK
	ADD CONSTRAINT [FK_cMaintenanceMode_bServerInventory_ServerID]
	FOREIGN KEY ([server_id]) REFERENCES [dbo].[bServerInventory] ([server_id])
ALTER TABLE [dbo].[cMaintenanceMode]
	CHECK CONSTRAINT [FK_cMaintenanceMode_bServerInventory_ServerID]

GO
ALTER TABLE [dbo].[cMaintenanceMode] SET (LOCK_ESCALATION = TABLE)
GO
