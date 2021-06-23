SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQLDV_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        DocID, FieldName, FieldValue, Display, Remarks /*, _USERID_ */ 
    FROM SYDocListSQLDV
GO