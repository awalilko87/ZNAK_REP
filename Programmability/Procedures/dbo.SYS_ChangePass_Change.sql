SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYS_ChangePass_Change](
	@pUserID nvarchar(50),
	@pActualPassword nvarchar(50),
	@pNewPassword nvarchar(50),
	@pNewPasswordConfirm nvarchar(50)
)
WITH ENCRYPTION
AS

BEGIN
	DECLARE @ActualClearPassword nvarchar(255)
	DECLARE @ActualHashPassword nvarchar(255)
	DECLARE @NewClearPassword nvarchar(255)
	DECLARE @NewMD5Password nvarchar(255)
	DECLARE @NewHashPassword nvarchar(255)
	DECLARE @ConfirmClearPassword nvarchar(255)
	DECLARE @ConfirmHashPassword nvarchar(255)

	DECLARE @MobilePass nvarchar(50)
	DECLARE @Mes nvarchar(400)
	DECLARE @pass_exsists bit
	DECLARE @SQLString nvarchar(1000)
	DECLARE @ParmDefinition nvarchar(500)
	DECLARE @DecodePassType nvarchar(10)	
	DECLARE @PassHistoryLength nvarchar(10)
	DECLARE @PassHistoryDays nvarchar(5)
	DECLARE @PassHistoryDaysInt int
	DECLARE @ChangePassDate datetime
	DECLARE @DateDiff int
	
	DECLARE @RequiredPassLengthN nvarchar(3)
	DECLARE @RequiredPassLength int
	DECLARE @RequiredPassNonAlphaNumericCountN nvarchar(3) 
	DECLARE @RequiredPassNonAlphaNumericCount int
	DECLARE @RequiredPassLowerCountN nvarchar(3)
	DECLARE @RequiredPassLowerCount int
	DECLARE @RequiredPassUpperCountN nvarchar(3)
	DECLARE @RequiredPassUpperCount int
	DECLARE @RequredPassNumericCountN nvarchar(3)
	DECLARE @RequredPassNumericCount int
	DECLARE @RequirePassNotEqualUserIDN nvarchar(3)
	DECLARE @RequirePassNotEqualUserID int
	

	SET @ActualClearPassword = @pActualPassword
	SET @NewClearPassword = @pNewPassword
	SET @ConfirmClearPassword = @pNewPasswordConfirm

	SET @MobilePass = @pNewPassword

	SELECT TOP 1 @RequiredPassLengthN = convert(nvarchar(3),SettingValue) FROM dbo.SYSettings (nolock) WHERE KeyCode = 'PASS_LENGTH' and ModuleCode = 'VISION'
	SET @RequiredPassLength = convert(int, @RequiredPassLengthN);
	SELECT TOP 1 @RequiredPassNonAlphaNumericCountN = convert(nvarchar(3),SettingValue) FROM dbo.SYSettings (nolock) WHERE KeyCode = 'PASS_NONALPHANUMERIC_CHARACTERS_COUNT' and ModuleCode = 'VISION'
	SET @RequiredPassNonAlphaNumericCount = convert(int, @RequiredPassNonAlphaNumericCountN);
	SELECT TOP 1 @RequiredPassLowerCountN = convert(nvarchar(3),SettingValue) FROM dbo.SYSettings (nolock) WHERE KeyCode = 'PASS_LOWER_CHARACTERS_COUNT' and ModuleCode = 'VISION'
	SET @RequiredPassLowerCount = convert(int, @RequiredPassLowerCountN);
	SELECT TOP 1 @RequiredPassUpperCountN = convert(nvarchar(3),SettingValue) FROM dbo.SYSettings (nolock) WHERE KeyCode = 'PASS_UPPER_CHARACTERS_COUNT' and ModuleCode = 'VISION'
	SET @RequiredPassUpperCount = convert(int, @RequiredPassUpperCountN);
	SELECT TOP 1 @RequredPassNumericCountN = convert(nvarchar(3),SettingValue) FROM dbo.SYSettings (nolock) WHERE KeyCode = 'PASS_NUMERICAL_CHARACTERS_COUNT' and ModuleCode = 'VISION'
	SET @RequredPassNumericCount = convert(int, @RequredPassNumericCountN);
	SELECT TOP 1 @RequirePassNotEqualUserIDN = convert(nvarchar(3),SettingValue) FROM dbo.SYSettings (nolock) WHERE KeyCode = 'PASS_EQUAL_USERID' and ModuleCode = 'VISION'
	SET @RequirePassNotEqualUserID = convert(int, @RequirePassNotEqualUserIDN);


	SELECT TOP 1 @DecodePassType = convert(nvarchar(10),SettingValue) FROM dbo.SYSettings (nolock) WHERE KeyCode = 'PTYPE' and ModuleCode = 'VISION'
	SELECT TOP 1 @PassHistoryLength = convert(nvarchar(10), SettingValue) FROM dbo.SYSettings WHERE KeyCode = 'SEC_PASS_HIST_LENGTH' and ModuleCode = 'VISION'
	SELECT TOP 1 @PassHistoryDays = convert(nvarchar(5), SettingValue) FROM dbo.SYSettings WHERE KeyCode = 'SEC_PASS_HIST_DATE' and ModuleCode = 'VISION'
	SET @PassHistoryDaysInt = convert(int, @PassHistoryDays)

	select @Mes = isnull(@Mes, '') + isnull([Description], '') + ': ' + isnull(SettingValue,'') + ' ' from dbo.SYSettings
	where KeyCode in (
	'PASS_LENGTH',
	'PASS_NONALPHANUMERIC_CHARACTERS_COUNT',
	'PASS_UPPER_CHARACTERS_COUNT',
	'PASS_LOWER_CHARACTERS_COUNT',
	'PASS_NUMERICAL_CHARACTERS_COUNT')
	and SettingValue > 0

	--Hasło równe UserID
	IF (@pUserID = @NewClearPassword AND @RequirePassNotEqualUserID = 0)
	BEGIN
		SELECT @Mes = '<b>Hasło musi być różne od UserID.</b>' + @Mes
		GOTO end_error
	END

    --Nowe hasło md5 do historii
	SET @NewMD5Password =  sys.fn_varbintohexstr(HashBytes('MD5', @NewClearPassword))

	IF @DecodePassType = 'P1'
	BEGIN
		SET @ActualHashPassword = (SELECT dbo.P1(@ActualClearPassword))
		SET @NewHashPassword = (SELECT dbo.P1(@NewClearPassword))
		SET @ConfirmHashPassword = (SELECT dbo.P1(@ConfirmClearPassword))
	END

	IF @DecodePassType = 'D7i'
	BEGIN
		SET @ActualHashPassword = (SELECT dbo.Pass_D7i(@ActualClearPassword))
		SET @NewHashPassword = (SELECT dbo.Pass_D7i(@NewClearPassword))
		SET @ConfirmHashPassword = (SELECT dbo.Pass_D7i(@ConfirmClearPassword))
	END

	IF @DecodePassType = 'MP2'
	BEGIN
		SET @ActualHashPassword = (SELECT dbo.Pass_MP2(@ActualClearPassword))
		SET @NewHashPassword = (SELECT dbo.Pass_MP2(@NewClearPassword))
		SET @ConfirmHashPassword = (SELECT dbo.Pass_MP2(@ConfirmClearPassword))
	END

	--Obsługa błędnego aktualnego hasła
	IF isnull(@ActualClearPassword, '') <> '' begin
		IF not exists(select null from SYUsers where UserID = @pUserID and ([Password] = @ActualHashPassword OR [Password] = @ActualClearPassword))
		BEGIN
			SELECT @Mes = '<b>Błędne stare hasło.</b>' + @Mes
			GOTO end_error
		END
	END

	IF @NewHashPassword <> @ConfirmHashPassword 
	BEGIN
		SELECT @Mes = '<b>''Nieprawidłowe hasło potwierdzające.</b>' + @Mes
		GOTO end_error
	END

	--Długość hasła
	IF (@RequiredPassLength > 0 AND LEN(@NewClearPassword) < @RequiredPassLength)
	BEGIN
		GOTO end_error
	END
   
    --Ilość znaków nie alfanumerycznych
	IF @RequiredPassNonAlphaNumericCount > dbo.fn_NonAlphanumericCharactersCount(@NewClearPassword) 
	BEGIN
		GOTO end_error
	END

	--Ilość wielkich liter
	IF @RequiredPassUpperCount > dbo.fn_UpperCaseCharactersCount(@NewClearPassword) 
	BEGIN
		GOTO end_error
	END

    --Ilość małych liter
	IF @RequiredPassLowerCount > dbo.fn_LowerCaseCharactersCount(@NewClearPassword) 
	BEGIN
		GOTO end_error
	END

    --Ilość cyfr
	IF @RequredPassNumericCount > dbo.fn_NumericalCharactersCount(@NewClearPassword) 
	BEGIN
		GOTO end_error
	END

	--Sprawdzanie powtarzalności hasła ze względu na datę
	SET @ChangePassDate = (SELECT TOP 1 ChangePassDate FROM SYUsers_historia WHERE Password = @NewMD5Password ORDER BY ChangePassDate DESC)
	SET @DateDiff = DATEDIFF(dd, @ChangePassDate, getdate())
	IF @DateDiff < @PassHistoryDaysInt
	BEGIN 
		SELECT @Mes = '<b>Hasło nie może się powtarzać z wcześniej wprowadzonymi (nie upłynął jeszcze termin po którym hasło może się powtórzyć). Wprowadż nowe hasło. </b>' + @Mes
		GOTO end_error
	END

	--Sprawdzanie powtarzalności hasła ze względu na liczbę
	SET @SQLString = N'IF @new_password IN (SELECT top '+ @PassHistoryLength +' Password FROM SYUsers_historia WHERE UserID = @user_id ORDER BY ChangePassDate DESC) 
					   SET @pass_exsistsOUT = 1 ELSE SET @pass_exsistsOUT = 0'	

	SET @ParmDefinition = N'@new_password nvarchar(50), @user_id nvarchar(20), @pass_exsistsOUT bit OUTPUT'
    EXECUTE sp_executesql @SQLString, @ParmDefinition, @new_password = @NewMD5Password,
						  @user_id = @pUserID, @pass_exsistsOUT = @pass_exsists OUTPUT
	
	IF @pass_exsists = 1
	BEGIN
		SELECT @Mes = '<b>Hasło nie może się powtarzać z wcześniej wprowadzonymi. Wprowadż nowe hasło.</b>' + @Mes
		GOTO end_error
	END
    ELSE IF @pass_exsists = 0
	BEGIN
		INSERT INTO SYUsers_historia (UserID, Password, ChangePassDate)
		VALUES (@pUserID, @NewMD5Password, getdate())
	END
 
	IF EXISTS (SELECT * FROM SYS_ChangePass_VV WHERE UserID = @pUserID)
	BEGIN 
		UPDATE SYS_ChangePass_VV SET [Password] = @NewHashPassword  WHERE UserID = @pUserID
		UPDATE SYUsers SET PasswordLastChange = getDate() WHERE UserID = @pUserID
		IF EXISTS (SELECT object_id FROM sys.objects WHERE name = 'MobileUsers' and type = 'U')
			UPDATE MobileUsers SET [Password] = @MobilePass WHERE UserID = @pUserID
	END 

	WHILE @@TRANCOUNT>0 COMMIT TRAN
		return
		
	end_error:
		IF @@TRANCOUNT>0 ROLLBACK TRAN
		raiserror(@Mes,16,1)
END
GO