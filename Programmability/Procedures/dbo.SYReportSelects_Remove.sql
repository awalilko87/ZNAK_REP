SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportSelects_Remove](
    @ReportID nvarchar(50),
    @TableName nvarchar(50)
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYReportSelects
            WHERE ReportID = @ReportID AND TableName = @TableName
GO