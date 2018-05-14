SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bWaitTypeCategory] (
		[wait_type]          [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[wait_category]      [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[description_en]     [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[description_cn]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[bWaitTypeCategory]
	ADD
	CONSTRAINT [PK_bWaitTypeCategory]
	PRIMARY KEY
	CLUSTERED
	([wait_type])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[bWaitTypeCategory] SET (LOCK_ESCALATION = TABLE)
GO
