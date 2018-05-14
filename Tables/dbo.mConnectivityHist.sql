SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mConnectivityHist] (
		[monitor_time]     [datetime] NOT NULL,
		[server_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[result]           [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[mConnectivityHist]
	ADD
	CONSTRAINT [PK_mConnectivityHist]
	PRIMARY KEY
	CLUSTERED
	([monitor_time], [server_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mConnectivityHist] SET (LOCK_ESCALATION = TABLE)
GO
