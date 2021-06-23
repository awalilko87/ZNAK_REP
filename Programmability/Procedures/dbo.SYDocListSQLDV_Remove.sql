SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQLDV_Remove](
    @DocID nvarchar(50),
    @FieldName nvarchar(50),
    @FieldValue nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYDocListSQLDV
            WHERE DocID = @DocID AND FieldName = @FieldName AND FieldValue = @FieldValue
GO