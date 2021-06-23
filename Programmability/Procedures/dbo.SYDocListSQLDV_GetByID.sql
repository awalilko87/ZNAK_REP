SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQLDV_GetByID](
    @DocID nvarchar(50) = '%',
    @FieldName nvarchar(50) = '%',
    @FieldValue nvarchar(50) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        DocID, FieldName, FieldValue, Display, Remarks /*, _USERID_ */ 
    FROM SYDocListSQLDV
         WHERE DocID LIKE @DocID AND FieldName LIKE @FieldName AND FieldValue LIKE @FieldValue
GO