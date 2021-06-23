SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUsers_CheckPasswordValidityDate](
  @UserID nvarchar(30),
	@status int OUT
)
WITH ENCRYPTION
AS
	DECLARE @daysToExpirePass int
	DECLARE @daysSinceLastUpdate int
	DECLARE @passLastUpdate Datetime
	DECLARE @passExpirationDays nvarchar(10)  
	DECLARE @passExpirationDaysInt int  
	DECLARE @passExpirationDaysInfo nvarchar(10)  
	DECLARE @passExpirationDaysInfoInt int  

	SELECT TOP 1 @passExpirationDays = convert(nvarchar(10), SettingValue) FROM dbo.SYSettings WHERE KeyCode = 'SEC_PASS_EXPIRATION_DAYS' AND ModuleCode = 'VISION'
	SET @passExpirationDaysInt = convert(int, @passExpirationDays)
	SELECT TOP 1 @passExpirationDaysInfo = convert(nvarchar(10), SettingValue) FROM dbo.SYSettings WHERE KeyCode = 'SEC_PASS_EXPIRATION_DAYS_INFO' AND ModuleCode = 'VISION'
	SET @passExpirationDaysInfoInt = convert(int, @passExpirationDaysInfo)
	SELECT @passLastUpdate = PasswordLastChange FROM dbo.SYUsers WHERE UserID = @UserID
	SELECT @daysSinceLastUpdate = DATEDIFF(day, @passLastUpdate, getdate())		
	SELECT @daysToExpirePass = @passExpirationDaysInt - @daysSinceLastUpdate
	
	IF 	@daysToExpirePass > 0
	BEGIN
		IF @daysToExpirePass > @passExpirationDaysInfoInt
			SET @status = 0
		ELSE
			SET @status = 1
	END
	ELSE
		SET @status = 2

GO