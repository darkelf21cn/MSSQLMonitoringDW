SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[iWorkerThread] (
		[server_name]                [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[active_worker_threads]      [int] NULL,
		[current_worker_threads]     [int] NULL,
		[max_worker_threads]         [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[iWorkerThread] SET (LOCK_ESCALATION = TABLE)
GO
