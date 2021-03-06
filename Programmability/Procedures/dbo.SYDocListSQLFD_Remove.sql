SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQLFD_Remove](
    @DocID nvarchar(50),
    @FieldID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYDocListSQLFD
            WHERE DocID = @DocID AND FieldID = @FieldID
GO