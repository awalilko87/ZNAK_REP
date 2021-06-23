SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Langs_GetByID](
    @LangID nvarchar(10) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        LangID, LangName /*, _USERID_ */ 
    FROM VS_Langs
         WHERE LangID LIKE @LangID
GO