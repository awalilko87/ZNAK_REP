SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUsers_ChangePassword](
  @UserID nvarchar(30),
	@OldPass nvarchar(50),
	@NewPass nvarchar(50),
	@Force int,
	@Ok int out
)
WITH ENCRYPTION
AS
DECLARE @CRPass nvarchar(50), @CRPassOld nvarchar(50), @PType nvarchar(50)
	SELECT @PType=ISNULL(SettingValue, '')
		FROM SYSettings
		WHERE ModuleCode='VISION' AND KeyCode='PTYPE'
	IF @PType='' OR @PType IS NULL
	BEGIN
		SET @CRPass = @NewPass
		SET @CRPassOld = @OldPass
	END
	IF @PType = 'P1'
	BEGIN
		SET @CRPass = dbo.P1(@NewPass)
		SET @CRPassOld = dbo.P1(@OldPass)
	END

	IF @PType = 'D7i'
	BEGIN
		SET @CRPass = dbo.Pass_D7i(@NewPass)
		SET @CRPassOld = dbo.Pass_D7i(@OldPass)
	END

	IF @PType = 'MP2'
	BEGIN
		SET @CRPass = dbo.Pass_MP2(@NewPass)
		SET @CRPassOld = dbo.Pass_MP2(@OldPass)
	END

	IF @PType = 'SHA1'
	BEGIN
		SET @CRPass =dbo.VS_EncryptPasswordSHA1(@NewPass)
		SET @CRPassOld =dbo.VS_EncryptPasswordSHA1(@OldPass)
	END


	SET @Ok = 0
	if @Force=0
		UPDATE SYUsers SET
		Password = @CRPass
	    	WHERE UserID = @UserID AND Password = @CRPassOld
	else
		UPDATE SYUsers SET
		Password = @CRPass
	    	WHERE UserID = @UserID

	SET @Ok = 1
	IF @Ok = 1
		exec SYLog_Add @UserID = @UserID, @Operation=N'Password changed'
GO