SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [rpt].[DatabaseAggByDay] (
		[monitor_date]      [date] NOT NULL,
		[server_name]       [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[database_name]     [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[data_type]         [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[allocated_mb]      [bigint] NOT NULL,
		[used_mb]           [bigint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [rpt].[DatabaseAggByDay]
	ADD
	CONSTRAINT [PK_DatabaseDailyGrowth]
	PRIMARY KEY
	CLUSTERED
	([monitor_date], [server_name], [database_name], [data_type])
	ON [PRIMARY]
GO
ALTER TABLE [rpt].[DatabaseAggByDay] SET (LOCK_ESCALATION = TABLE)
GO
