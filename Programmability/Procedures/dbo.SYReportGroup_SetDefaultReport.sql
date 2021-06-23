SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportGroup_SetDefaultReport](
    @ReportGroupId nvarchar(50),
    @ReportID nvarchar(50)
)
WITH ENCRYPTION
AS

UPDATE SYReportGroup SET
	DefaultReport = @ReportID 
	WHERE ReportGroupId = @ReportGroupId

GO