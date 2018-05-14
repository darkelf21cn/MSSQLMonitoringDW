SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[rServerProject] (
		[server_id]          [int] NOT NULL,
		[project_id]         [int] NOT NULL,
		[start_datetime]     [smalldatetime] NULL,
		[end_datetime]       [smalldatetime] NULL,
		[is_active]          [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[rServerProject]
	ADD
	CONSTRAINT [PK_rServerProject]
	PRIMARY KEY
	CLUSTERED
	([server_id], [project_id])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[rServerProject]
	ADD
	CONSTRAINT [DF__rServerPr__start__4F7CD00D]
	DEFAULT (getdate()) FOR [start_datetime]
GO
ALTER TABLE [dbo].[rServerProject]
	WITH CHECK
	ADD CONSTRAINT [FK_rServerProject_bProjects_ProjectID]
	FOREIGN KEY ([project_id]) REFERENCES [dbo].[bProjects] ([project_id])
ALTER TABLE [dbo].[rServerProject]
	CHECK CONSTRAINT [FK_rServerProject_bProjects_ProjectID]

GO
ALTER TABLE [dbo].[rServerProject]
	WITH CHECK
	ADD CONSTRAINT [FK_rServerProject_bServerInventory_ServerID]
	FOREIGN KEY ([server_id]) REFERENCES [dbo].[bServerInventory] ([server_id])
ALTER TABLE [dbo].[rServerProject]
	CHECK CONSTRAINT [FK_rServerProject_bServerInventory_ServerID]

GO
ALTER TABLE [dbo].[rServerProject] SET (LOCK_ESCALATION = TABLE)
GO
