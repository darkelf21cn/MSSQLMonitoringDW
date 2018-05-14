SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tmpAgentJobStatusAlert] (
		[monitor_time]     [nchar](19) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[server_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[job_name]         [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[error_msg]        [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tmpAgentJobStatusAlert]
	ADD
	CONSTRAINT [PK_tmpAgentJobStatusAlert]
	PRIMARY KEY
	CLUSTERED
	([monitor_time], [server_name], [job_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[tmpAgentJobStatusAlert] SET (LOCK_ESCALATION = TABLE)
GO
