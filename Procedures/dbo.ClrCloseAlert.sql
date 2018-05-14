CREATE PROCEDURE [dbo].[ClrCloseAlert]
	@InstanceName [nvarchar](128),
	@ClientName [nvarchar](50),
	@Category [nvarchar](50),
	@TraceId [uniqueidentifier],
	@SmsBody [nvarchar](140),
	@EmailBody nvarchar(max)
AS
	EXTERNAL NAME [AcxiomMonitoringPlatform].[Alert].[Close]
GO
