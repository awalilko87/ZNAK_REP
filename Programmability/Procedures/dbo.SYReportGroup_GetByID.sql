SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportGroup_GetByID](
    @ReportGroupId nvarchar(50) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ReportGroupId, ReportGroupName, VisibilityFlags, OrderByClause, MenuItemID,
        IsVisible, DefaultReport /*, _USERID_ */ 
    FROM SYReportGroup
         WHERE ReportGroupId LIKE @ReportGroupId
GO