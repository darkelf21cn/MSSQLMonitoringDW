SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mQueryStatments] (
		[id]                         [bigint] IDENTITY(1, 1) NOT NULL,
		[update_time]                [datetime] NOT NULL,
		[server_name]                [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[statement_hash]             [char](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[database_name]              [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[object_name]                [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[creation_time]              [datetime] NULL,
		[plan_generation_num]        [bigint] NULL,
		[statement_text]             [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[sql_handle]                 [varbinary](64) NOT NULL,
		[plan_handle]                [varbinary](64) NOT NULL,
		[statement_start_offset]     [int] NOT NULL,
		[statement_end_offset]       [int] NOT NULL,
		[last_execution_time]        [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[mQueryStatments]
	ADD
	CONSTRAINT [PK_mQueryStatments]
	PRIMARY KEY
	CLUSTERED
	([server_name], [statement_hash])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_mQueryStatments_ServerName_DatabaseName_ObjectName]
	ON [dbo].[mQueryStatments] ([server_name], [database_name], [object_name])
	ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_mQueryStatments_ID]
	ON [dbo].[mQueryStatments] ([id])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mQueryStatments] SET (LOCK_ESCALATION = TABLE)
GO
