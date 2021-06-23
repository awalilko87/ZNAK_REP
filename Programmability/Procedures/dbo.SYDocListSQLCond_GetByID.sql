SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQLCond_GetByID](
    @ConditionID nvarchar(50) = '%',
    @DocID nvarchar(50) = '%',
    @FieldID nvarchar(50) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ConditionID, DocID, FieldID, Operator, Value1,
        Value1Type, Value2, Value2Type, ForeColor, BackColor,
        FontBold /*, _USERID_ */ 
    FROM SYDocListSQLCond
         WHERE ConditionID LIKE @ConditionID AND DocID LIKE @DocID AND FieldID LIKE @FieldID
GO