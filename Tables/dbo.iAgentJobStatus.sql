SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iAgentJobStatus] (
		[server_name]               [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[job_name]                  [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[is_enabled]                [tinyint] NULL,
		[job_status]                [nvarchar](9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[job_start_time]            [datetime] NULL,
		[duration_min]              [int] NULL,
		[step_id]                   [int] NULL,
		[step_name]                 [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[last_run_outcome]          [nvarchar](11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[last_run_time]             [datetime] NULL,
		[last_run_duration_min]     [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[iAgentJobStatus] SET (LOCK_ESCALATION = TABLE)
GO
