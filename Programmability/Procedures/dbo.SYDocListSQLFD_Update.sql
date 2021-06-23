SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQLFD_Update](
    @DocID nvarchar(50) OUT,
    @FieldID nvarchar(50) OUT,
    @Caption nvarchar(20),
    @Width int,
    @Format nvarchar(20),
    @Visible bit,
    @Justification nvarchar(1),
    @Calculate nvarchar(1000),
    @Remarks nvarchar(1000),
    @ColOrder int,
    @FType nvarchar(10),
    @ColTop int,
    @ColLeft int,
    @ColWidth int,
    @ColHeight int,
    @ColSetNmbr int,
    @ColBackColor nvarchar(10),
    @ColForeColor nvarchar(10),
    @ColBold bit,
    @SumaryDisplayFormat nvarchar(50),
    @SumaryType int,
    @GroupSumaryDisplayFormat nvarchar(50),
    @GroupSumaryType int,
    @GroupSumaryColumnOnly int,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF @DocID is null
    SET @DocID = NewID()
IF @DocID =''
    SET @DocID = NewID()
IF @FieldID is null
    SET @FieldID = NewID()
IF @FieldID =''
    SET @FieldID = NewID()

IF NOT EXISTS (SELECT * FROM SYDocListSQLFD WHERE DocID = @DocID AND FieldID = @FieldID)
BEGIN
    INSERT INTO SYDocListSQLFD(
        DocID, FieldID, Caption, Width, Format,
        Visible, Justification, Calculate, Remarks, ColOrder,
        FType, ColTop, ColLeft, ColWidth, ColHeight,
        ColSetNmbr, ColBackColor, ColForeColor, ColBold, SumaryDisplayFormat,
        SumaryType, GroupSumaryDisplayFormat, GroupSumaryType, GroupSumaryColumnOnly /*, _USERID_ */ )
    VALUES (
        @DocID, @FieldID, @Caption, @Width, @Format,
        @Visible, @Justification, @Calculate, @Remarks, @ColOrder,
        @FType, @ColTop, @ColLeft, @ColWidth, @ColHeight,
        @ColSetNmbr, @ColBackColor, @ColForeColor, @ColBold, @SumaryDisplayFormat,
        @SumaryType, @GroupSumaryDisplayFormat, @GroupSumaryType, @GroupSumaryColumnOnly /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE SYDocListSQLFD SET
        Caption = @Caption, Width = @Width, Format = @Format, Visible = @Visible, Justification = @Justification,
        Calculate = @Calculate, Remarks = @Remarks, ColOrder = @ColOrder, FType = @FType, ColTop = @ColTop,
        ColLeft = @ColLeft, ColWidth = @ColWidth, ColHeight = @ColHeight, ColSetNmbr = @ColSetNmbr, ColBackColor = @ColBackColor,
        ColForeColor = @ColForeColor, ColBold = @ColBold, SumaryDisplayFormat = @SumaryDisplayFormat, SumaryType = @SumaryType, GroupSumaryDisplayFormat = @GroupSumaryDisplayFormat,
        GroupSumaryType = @GroupSumaryType, GroupSumaryColumnOnly = @GroupSumaryColumnOnly /* , _USERID_ = @_USERID_ */ 
        WHERE DocID = @DocID AND FieldID = @FieldID
END
GO