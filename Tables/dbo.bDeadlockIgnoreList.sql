SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bDeadlockIgnoreList] (
		[property_name]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[property_value]     [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[comments]           [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bDeadlockIgnoreList]
	ADD
	CONSTRAINT [PK_bDeadlockIgnoreList]
	PRIMARY KEY
	CLUSTERED
	([property_name])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[bDeadlockIgnoreList] SET (LOCK_ESCALATION = TABLE)
GO
