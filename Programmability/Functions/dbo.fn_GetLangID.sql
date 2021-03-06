SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create FUNCTION [dbo].[fn_GetLangID] (@USERID VARCHAR(50))
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @RES VARCHAR(10)
	SELECT @RES = ISNULL(SYUSERS.[LANGID],'PL') FROM SYUSERS(NOLOCK) WHERE USERID = @USERID
	RETURN @RES
END
GO