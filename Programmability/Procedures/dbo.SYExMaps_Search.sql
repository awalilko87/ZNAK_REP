SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYExMaps_Search](
    @MapID nvarchar(50),
    @ReportID nvarchar(50) = null,
    @TableName nvarchar(50) = null,
    @FieldName nvarchar(50) = null,
    @IsFixedColumn bit = null,
    @IsFixedRow bit = null,
    @ExColumn nvarchar(10) = null,
    @ExRow nvarchar(10) = null,
    @IsDisable bit = null,
    @Formula nvarchar(4000) = null,
    @BLeft bit = null,
    @BTop bit = null,
    @BBottom bit = null,
    @BRight bit = null,
    @ForeColor nvarchar(10) = null,
    @ForeColorAlt nvarchar(10) = null,
    @Font nvarchar(50) = null,
    @FontSize int = null,
    @BGColor nvarchar(10) = null,
    @BGColorAlt nvarchar(10) = null,
    @Type nvarchar(20) = null,
    @HorizontalAlignment nvarchar(20) = null,
    @VerticalAlignment nvarchar(20) = null,
    @Option nvarchar(4000) = null,
    @BLeftWeight nvarchar(15) = null,
    @BTopWeight nvarchar(15) = null,
    @BBottomWeight nvarchar(15) = null,
    @BRightWeight nvarchar(15) = null,
    @BLeftLineStyle nvarchar(15) = null,
    @BTopLineStyle nvarchar(15) = null,
    @BBottomLineStyle nvarchar(15) = null,
    @BRightLineStyle nvarchar(15) = null,
    @ColumnWidth numeric(18,2) = null,
    @Orientation int = null,
    @NumberFormat nvarchar(100) = null,
    @Bold bit = null,
    @Italic bit = null,
    @Underline bit = null,
    @RowHeight numeric(18,2) = null,
    @WrapText bit = null,
    @Autofit bit = null,
    @BRightColor nvarchar(10) = null,
    @BLeftColor nvarchar(10) = null,
    @BTopColor nvarchar(10) = null,
    @BBottomColor nvarchar(10) = null
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
            /* WHERE ReportID = @ReportID AND TableName = @TableName AND FieldName = @FieldName AND IsFixedColumn = @IsFixedColumn AND IsFixedRow = @IsFixedRow AND
            ExColumn = @ExColumn AND ExRow = @ExRow AND IsDisable = @IsDisable AND Formula = @Formula AND BLeft = @BLeft AND
            BTop = @BTop AND BBottom = @BBottom AND BRight = @BRight AND ForeColor = @ForeColor AND ForeColorAlt = @ForeColorAlt AND
            Font = @Font AND FontSize = @FontSize AND BGColor = @BGColor AND BGColorAlt = @BGColorAlt AND Type = @Type AND
            HorizontalAlignment = @HorizontalAlignment AND VerticalAlignment = @VerticalAlignment AND Option = @Option AND BLeftWeight = @BLeftWeight AND BTopWeight = @BTopWeight AND
            BBottomWeight = @BBottomWeight AND BRightWeight = @BRightWeight AND BLeftLineStyle = @BLeftLineStyle AND BTopLineStyle = @BTopLineStyle AND BBottomLineStyle = @BBottomLineStyle AND
            BRightLineStyle = @BRightLineStyle AND ColumnWidth = @ColumnWidth AND Orientation = @Orientation AND NumberFormat = @NumberFormat AND Bold = @Bold AND
            Italic = @Italic AND Underline = @Underline AND RowHeight = @RowHeight AND WrapText = @WrapText AND Autofit = @Autofit AND
            BRightColor = @BRightColor AND BLeftColor = @BLeftColor AND BTopColor = @BTopColor AND BBottomColor = @BBottomColor*/
GO