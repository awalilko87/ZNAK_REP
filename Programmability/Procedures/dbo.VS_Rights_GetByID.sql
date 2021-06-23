SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Rights_GetByID](
    @Cond nvarchar(100) = '%',
    @FieldID nvarchar(50) = '%',
    @FormID nvarchar(50) = '%',
    @UserID nvarchar(30) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        UserID, FormID, FieldID, Rights, Cond,
        rReadOnly, rVisible, rRequire /*, _USERID_ */ 
    FROM VS_Rights
         WHERE Cond LIKE @Cond AND FieldID LIKE @FieldID AND FormID LIKE @FormID AND UserID LIKE @UserID
GO