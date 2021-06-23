SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQLCond_Update](
    @ConditionID nvarchar(50) OUT,
    @DocID nvarchar(50) OUT,
    @FieldID nvarchar(50) OUT,
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

IF @ConditionID is null
    SET @ConditionID = NewID()
IF @ConditionID =''
    SET @ConditionID = NewID()
IF @DocID is null
    SET @DocID = NewID()
IF @DocID =''
    SET @DocID = NewID()
IF @FieldID is null
    SET @FieldID = NewID()
IF @FieldID =''
    SET @FieldID = NewID()

IF NOT EXISTS (SELECT * FROM SYDocListSQLCond WHERE ConditionID = @ConditionID AND DocID = @DocID AND FieldID = @FieldID)
BEGIN
    INSERT INTO SYDocListSQLCond(
        ConditionID, DocID, FieldID, Operator, Value1,
        Value1Type, Value2, Value2Type, ForeColor, BackColor,
        FontBold /*, _USERID_ */ )
    VALUES (
        @ConditionID, @DocID, @FieldID, @Operator, @Value1,
        @Value1Type, @Value2, @Value2Type, @ForeColor, @BackColor,
        @FontBold /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE SYDocListSQLCond SET
        Operator = @Operator, Value1 = @Value1, Value1Type = @Value1Type, Value2 = @Value2, Value2Type = @Value2Type,
        ForeColor = @ForeColor, BackColor = @BackColor, FontBold = @FontBold /* , _USERID_ = @_USERID_ */ 
        WHERE ConditionID = @ConditionID AND DocID = @DocID AND FieldID = @FieldID
END
GO