SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bCriticalAgentJobs] (
		[server_id]                    [int] NOT NULL,
		[job_name]                     [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[expect_enabled]               [tinyint] NULL,
		[expect_outcome]               [nvarchar](11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[max_duration_min]             [int] NOT NULL,
		[last_error_occurred_time]     [datetime] NULL,
		[email_group_name]             [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[last_email_time]              [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bCriticalAgentJobs]
	ADD
	CONSTRAINT [PK_bCriticalAgentJobs]
	PRIMARY KEY
	CLUSTERED
	([server_id], [job_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[bCriticalAgentJobs]
	WITH CHECK
	ADD CONSTRAINT [FK_bCriticalAgentJobs_bEmailConfigurations_EmailGroupName]
	FOREIGN KEY ([email_group_name]) REFERENCES [dbo].[bEmailConfigurations] ([email_group_name])
ALTER TABLE [dbo].[bCriticalAgentJobs]
	CHECK CONSTRAINT [FK_bCriticalAgentJobs_bEmailConfigurations_EmailGroupName]

GO
ALTER TABLE [dbo].[bCriticalAgentJobs]
	WITH CHECK
	ADD CONSTRAINT [FK_bCriticalAgentJobs_bServerInventory_ServerID]
	FOREIGN KEY ([server_id]) REFERENCES [dbo].[bServerInventory] ([server_id])
ALTER TABLE [dbo].[bCriticalAgentJobs]
	CHECK CONSTRAINT [FK_bCriticalAgentJobs_bServerInventory_ServerID]

GO
ALTER TABLE [dbo].[bCriticalAgentJobs] SET (LOCK_ESCALATION = TABLE)
GO
