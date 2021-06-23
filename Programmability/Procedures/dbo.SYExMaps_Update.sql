SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYExMaps_Update](
    @MapID nvarchar(50) OUT,
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

IF @MapID is null
    SET @MapID = NewID()
IF @MapID =''
    SET @MapID = NewID()

IF NOT EXISTS (SELECT * FROM SYExMaps WHERE MapID = @MapID)
BEGIN
    INSERT INTO SYExMaps(
        MapID, ReportID, TableName, FieldName, IsFixedColumn,
        IsFixedRow, ExColumn, ExRow, IsDisable, Formula,
        BLeft, BTop, BBottom, BRight, ForeColor,
        ForeColorAlt, Font, FontSize, BGColor, BGColorAlt,
        Type, HorizontalAlignment, VerticalAlignment, [Option], BLeftWeight,
        BTopWeight, BBottomWeight, BRightWeight, BLeftLineStyle, BTopLineStyle,
        BBottomLineStyle, BRightLineStyle, ColumnWidth, Orientation, NumberFormat,
        Bold, Italic, Underline, RowHeight, WrapText,
        Autofit, BRightColor, BLeftColor, BTopColor, BBottomColor)
    VALUES (
        @MapID, @ReportID, @TableName, @FieldName, @IsFixedColumn,
        @IsFixedRow, @ExColumn, @ExRow, @IsDisable, @Formula,
        @BLeft, @BTop, @BBottom, @BRight, @ForeColor,
        @ForeColorAlt, @Font, @FontSize, @BGColor, @BGColorAlt,
        @Type, @HorizontalAlignment, @VerticalAlignment, @Option, @BLeftWeight,
        @BTopWeight, @BBottomWeight, @BRightWeight, @BLeftLineStyle, @BTopLineStyle,
        @BBottomLineStyle, @BRightLineStyle, @ColumnWidth, @Orientation, @NumberFormat,
        @Bold, @Italic, @Underline, @RowHeight, @WrapText,
        @Autofit, @BRightColor, @BLeftColor, @BTopColor, @BBottomColor)
END
ELSE
BEGIN
    UPDATE SYExMaps SET
        ReportID = @ReportID, TableName = @TableName, FieldName = @FieldName, IsFixedColumn = @IsFixedColumn, IsFixedRow = @IsFixedRow,
        ExColumn = @ExColumn, ExRow = @ExRow, IsDisable = @IsDisable, Formula = @Formula, BLeft = @BLeft,
        BTop = @BTop, BBottom = @BBottom, BRight = @BRight, ForeColor = @ForeColor, ForeColorAlt = @ForeColorAlt,
        Font = @Font, FontSize = @FontSize, BGColor = @BGColor, BGColorAlt = @BGColorAlt, Type = @Type,
        HorizontalAlignment = @HorizontalAlignment, VerticalAlignment = @VerticalAlignment, [Option] = @Option, BLeftWeight = @BLeftWeight, BTopWeight = @BTopWeight,
        BBottomWeight = @BBottomWeight, BRightWeight = @BRightWeight, BLeftLineStyle = @BLeftLineStyle, BTopLineStyle = @BTopLineStyle, BBottomLineStyle = @BBottomLineStyle,
        BRightLineStyle = @BRightLineStyle, ColumnWidth = @ColumnWidth, Orientation = @Orientation, NumberFormat = @NumberFormat, Bold = @Bold,
        Italic = @Italic, Underline = @Underline, RowHeight = @RowHeight, WrapText = @WrapText, Autofit = @Autofit,
        BRightColor = @BRightColor, BLeftColor = @BLeftColor, BTopColor = @BTopColor, BBottomColor = @BBottomColor
        WHERE MapID = @MapID
END
GO