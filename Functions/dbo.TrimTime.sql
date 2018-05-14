SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.TrimTime (
	@DateTime DATETIME,
	@IntervalMin INT = 15
)
RETURNS DATETIME
BEGIN
	DECLARE @Retval DATETIME;
	DECLARE @mm INT;
	DECLARE @s CHAR(19);

	IF (@IntervalMin < 1 OR @IntervalMin > 60 OR 60 % @IntervalMin <> 0)
		SET @mm = 'Invalid value of @IntervalMin.' --Generate error as RAISERROR is not allowed in the function. 

	SET @s = CONVERT(CHAR(19), @DateTime, 120);
	SET @mm = CONVERT(INT, SUBSTRING(@s, 15, 2));
	SET @mm = @IntervalMin * ((@mm - (@mm % @IntervalMin)) / @IntervalMin);
	SET @Retval = SUBSTRING(@s, 1, 14) + RIGHT('0' + CONVERT(VARCHAR(2), @mm), 2) + ':00';
	RETURN @Retval;
END
GO
