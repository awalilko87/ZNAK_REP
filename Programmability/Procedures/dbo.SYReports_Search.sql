SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYReports_Search](
    @ReportID nvarchar(50),
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
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ReportID, ReportGroupID, ReportName, VisibilityFlags, OrderByClause,
        ReportCaption, IsVisible, ReportType, DescAdmin, DescUser,
        ConnType, RptFileID, FileInDB, OutputType, RptFileID2, ConnectionString /*, _USERID_ */ 
    FROM SYReports
            /* WHERE ReportGroupID = @ReportGroupID AND ReportName = @ReportName AND VisibilityFlags = @VisibilityFlags AND OrderByClause = @OrderByClause AND ReportCaption = @ReportCaption AND
            IsVisible = @IsVisible AND ReportType = @ReportType AND DescAdmin = @DescAdmin AND DescUser = @DescUser AND ConnType = @ConnType AND
            RptFileID = @RptFileID AND FileInDB = @FileInDB AND OutputType = @OutputType AND RptFileID2 = @RptFileID2 /*  AND _USERID_ = @_USERID_ */ */
GO