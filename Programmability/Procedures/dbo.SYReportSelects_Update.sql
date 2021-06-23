SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportSelects_Update](
    @ReportID nvarchar(50) OUT,
    @TableName nvarchar(50) OUT,
    @SQLStmt nvarchar(max) = null,
    @HostFieldName nvarchar(50) = null,
    @Sheet int = null,
    @GlobalSett bit = null,
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
    @SheetName nvarchar(50) = null,
    @MainObject nvarchar(50) = null,
    @OrderBy int = null,
    @Dynamic bit = null,
    @DynamicStartPos nvarchar(50) = null,
    @Description nvarchar(max) = null,
    @BLeftWeight nvarchar(15) = null,
    @BTopWeight nvarchar(15) = null,
    @BBottomWeight nvarchar(15) = null,
    @BRightWeight nvarchar(15) = null,
    @BLeftLineStyle nvarchar(15) = null,
    @BTopLineStyle nvarchar(15) = null,
    @BBottomLineStyle nvarchar(15) = null,
    @BRightLineStyle nvarchar(15) = null,
    @TextQuantifier nvarchar(50) = null,
    @NoUsed bit = null
)
WITH ENCRYPTION
AS

--IF @ReportID is null
--    SET @ReportID = NewID()
--IF @ReportID =''
--    SET @ReportID = NewID()
--IF @TableName is null
--    SET @TableName = NewID()
--IF @TableName =''
--    SET @TableName = NewID()

IF NOT EXISTS (SELECT * FROM SYReportSelects WHERE ReportID = @ReportID AND TableName = @TableName)
BEGIN
    INSERT INTO SYReportSelects(
        ReportID, TableName, SQLStmt, HostFieldName, Sheet,
        GlobalSett, BLeft, BTop, BBottom, BRight,
        ForeColor, ForeColorAlt, Font, FontSize, BGColor,
        BGColorAlt, SheetName, MainObject, OrderBy, Dynamic,
        DynamicStartPos, Description, BLeftWeight, BTopWeight, BBottomWeight,
        BRightWeight, BLeftLineStyle, BTopLineStyle, BBottomLineStyle, BRightLineStyle,
        TextQuantifier, NoUsed)
    VALUES (
        @ReportID, @TableName, @SQLStmt, @HostFieldName, @Sheet,
        @GlobalSett, @BLeft, @BTop, @BBottom, @BRight,
        @ForeColor, @ForeColorAlt, @Font, @FontSize, @BGColor,
        @BGColorAlt, @SheetName, @MainObject, @OrderBy, @Dynamic,
        @DynamicStartPos, @Description, @BLeftWeight, @BTopWeight, @BBottomWeight,
        @BRightWeight, @BLeftLineStyle, @BTopLineStyle, @BBottomLineStyle, @BRightLineStyle,
        @TextQuantifier, @NoUsed)
END
ELSE
BEGIN
    UPDATE SYReportSelects SET
        SQLStmt = @SQLStmt, HostFieldName = @HostFieldName, Sheet = @Sheet, GlobalSett = @GlobalSett, BLeft = @BLeft,
        BTop = @BTop, BBottom = @BBottom, BRight = @BRight, ForeColor = @ForeColor, ForeColorAlt = @ForeColorAlt,
        Font = @Font, FontSize = @FontSize, BGColor = @BGColor, BGColorAlt = @BGColorAlt, SheetName = @SheetName,
        MainObject = @MainObject, OrderBy = @OrderBy, Dynamic = @Dynamic, DynamicStartPos = @DynamicStartPos, Description = @Description,
        BLeftWeight = @BLeftWeight, BTopWeight = @BTopWeight, BBottomWeight = @BBottomWeight, BRightWeight = @BRightWeight, BLeftLineStyle = @BLeftLineStyle,
        BTopLineStyle = @BTopLineStyle, BBottomLineStyle = @BBottomLineStyle, BRightLineStyle = @BRightLineStyle, TextQuantifier = @TextQuantifier, NoUsed = @NoUsed
        WHERE ReportID = @ReportID AND TableName = @TableName
END
GO