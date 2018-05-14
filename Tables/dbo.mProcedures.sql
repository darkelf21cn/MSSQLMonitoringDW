SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[mProcedures] (
		[id]                      [bigint] IDENTITY(1, 1) NOT NULL,
		[update_time]             [datetime] NOT NULL,
		[server_name]             [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[database_name]           [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[object_name]             [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[sql_handle]              [varbinary](64) NOT NULL,
		[plan_handle]             [varbinary](64) NOT NULL,
		[last_execution_time]     [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[mProcedures]
	ADD
	CONSTRAINT [PK_mProcedures]
	PRIMARY KEY
	CLUSTERED
	([server_name], [database_name], [object_name], [plan_handle], [sql_handle])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_mProcedures_UpdateTime]
	ON [dbo].[mProcedures] ([update_time])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[mProcedures] SET (LOCK_ESCALATION = TABLE)
GO
