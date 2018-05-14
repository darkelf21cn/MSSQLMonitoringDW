SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportReplicationStatus]
AS
SET XACT_ABORT ON

DECLARE @RetentionStartDate SMALLDATETIME;
DECLARE @Now DATETIME = GETDATE();
SELECT
	@RetentionStartDate = DATEADD(DAY, 0 - retention_days, @Now)
FROM bMonitoringObjects WHERE monitor_name = 'ReplicationStatus';

BEGIN TRANSACTION;

DELETE FROM dbo.mReplicationStatusHist
WHERE monitor_time < @RetentionStartDate;

INSERT INTO dbo.mReplicationStatusHist (
	monitor_time,
	publisher,
	publisher_db,
	distributor,
	publication_name,
	subscriber,
	subscriber_db,
	subscription_type,
	delivery_rate,
	pending_cmds,
	latency_sec,
	error_code,
	error_text
)
SELECT
	monitor_time,
	publisher,
	publisher_db,
	distributor,
	publication_name,
	subscriber,
	subscriber_db,
	subscription_type,
	delivery_rate,
	pending_cmds,
	latency_sec,
	error_code,
	error_text
FROM
	dbo.mReplicationStatus;

TRUNCATE TABLE dbo.mReplicationStatus;

INSERT INTO dbo.mReplicationStatus (
	monitor_time,
	publisher,
	publisher_db,
	distributor,
	publication_name,
	subscriber,
	subscriber_db,
	subscription_type,
	delivery_rate,
	pending_cmds,
	latency_sec,
	error_code,
	error_text
)
SELECT
	dbo.TrimTime(@Now, 5),
	publisher,
	publisher_db,
	distributor,
	publication_name,
	subscriber,
	subscriber_db,
	subscription_type,
	delivery_rate,
	pending_cmds,
	latency_sec,
	error_code,
	error_text
FROM
	dbo.iReplicationStatus;

TRUNCATE TABLE dbo.iReplicationStatus;

COMMIT TRANSACTION;
GO
