SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mConnectivity] (
		[monitor_time]     [datetime] NOT NULL,
		[server_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[result]           [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[email_sent]       [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[mConnectivity]
	ADD
	CONSTRAINT [PK_mConnectivity]
	PRIMARY KEY
	CLUSTERED
	([monitor_time], [server_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mConnectivity]
	ADD
	CONSTRAINT [DF__mConnecti__email__60A75C0F]
	DEFAULT ((0)) FOR [email_sent]
GO
ALTER TABLE [dbo].[mConnectivity] SET (LOCK_ESCALATION = TABLE)
GO
