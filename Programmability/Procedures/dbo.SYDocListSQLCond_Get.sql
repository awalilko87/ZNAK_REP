SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQLCond_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ConditionID, DocID, FieldID, Operator, Value1,
        Value1Type, Value2, Value2Type, ForeColor, BackColor,
        FontBold /*, _USERID_ */ 
    FROM SYDocListSQLCond
GO