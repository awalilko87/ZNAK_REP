SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYExMaps_GetByReportIDToUse](
    @ReportID nvarchar(50)
)
WITH ENCRYPTION
AS

    SELECT
        MapID, ReportID, TableName, FieldName, IsFixedColumn,
        IsFixedRow, ExColumn, ExRow, IsDisable, Formula,
        BLeft, BTop, BBottom, BRight, ForeColor,
        ForeColorAlt, Font, FontSize, BGColor, BGColorAlt,
        [Type], HorizontalAlignment, VerticalAlignment, [Option], BLeftWeight,
        BTopWeight, BBottomWeight, BRightWeight, BLeftLineStyle, BTopLineStyle,
        BBottomLineStyle, BRightLineStyle, ColumnWidth, Orientation, NumberFormat,
        Bold, Italic, Underline, RowHeight, WrapText,
        Autofit, BRightColor, BLeftColor, BTopColor, BBottomColor
    FROM SYExMaps
         WHERE ReportID = @ReportID
GO