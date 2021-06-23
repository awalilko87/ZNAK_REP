SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReports_Update](
    @ReportID nvarchar(50) OUT,
    @ReportGroupID nvarchar(50),
    @ReportName nvarchar(50),
    @VisibilityFlags nvarchar(200),
    @OrderByClause numeric(18,5),
    @ReportCaption nvarchar(100),
    @IsVisible bit,
    @ReportType nvarchar(10),
    @DescAdmin nvarchar(2000),
    @DescUser nvarchar(max),
    @ConnType nvarchar(50),
    @RptFileID int,
    @FileInDB bit,
    @OutputType nvarchar(10),
    @RptFileID2 nvarchar(50),
	@ConnectionString nvarchar(30),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF @ReportID is null
    SET @ReportID = NewID()
IF @ReportID =''
    SET @ReportID = NewID()

IF NOT EXISTS (SELECT * FROM SYReports WHERE ReportID = @ReportID)
BEGIN
    INSERT INTO SYReports(
        ReportID, ReportGroupID, ReportName, VisibilityFlags, OrderByClause,
        ReportCaption, IsVisible, ReportType, DescAdmin, DescUser,
        ConnType, RptFileID, FileInDB, OutputType, RptFileID2, ConnectionString  /*, _USERID_ */ )
    VALUES (
        @ReportID, @ReportGroupID, @ReportName, @VisibilityFlags, @OrderByClause,
        @ReportCaption, @IsVisible, @ReportType, @DescAdmin, @DescUser,
        @ConnType, @RptFileID, @FileInDB, @OutputType, @RptFileID2, @ConnectionString /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE SYReports SET
        ReportGroupID = @ReportGroupID, ReportName = @ReportName, VisibilityFlags = @VisibilityFlags, OrderByClause = @OrderByClause, ReportCaption = @ReportCaption,
        IsVisible = @IsVisible, ReportType = @ReportType, DescAdmin = @DescAdmin, DescUser = @DescUser, ConnType = @ConnType,
        RptFileID = @RptFileID, FileInDB = @FileInDB, OutputType = @OutputType, RptFileID2 = @RptFileID2, ConnectionString = @ConnectionString /* , _USERID_ = @_USERID_ */ 
        WHERE ReportID = @ReportID
END
GO