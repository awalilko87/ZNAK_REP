SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYExMaps_Get](
    @_USERID_ varchar(20) = null
)
WITH ENCRYPTION
AS

    SELECT
        MapID, ReportID, TableName, FieldName, IsFixedColumn,
        IsFixedRow, ExColumn, ExRow, IsDisable, Formula,
        BLeft, BTop, BBottom, BRight, ForeColor,
        ForeColorAlt, Font, FontSize, BGColor, BGColorAlt,
        Type, HorizontalAlignment, VerticalAlignment, [Option], BLeftWeight,
        BTopWeight, BBottomWeight, BRightWeight, BLeftLineStyle, BTopLineStyle,
        BBottomLineStyle, BRightLineStyle, ColumnWidth, Orientation, NumberFormat,
        Bold, Italic, Underline, RowHeight, WrapText,
        Autofit, BRightColor, BLeftColor, BTopColor, BBottomColor
    FROM SYExMaps
GO