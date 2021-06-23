SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQLCond_Search](
    @ConditionID nvarchar(50),
    @DocID nvarchar(50),
    @FieldID nvarchar(50),
    @Operator int,
    @Value1 nvarchar(50),
    @Value1Type nvarchar(10),
    @Value2 nvarchar(50),
    @Value2Type nvarchar(10),
    @ForeColor nvarchar(10),
    @BackColor nvarchar(10),
    @FontBold bit,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ConditionID, DocID, FieldID, Operator, Value1,
        Value1Type, Value2, Value2Type, ForeColor, BackColor,
        FontBold /*, _USERID_ */ 
    FROM SYDocListSQLCond
            /* WHERE Operator = @Operator AND Value1 = @Value1 AND Value1Type = @Value1Type AND Value2 = @Value2 AND Value2Type = @Value2Type AND
            ForeColor = @ForeColor AND BackColor = @BackColor AND FontBold = @FontBold /*  AND _USERID_ = @_USERID_ */ */
GO