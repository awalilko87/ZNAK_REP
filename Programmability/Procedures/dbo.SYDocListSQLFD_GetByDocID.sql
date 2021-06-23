SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQLFD_GetByDocID](
    @DocID nvarchar(50),
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
         WHERE DocID = @DocID
	ORDER BY ColOrder
GO