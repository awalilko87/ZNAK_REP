SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Reports_GetByID](
    @ReportID nvarchar(50) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ReportID, ReportName, SQLSelect, SQLFrom, SQLWhere,
        SQLOrderBy, UserID, IsPublic /*, _USERID_ */ , IsRdl
    FROM VS_Reports
         WHERE ReportID LIKE @ReportID
GO