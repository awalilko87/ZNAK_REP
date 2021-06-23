SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportGroup_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ReportGroupId, ReportGroupName, VisibilityFlags, OrderByClause, MenuItemID,
        IsVisible, DefaultReport /*, _USERID_ */ 
    FROM SYReportGroup
	ORDER BY ReportGroupId
GO