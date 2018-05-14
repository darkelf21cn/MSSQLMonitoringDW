SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[lIssues] (
		[creation_dt]         [datetime] NOT NULL,
		[issue_id]            [bigint] IDENTITY(1, 1) NOT NULL,
		[server_instance]     [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[client_name]         [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[monitor_id]          [int] NOT NULL,
		[tracking_guid]       [uniqueidentifier] NOT NULL,
		[alert_guid]          [uniqueidentifier] NOT NULL,
		[is_alerted]          [bit] NOT NULL,
		[suppress_until]      [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lIssues]
	ADD
	CONSTRAINT [PK_lIssues]
	PRIMARY KEY
	CLUSTERED
	([creation_dt], [issue_id])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_lIssues_TrackingGuid]
	ON [dbo].[lIssues] ([tracking_guid])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[lIssues] SET (LOCK_ESCALATION = TABLE)
GO
