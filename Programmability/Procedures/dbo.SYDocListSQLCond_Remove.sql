SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQLCond_Remove](
    @ConditionID nvarchar(50),
    @DocID nvarchar(50),
    @FieldID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYDocListSQLCond
            WHERE ConditionID = @ConditionID AND DocID = @DocID AND FieldID = @FieldID
GO