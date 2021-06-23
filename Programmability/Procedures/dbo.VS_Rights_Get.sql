SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Rights_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        UserID, FormID, FieldID, Rights, Cond,
        rReadOnly, rVisible, rRequire /*, _USERID_ */ 
    FROM VS_Rights
GO