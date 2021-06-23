SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReports_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ReportID, ReportGroupID, ReportName, VisibilityFlags, OrderByClause,
        ReportCaption, IsVisible, ReportType, DescAdmin, DescUser,
        ConnType, RptFileID, FileInDB, OutputType, RptFileID2, ConnectionString /*, _USERID_ */ 
    FROM SYReports
	ORDER BY ReportID
GO