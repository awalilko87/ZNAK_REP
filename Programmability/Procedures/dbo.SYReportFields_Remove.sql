SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportFields_Remove](
    @FieldID nvarchar(50),
    @ReportID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYReportFields
            WHERE FieldID = @FieldID AND ReportID = @ReportID
GO