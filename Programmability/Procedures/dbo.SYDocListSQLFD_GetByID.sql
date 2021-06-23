SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQLFD_GetByID](
    @DocID nvarchar(50) = '%',
    @FieldID nvarchar(50) = '%',
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
         WHERE DocID LIKE @DocID AND FieldID LIKE @FieldID
GO