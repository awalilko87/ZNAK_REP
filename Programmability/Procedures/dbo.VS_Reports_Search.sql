SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Reports_Search](
    @ReportID nvarchar(50),
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

    SELECT
        ReportID, ReportName, SQLSelect, SQLFrom, SQLWhere,
        SQLOrderBy, UserID, IsPublic /*, _USERID_ */, IsRdl
    FROM VS_Reports
            /* WHERE ReportName = @ReportName AND SQLSelect = @SQLSelect AND SQLFrom = @SQLFrom AND SQLWhere = @SQLWhere AND SQLOrderBy = @SQLOrderBy AND
            UserID = @UserID AND IsPublic = @IsPublic /*  AND _USERID_ = @_USERID_ */ */
GO