SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwAgentJobStatus]
AS
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
	monitor_time = (SELECT MAX(monitor_time) FROM dbo.mAgentJobStatus (NOLOCK));
GO
