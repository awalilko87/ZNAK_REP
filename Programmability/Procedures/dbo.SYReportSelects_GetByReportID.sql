SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportSelects_GetByReportID](
    @ReportID varchar(50)
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
         WHERE ReportID = @ReportID
	ORDER BY OrderBy
GO