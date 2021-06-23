SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReports_GetByReportGroupID](
    @ReportGroupID nvarchar(50) = '%',
	@Filtr nvarchar(100),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ReportID, ReportGroupID, ReportName, VisibilityFlags, OrderByClause,
        ReportCaption, IsVisible, ReportType, DescAdmin, DescUser,
        ConnType, RptFileID, FileInDB, OutputType, RptFileID2, ConnectionString /*, _USERID_ */ 
    FROM SYReports
         WHERE ReportGroupID = @ReportGroupID 
			AND (ReportID LIKE '%' + @Filtr + '%' OR ReportName LIKE '%' + @Filtr + '%' OR ReportCaption LIKE '%' + @Filtr + '%')
	ORDER BY ReportID
GO