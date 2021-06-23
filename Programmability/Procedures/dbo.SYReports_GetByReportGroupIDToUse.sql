SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReports_GetByReportGroupIDToUse](
    @ReportGroupID nvarchar(50) = '%'
)
WITH ENCRYPTION
AS
	SELECT
        ReportID, ReportGroupID, ReportName, VisibilityFlags, OrderByClause,
        ReportCaption, IsVisible, ReportType, DescAdmin, DescUser,
        ConnType, RptFileID, FileInDB, OutputType, RptFileID2, ConnectionString /*, _USERID_ */ 
    FROM SYReports
         WHERE ReportGroupID = @ReportGroupID AND IsVisible = 1
	ORDER BY ReportID
GO