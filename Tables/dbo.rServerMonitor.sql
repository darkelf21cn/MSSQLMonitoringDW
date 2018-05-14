SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[rServerMonitor] (
		[server_id]          [int] NOT NULL,
		[monitor_id]         [int] NOT NULL,
		[start_datetime]     [smalldatetime] NULL,
		[end_datetime]       [smalldatetime] NULL,
		[is_active]          [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[rServerMonitor]
	ADD
	CONSTRAINT [PK_rServerMonitor]
	PRIMARY KEY
	CLUSTERED
	([server_id], [monitor_id])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[rServerMonitor]
	ADD
	CONSTRAINT [CHK_rServerMonitor_EndTime]
	CHECK
	([is_active]=(0) AND isnull([end_datetime],'1900-01-01 00:00:00')>=[start_datetime] OR [is_active]=(1) AND [end_datetime] IS NULL)
GO
ALTER TABLE [dbo].[rServerMonitor]
CHECK CONSTRAINT [CHK_rServerMonitor_EndTime]
GO
ALTER TABLE [dbo].[rServerMonitor]
	ADD
	CONSTRAINT [DF__rServerMo__start__49C3F6B7]
	DEFAULT (getdate()) FOR [start_datetime]
GO
ALTER TABLE [dbo].[rServerMonitor]
	WITH CHECK
	ADD CONSTRAINT [FK_rServerMonitor_bMonitoringObjects_MonitorID]
	FOREIGN KEY ([monitor_id]) REFERENCES [dbo].[bMonitoringObjects] ([monitor_id])
ALTER TABLE [dbo].[rServerMonitor]
	CHECK CONSTRAINT [FK_rServerMonitor_bMonitoringObjects_MonitorID]

GO
ALTER TABLE [dbo].[rServerMonitor]
	WITH CHECK
	ADD CONSTRAINT [FK_rServerMonitor_bServerInventory_ServerID]
	FOREIGN KEY ([server_id]) REFERENCES [dbo].[bServerInventory] ([server_id])
ALTER TABLE [dbo].[rServerMonitor]
	CHECK CONSTRAINT [FK_rServerMonitor_bServerInventory_ServerID]

GO
ALTER TABLE [dbo].[rServerMonitor] SET (LOCK_ESCALATION = TABLE)
GO
