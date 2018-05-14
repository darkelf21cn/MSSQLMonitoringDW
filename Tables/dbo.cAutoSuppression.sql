SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[cAutoSuppression] (
		[server_id]                   [int] NOT NULL,
		[monitor_id]                  [int] NOT NULL,
		[suppress_start_datetime]     [smalldatetime] NOT NULL,
		[suppress_end_datetime]       [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cAutoSuppression]
	ADD
	CONSTRAINT [PK_cAutoSuppression]
	PRIMARY KEY
	CLUSTERED
	([server_id], [monitor_id], [suppress_start_datetime])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[cAutoSuppression]
	ADD
	CONSTRAINT [CHK_cAutoSuppression_SuppressDuration]
	CHECK
	(datediff(hour,[suppress_start_datetime],[suppress_end_datetime])<=(24))
GO
ALTER TABLE [dbo].[cAutoSuppression]
CHECK CONSTRAINT [CHK_cAutoSuppression_SuppressDuration]
GO
ALTER TABLE [dbo].[cAutoSuppression]
	ADD
	CONSTRAINT [CHK_cAutoSuppression_SuppressEndTime]
	CHECK
	([suppress_end_datetime]>[suppress_start_datetime])
GO
ALTER TABLE [dbo].[cAutoSuppression]
CHECK CONSTRAINT [CHK_cAutoSuppression_SuppressEndTime]
GO
ALTER TABLE [dbo].[cAutoSuppression]
	WITH CHECK
	ADD CONSTRAINT [FK_cAutoSuppression_bMonitoringObjects_MonitorID]
	FOREIGN KEY ([monitor_id]) REFERENCES [dbo].[bMonitoringObjects] ([monitor_id])
ALTER TABLE [dbo].[cAutoSuppression]
	CHECK CONSTRAINT [FK_cAutoSuppression_bMonitoringObjects_MonitorID]

GO
ALTER TABLE [dbo].[cAutoSuppression]
	WITH CHECK
	ADD CONSTRAINT [FK_cAutoSuppression_bServerInventory_ServerID]
	FOREIGN KEY ([server_id]) REFERENCES [dbo].[bServerInventory] ([server_id])
ALTER TABLE [dbo].[cAutoSuppression]
	CHECK CONSTRAINT [FK_cAutoSuppression_bServerInventory_ServerID]

GO
ALTER TABLE [dbo].[cAutoSuppression] SET (LOCK_ESCALATION = TABLE)
GO
