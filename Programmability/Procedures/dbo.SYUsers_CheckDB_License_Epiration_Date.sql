SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUsers_CheckDB_License_Epiration_Date](@status int OUT)
WITH ENCRYPTION
AS
	DECLARE @Date nvarchar(4000),
			@hash varchar(255),
			@hash_session_count varbinary(255),
			@text nvarchar(255),
			@KeyCode nvarchar(50),
			@ModuleCode nvarchar(50),
			@Description nvarchar(50)

	SET @Date = (SELECT SettingValue FROM SYSettings WHERE KeyCode = 'DB_LICENSE_EXPIRATION_DATE' AND ModuleCode = 'VISION')
	
	IF (@Date <> '19000101')	
	BEGIN
		SET @KeyCode = 'DB_LICENSE_EXPIRATION_DATE'
		SET @ModuleCode = 'VISION'
		SET @text = @KeyCode + @ModuleCode + @Date
		SET @hash_session_count = HashBytes('MD5', @text)
		
		SET @Description = (SELECT Description FROM SYSettings 
							WHERE KeyCode = 'DB_LICENSE_EXPIRATION_DATE' AND ModuleCode = 'VISION')
		SET @hash = UPPER(sys.fn_varbintohexstr(@hash_session_count))

		IF (@hash <> UPPER(@Description)) 
			SET @status = 1
		ELSE
			IF (CONVERT(datetime, ISNULL(@Date, '20991231')) >= GetDate())
				SET @status = 0
			ELSE
				SET @status = 2
	END
	ELSE
		SET @status = 0
	
GO