SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReports_GetReportName](
    @ReportID nvarchar(50)
)
WITH ENCRYPTION
AS

    SELECT ReportName
    FROM SYReports
    WHERE ReportID = @ReportID
GO