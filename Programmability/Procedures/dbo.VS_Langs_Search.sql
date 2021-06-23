SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Langs_Search](
    @LangID nvarchar(10),
    @LangName nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        LangID, LangName /*, _USERID_ */ 
    FROM VS_Langs
            /* WHERE LangName = @LangName /*  AND _USERID_ = @_USERID_ */ */
GO