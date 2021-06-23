SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReportGroup_Update](
    @ReportGroupId nvarchar(50) OUT,
    @ReportGroupName nvarchar(50),
    @VisibilityFlags nvarchar(200),
    @OrderByClause numeric(18,5),
    @MenuItemID nvarchar(50),
    @IsVisible bit,
    @DefaultReport nvarchar(50),
    @_USERID_ nvarchar(320) = null
)
WITH ENCRYPTION
AS

IF @ReportGroupId is null
    SET @ReportGroupId = NewID()
IF @ReportGroupId =''
    SET @ReportGroupId = NewID()

IF NOT EXISTS (SELECT * FROM SYReportGroup WHERE ReportGroupId = @ReportGroupId)
BEGIN
    INSERT INTO SYReportGroup(
        ReportGroupId, ReportGroupName, VisibilityFlags, OrderByClause, MenuItemID,
        IsVisible, DefaultReport /*, _USERID_ */ )
    VALUES (
        @ReportGroupId, @ReportGroupName, @VisibilityFlags, @OrderByClause, @MenuItemID,
        @IsVisible, @DefaultReport /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE SYReportGroup SET
        ReportGroupName = @ReportGroupName, VisibilityFlags = @VisibilityFlags, OrderByClause = @OrderByClause, MenuItemID = @MenuItemID, IsVisible = @IsVisible,
        DefaultReport = @DefaultReport /* , _USERID_ = @_USERID_ */ 
        WHERE ReportGroupId = @ReportGroupId
END
GO