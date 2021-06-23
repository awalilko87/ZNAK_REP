SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUsers_Check_Configuration](@status int OUT)
WITH ENCRYPTION
AS
	DECLARE
	 @LicenseType nvarchar(10),
			@Pelne nvarchar(4000),		    
			@Proste nvarchar(4000),		    
			@hash varchar(255),
			@hash_check_configuration varbinary(255),
			@text nvarchar(255),
			@Description nvarchar(50)

	--Sprawdzenie typu licencji
	SET @LicenseType = (SELECT SettingValue FROM SYSettings WHERE KeyCode = 'LT' AND ModuleCode = 'VISION')
	
	SET @text = 'LTVISION' + @LicenseType
	SET @hash_check_configuration = HashBytes('MD5', @text)
	
	SET @Description = (SELECT Description FROM SYSettings 
						WHERE KeyCode = 'LT' AND ModuleCode = 'VISION')	
	SET @hash = UPPER(sys.fn_varbintohexstr(@hash_check_configuration))
	
	IF (@hash <> UPPER(@Description)) 
	Begin
		SET @status = 1
		return @status
	END
				
	--sprawdzenie ilości licencji pełnych
	SET @Pelne = (SELECT SettingValue FROM SYSettings WHERE KeyCode = 'LC' AND ModuleCode = 'VISION')
	
	SET @text = 'LCVISION' + @Pelne
	SET @hash_check_configuration = HashBytes('MD5', @text)
	
	SET @Description = (SELECT Description FROM SYSettings 
						WHERE KeyCode = 'LC' AND ModuleCode = 'VISION')	
	SET @hash = UPPER(sys.fn_varbintohexstr(@hash_check_configuration))
	
	IF (@hash <> UPPER(@Description)) 
	Begin
		SET @status = 1
		return @status
	END

		--sprawdzenie ilości licencji pełnych
	SET @Proste = (SELECT SettingValue FROM SYSettings WHERE KeyCode = 'LCP' AND ModuleCode = 'VISION')	
	SET @text = 'LCPVISION' + @Proste
	SET @hash_check_configuration = HashBytes('MD5', @text)
	
	SET @Description = (SELECT Description FROM SYSettings 
						WHERE KeyCode = 'LCP' AND ModuleCode = 'VISION')	
	SET @hash = UPPER(sys.fn_varbintohexstr(@hash_check_configuration))
	
	IF (@hash <> UPPER(@Description)) 
	Begin
		SET @status = 1
		return @status		
	END

	Set @status = 0

GO