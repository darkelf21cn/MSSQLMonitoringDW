SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bProjects] (
		[project_id]           [int] IDENTITY(1, 1) NOT NULL,
		[project_name]         [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[email_group_name]     [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[comments]             [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[start_datetime]       [smalldatetime] NULL,
		[end_datetime]         [smalldatetime] NULL,
		[is_active]            [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bProjects]
	ADD
	CONSTRAINT [PK_bProjects]
	PRIMARY KEY
	CLUSTERED
	([project_id])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[bProjects]
	ADD
	CONSTRAINT [CHK_bProjects_EndTime]
	CHECK
	([is_active]=(0) AND isnull([end_datetime],'1900-01-01 00:00:00')>=[start_datetime] OR [is_active]=(1) AND [end_datetime] IS NULL)
GO
ALTER TABLE [dbo].[bProjects]
CHECK CONSTRAINT [CHK_bProjects_EndTime]
GO
ALTER TABLE [dbo].[bProjects]
	ADD
	CONSTRAINT [DF__bProjects__start__6B6FCE9C]
	DEFAULT (getdate()) FOR [start_datetime]
GO
ALTER TABLE [dbo].[bProjects]
	WITH CHECK
	ADD CONSTRAINT [FK_bProjects_bEmailConfigurations_EmailGroupName]
	FOREIGN KEY ([email_group_name]) REFERENCES [dbo].[bEmailConfigurations] ([email_group_name])
ALTER TABLE [dbo].[bProjects]
	CHECK CONSTRAINT [FK_bProjects_bEmailConfigurations_EmailGroupName]

GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_bProjects_ProjectName]
	ON [dbo].[bProjects] ([project_name])
	ON [INDEX]
GO
ALTER TABLE [dbo].[bProjects] SET (LOCK_ESCALATION = TABLE)
GO
