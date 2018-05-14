SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bEmailConfigurations] (
		[email_group_name]          [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[db_mail_profile_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[recipients]                [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[copy_recipients]           [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[blind_copy_recipients]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[sms_mail_box]              [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[bEmailConfigurations]
	ADD
	CONSTRAINT [PK_bEmailConfigurations]
	PRIMARY KEY
	CLUSTERED
	([email_group_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[bEmailConfigurations] SET (LOCK_ESCALATION = TABLE)
GO
