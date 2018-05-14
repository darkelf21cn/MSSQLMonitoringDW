SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwAgentJobStatusAlert]
AS
WITH last_agentjob_status
AS (
	SELECT
		monitor_time,
		server_name,
		job_name,
		is_enabled,
		job_status,
		job_start_time,
		duration_min,
		step_id,
		step_name,
		last_run_outcome,
		last_run_time,
		last_run_duration_min
	FROM
		dbo.mAgentJobStatus (NOLOCK) 
	WHERE
		monitor_time = (SELECT MAX(monitor_time) FROM dbo.mAgentJobStatus (NOLOCK))
),
last_agentjob_errmsg
AS (
SELECT
	a.email_group_name,
	c.monitor_time,
	c.server_name,
	c.job_name,
	c.is_enabled,
	a.expect_enabled,
	a.expect_outcome,
	c.last_run_outcome,
	a.max_duration_min,
	c.duration_min,
	c.job_start_time,
	c.step_name,
	c.last_run_time,
	a.last_error_occurred_time,
	--expect_enabled is defined and job enabled status is not correctly set.
	CASE
		WHEN c.is_enabled = 0 AND c.is_enabled <> expect_enabled THEN N'The job should not be DISABLED.' + CHAR(13) + CHAR(10)
		WHEN c.is_enabled = 1 AND c.is_enabled <> expect_enabled THEN N'The job should not be ENABLED.' + CHAR(13) + CHAR(10)
		ELSE ''
	END +
	--Job is running and running longer than expect. 
	CASE
		WHEN c.duration_min > a.max_duration_min AND a.max_duration_min <> 0 AND c.job_status = 'Running'
		    THEN N'The SQL Agent job is currently running and it takes longer than the max allowed duration (' +  + CONVERT(NVARCHAR(20), max_duration_min) + 'Min).' + CHAR(13) + CHAR(10)
		ELSE ''
	END +
	--Treate the job outcome is "Success" if the job never runs.
	CASE
		WHEN c.last_run_outcome <> a.expect_outcome AND c.last_run_outcome IS NOT NULL AND a.expect_outcome IS NOT NULL
			THEN N'The job outcome (' + last_run_outcome + ') does not match with the expectation (' + expect_outcome + '). ' +
			'The last step name is [' + ISNULL(step_name, 'NULL') + '].' + CHAR(13) + CHAR(10) 
		ELSE ''
	END AS error_msg,
	a.last_email_time
FROM
	dbo.bCriticalAgentJobs (NOLOCK) a
	INNER JOIN dbo.bServerInventory (NOLOCK) b
		ON a.server_id = b.server_id
	INNER JOIN last_agentjob_status c
		ON b.server_name = c.server_name
			AND a.job_name = c.job_name
)
SELECT
	email_group_name,
	monitor_time,
	server_name,
	job_name,
	is_enabled,
	expect_enabled,
	expect_outcome,
	last_run_outcome,
	max_duration_min,
	duration_min,
	job_start_time,
	step_name,
	last_run_time,
	last_error_occurred_time,
	CASE
		WHEN error_msg <> '' THEN SUBSTRING(error_msg, 1, LEN(error_msg) -2)
		ELSE ''
	END AS error_msg,
	CASE
		WHEN error_msg <> '' AND last_run_time > last_error_occurred_time THEN 1 --Use last_run_time to identify whether it is the same failure.
		WHEN error_msg <> '' AND last_error_occurred_time IS NULL THEN 1 --Alert never been sent.
		ELSE 0
	END should_alert,
	last_email_time
FROM
	last_agentjob_errmsg;

GO
