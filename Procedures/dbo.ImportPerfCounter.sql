SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ImportPerfCounter]
AS
SET XACT_ABORT ON
BEGIN

DECLARE @RetentionStartDate SMALLDATETIME;
DECLARE @Now DATETIME = GETDATE();
SELECT
	@RetentionStartDate = DATEADD(DAY, 0 - retention_days, @Now)
FROM bMonitoringObjects WHERE monitor_name = 'PerfCounter';

BEGIN TRANSACTION;
DELETE FROM dbo.mPerfCounter
WHERE monitor_time < @RetentionStartDate;

INSERT INTO mPerfCounter (
	monitor_time,
	monitor_time_raw,
	server_name,
	counter_id,
	instance_name,
	cntr_value
)
SELECT
	dbo.TrimTime(a.monitor_time, 5),
	a.monitor_time AS monitor_time_raw,
	a.server_name,
	c.counter_id,
	NULLIF(a.instance_name, ''),
	CASE
		WHEN a.cntr_type = 65792 THEN a.cntr_value
        WHEN a.cntr_type = 537003264 AND a.cntr_base <> 0 THEN 100 * a.cntr_value / a.cntr_base
		WHEN a.cntr_type = 272696576 AND a.cntr_value >= b.cntr_value AND a.ms_ticks - b.ms_ticks <> 0 THEN (a.cntr_value - b.cntr_value) / ((a.ms_ticks - b.ms_ticks) / 1000)
		WHEN a.cntr_type = 1073874176 AND a.cntr_value >= b.cntr_value AND a.cntr_base - b.cntr_base <> 0 THEN (a.cntr_value - b.cntr_value) / (a.cntr_base - b.cntr_base)
		ELSE NULL
	END AS cntr_value
FROM
	dbo.iPerfCounter a
	INNER JOIN dbo.mPerfCounterBase b
		ON a.server_name = b.server_name
		   AND a.object_name = b.object_name
		   AND a.counter_name = b.counter_name
		   AND a.instance_name = b.instance_name
	INNER JOIN dbo.bPerfCounters c
		ON a.object_name = c.object_name
		   AND a.counter_name = c.counter_name
WHERE
	a.ms_ticks > b.ms_ticks;

MERGE dbo.mPerfCounterBase AS t
USING dbo.iPerfCounter AS s
ON (
	t.server_name = s.server_name
	AND t.object_name = s.object_name
	AND t.counter_name = s.counter_name
	AND t.instance_name = s.instance_name
)
WHEN MATCHED THEN
	UPDATE SET
        t.monitor_time = s.monitor_time,
        t.ms_ticks = s.ms_ticks,
		t.cntr_value = s.cntr_value,
		t.cntr_base = s.cntr_base
WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		monitor_time,
		ms_ticks,
		server_name,
		object_name,
		counter_name,
		instance_name,
		cntr_type,
		cntr_value,
		cntr_base
	)
	VALUES (
		s.monitor_time,
		s.ms_ticks,
		s.server_name,
		s.object_name,
		s.counter_name,
		s.instance_name,
		s.cntr_type,
		s.cntr_value,
		s.cntr_base
	)
WHEN NOT MATCHED BY SOURCE THEN
	DELETE;

TRUNCATE TABLE dbo.iPerfCounter;

COMMIT TRANSACTION;
END;
GO
