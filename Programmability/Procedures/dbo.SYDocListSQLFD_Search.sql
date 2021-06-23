SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQLFD_Search](
    @DocID nvarchar(50),
    @FieldID nvarchar(50),
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

    SELECT
        DocID, FieldID, Caption, Width, Format,
        Visible, Justification, Calculate, Remarks, ColOrder,
        FType, ColTop, ColLeft, ColWidth, ColHeight,
        ColSetNmbr, ColBackColor, ColForeColor, ColBold, SumaryDisplayFormat,
        SumaryType, GroupSumaryDisplayFormat, GroupSumaryType, GroupSumaryColumnOnly /*, _USERID_ */ 
    FROM SYDocListSQLFD
            /* WHERE Caption = @Caption AND Width = @Width AND Format = @Format AND Visible = @Visible AND Justification = @Justification AND
            Calculate = @Calculate AND Remarks = @Remarks AND ColOrder = @ColOrder AND FType = @FType AND ColTop = @ColTop AND
            ColLeft = @ColLeft AND ColWidth = @ColWidth AND ColHeight = @ColHeight AND ColSetNmbr = @ColSetNmbr AND ColBackColor = @ColBackColor AND
            ColForeColor = @ColForeColor AND ColBold = @ColBold AND SumaryDisplayFormat = @SumaryDisplayFormat AND SumaryType = @SumaryType AND GroupSumaryDisplayFormat = @GroupSumaryDisplayFormat AND
            GroupSumaryType = @GroupSumaryType AND GroupSumaryColumnOnly = @GroupSumaryColumnOnly /*  AND _USERID_ = @_USERID_ */ */
GO