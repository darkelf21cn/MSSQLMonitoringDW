SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Utility_GenerateTimeAxis](
	@StartTime DATETIME = NULL,
	@EndTime DATETIME = NULL,
	@IntervalMin INT = 240
)
AS
BEGIN
	IF @EndTime IS NULL
		SET @EndTime = GETDATE();
	IF @StartTime IS NULL
		SET @StartTime = DATEADD(DAY, -7, @EndTime);
	IF @EndTime < @StartTime
		RAISERROR('EndTime is earily than StartTime',16,1);
	
	IF OBJECT_ID('tempdb..#TimeAxis') IS NOT NULL
		DROP TABLE #TimeAxis;
	CREATE TABLE #TimeAxis
	(
		start_datetime DATETIME NOT NULL PRIMARY KEY,
		end_datetime DATETIME NOT NULL
	);
	DECLARE @CutOffTime DATETIME;
	IF @IntervalMin < 60
		SET @CutOffTime = CONVERT(DATETIME, CONVERT(CHAR(14), @StartTime, 120) + '00:00');
	ELSE IF @IntervalMin >=60
		SET @CutOffTime = CONVERT(DATETIME, CONVERT(CHAR(11), @StartTime, 120) + '00:00:00');

	DECLARE @TmpStartTime DATETIME = @StartTime;
	WHILE (@CutOffTime < @EndTime)
	BEGIN
		IF (@CutOffTime > @StartTime)
		BEGIN
			INSERT INTO #TimeAxis VALUES (@TmpStartTime, DATEADD(SS, -1, @CutOffTime));
			SET @TmpStartTime = @CutOffTime;
		END;
		SET @CutOffTime = DATEADD(MINUTE, @IntervalMin, @CutOffTime);
	END;
	INSERT INTO #TimeAxis VALUES (DATEADD(MINUTE, -@IntervalMin, @CutOffTime), @EndTime);

	SELECT * FROM #TimeAxis;
END;

GO
