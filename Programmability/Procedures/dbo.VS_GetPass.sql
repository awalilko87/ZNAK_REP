SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_GetPass](@Password nvarchar(50))
WITH ENCRYPTION
AS
	DECLARE @DecodePassType nvarchar(10)

	SELECT top 1 @DecodePassType = convert(nvarchar(10),SettingValue) 
	FROM dbo.SYSettings (nolock) 
	WHERE KeyCode = 'PTYPE' and ModuleCode = 'VISION'

	IF @DecodePassType = ''
	BEGIN
		SET @Password = @Password
	END
	IF @DecodePassType = 'P1'
	BEGIN
		SET @Password = (SELECT dbo.P1(@Password))
	END
	IF @DecodePassType = 'D7i'
	BEGIN
		SET @Password = (SELECT dbo.Pass_D7i(@Password))
	END
	IF @DecodePassType = 'MP2'
	BEGIN
		SET @Password = (SELECT dbo.Pass_MP2(@Password))
	END
	
	SELECT @Password
    
GO