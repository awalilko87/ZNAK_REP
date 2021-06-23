SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportGroup_GetDefaultReport](
    @ReportID nvarchar(50)
)
WITH ENCRYPTION
AS

SELECT DefaultReport FROM SYReportGroup WHERE ReportGroupId = (SELECT ReportGroupID FROM SYReports WHERE ReportID = @ReportID)
GO