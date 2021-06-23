SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportSelects_Search](
    @ReportID nvarchar(50),
    @TableName nvarchar(50),
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

    SELECT
        ReportID, TableName, SQLStmt, HostFieldName, Sheet,
        GlobalSett, BLeft, BTop, BBottom, BRight,
        ForeColor, ForeColorAlt, Font, FontSize, BGColor,
        BGColorAlt, SheetName, MainObject, OrderBy, Dynamic,
        DynamicStartPos, Description, BLeftWeight, BTopWeight, BBottomWeight,
        BRightWeight, BLeftLineStyle, BTopLineStyle, BBottomLineStyle, BRightLineStyle,
        TextQuantifier, NoUsed
    FROM SYReportSelects
            /* WHERE SQLStmt = @SQLStmt AND HostFieldName = @HostFieldName AND Sheet = @Sheet AND GlobalSett = @GlobalSett AND BLeft = @BLeft AND
            BTop = @BTop AND BBottom = @BBottom AND BRight = @BRight AND ForeColor = @ForeColor AND ForeColorAlt = @ForeColorAlt AND
            Font = @Font AND FontSize = @FontSize AND BGColor = @BGColor AND BGColorAlt = @BGColorAlt AND SheetName = @SheetName AND
            MainObject = @MainObject AND OrderBy = @OrderBy AND Dynamic = @Dynamic AND DynamicStartPos = @DynamicStartPos AND Description = @Description AND
            BLeftWeight = @BLeftWeight AND BTopWeight = @BTopWeight AND BBottomWeight = @BBottomWeight AND BRightWeight = @BRightWeight AND BLeftLineStyle = @BLeftLineStyle AND
            BTopLineStyle = @BTopLineStyle AND BBottomLineStyle = @BBottomLineStyle AND BRightLineStyle = @BRightLineStyle AND TextQuantifier = @TextQuantifier AND NoUsed = @NoUsed*/
GO