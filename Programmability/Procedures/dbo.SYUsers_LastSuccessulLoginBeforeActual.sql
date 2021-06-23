SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUsers_LastSuccessulLoginBeforeActual](@UserID nvarchar(30), @IsADLogin bit)
WITH ENCRYPTION
AS
    DECLARE @RET datetime
	IF @IsADLogin =1 
		SET @RET = isnull((SELECT top 1 LastSuccessfulLogin FROM SYUsers WHERE ADLogin = @UserID), '1900-01-01')
	ELSE
		SET @RET = isnull((SELECT top 1 LastSuccessfulLogin FROM SYUsers WHERE UserID = @UserID), '1900-01-01')
	SELECT @RET
GO