SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportSelects_RemoveByReportID](
    @ReportID nvarchar(50)
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYReportSelects
            WHERE ReportID = @ReportID
GO