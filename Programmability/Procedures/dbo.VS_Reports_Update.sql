SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Reports_Update](
    @ReportID nvarchar(50) OUT,
    @ReportName nvarchar(50),
    @SQLSelect nvarchar(3500),
    @SQLFrom nvarchar(200),
    @SQLWhere nvarchar(200),
    @SQLOrderBy nvarchar(100),
    @UserID nvarchar(30),
    @IsPublic bit,
    @_USERID_ nvarchar(30) = null,
	@IsRdl bit = null
)
WITH ENCRYPTION
AS

IF @ReportID is null
    SET @ReportID = NewID()
IF @ReportID =''
    SET @ReportID = NewID()

IF NOT EXISTS (SELECT * FROM VS_Reports WHERE ReportID = @ReportID)
BEGIN
    INSERT INTO VS_Reports(
        ReportID, ReportName, SQLSelect, SQLFrom, SQLWhere,
        SQLOrderBy, UserID, IsPublic /*, _USERID_ */, IsRdl)
    VALUES (
        @ReportID, @ReportName, @SQLSelect, @SQLFrom, @SQLWhere,
        @SQLOrderBy, @UserID, @IsPublic /*, p_USERID_ */, @IsRdl )
END
ELSE
BEGIN
    UPDATE VS_Reports SET
        ReportName = @ReportName, SQLSelect = @SQLSelect, SQLFrom = @SQLFrom, SQLWhere = @SQLWhere, SQLOrderBy = @SQLOrderBy,
        UserID = @UserID, IsPublic = @IsPublic /* , _USERID_ = @_USERID_ */ , IsRdl = @IsRdl
        WHERE ReportID = @ReportID
END
GO