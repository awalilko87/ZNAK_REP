SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Reports_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ReportID, ReportName, SQLSelect, SQLFrom, SQLWhere,
        SQLOrderBy, UserID, IsPublic /*, _USERID_ */ ,IsRdl
    FROM VS_Reports
GO