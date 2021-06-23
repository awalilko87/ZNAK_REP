SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Reports_Remove](
    @ReportID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
    DELETE FROM VS_Reports WHERE ReportID = @ReportID
GO