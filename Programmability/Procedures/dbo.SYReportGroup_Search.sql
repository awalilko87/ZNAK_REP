SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportGroup_Search](
    @ReportGroupId nvarchar(50),
    @ReportGroupName nvarchar(50),
    @VisibilityFlags nvarchar(200),
    @OrderByClause numeric(18,5),
    @MenuItemID nvarchar(50),
    @IsVisible bit,
    @DefaultReport nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ReportGroupId, ReportGroupName, VisibilityFlags, OrderByClause, MenuItemID,
        IsVisible, DefaultReport /*, _USERID_ */ 
    FROM SYReportGroup
            /* WHERE ReportGroupName = @ReportGroupName AND VisibilityFlags = @VisibilityFlags AND OrderByClause = @OrderByClause AND MenuItemID = @MenuItemID AND IsVisible = @IsVisible AND
            DefaultReport = @DefaultReport /*  AND _USERID_ = @_USERID_ */ */
GO