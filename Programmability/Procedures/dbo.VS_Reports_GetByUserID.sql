SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Reports_GetByUserID](
    @UserID nvarchar(30) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF ((SELECT UserGroupID FROM SYUsers WHERE UserID = @UserID) = 'SA')
  BEGIN
    SELECT 
        ReportID, ReportName, SQLSelect, SQLFrom, SQLWhere,
        SQLOrderBy, UserID, IsPublic /*, _USERID_ */ , IsRdl
    FROM VS_Reports
  END
ELSE
  BEGIN
    SELECT
        ReportID, ReportName, SQLSelect, SQLFrom, SQLWhere,
        SQLOrderBy, UserID, IsPublic /*, _USERID_ */, IsRdl
    FROM VS_Reports
         WHERE UserID = @UserID OR IsPublic = 1
  END
GO