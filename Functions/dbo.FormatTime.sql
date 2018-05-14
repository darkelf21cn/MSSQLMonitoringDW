SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FormatTime](
	@Input BIGINT
)
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @RetVal NVARCHAR(100);
	SELECT 
	@RetVal = CASE
		WHEN @Input IS NULL THEN NULL
		WHEN @Input >= 86400000 THEN CONVERT(VARCHAR(100), CONVERT(DECIMAL(16,2), ROUND(@Input * 1.0 / 86400000, 2))) + ' d'
		WHEN @Input >= 3600000 THEN CONVERT(VARCHAR(100), CONVERT(DECIMAL(16,2), ROUND(@Input * 1.0 / 3600000, 2))) + ' h'
		WHEN @Input >= 60000 THEN CONVERT(VARCHAR(100), CONVERT(DECIMAL(16,2), ROUND(@Input * 1.0 / 60000, 2))) + ' m'
		WHEN @Input >= 1000 THEN CONVERT(VARCHAR(100), CONVERT(DECIMAL(16,2), ROUND(@Input * 1.0 / 1000, 2))) + ' s'
		ELSE CONVERT(VARCHAR(100), @Input) + ' ms'
	END;
	RETURN (@RetVal);
END

GO