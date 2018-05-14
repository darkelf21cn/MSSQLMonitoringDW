SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[lIssuesHist] (
		[creation_dt]         [datetime] NOT NULL,
		[issue_id]            [bigint] NOT NULL,
		[server_instance]     [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[client_name]         [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[monitor_id]          [int] NOT NULL,
		[tracking_guid]       [uniqueidentifier] NOT NULL,
		[alert_guid]          [uniqueidentifier] NOT NULL,
		[resolved_dt]         [datetime] NOT NULL,
		[duration_min]        AS (datediff(minute,[creation_dt],[resolved_dt]))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lIssuesHist]
	ADD
	CONSTRAINT [PK_lIssuesHist]
	PRIMARY KEY
	CLUSTERED
	([creation_dt], [issue_id])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[lIssuesHist] SET (LOCK_ESCALATION = TABLE)
GO
