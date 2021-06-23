SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQL_Search](
    @DocType nvarchar(50),
    @DocSQL nvarchar(max),
    @DocSQLWhere nvarchar(200),
    @DocSQLOrderBy nvarchar(100),
    @Comment nvarchar(100),
    @DocSQLGroupBy nvarchar(100),
    @DocSQLIDValue nvarchar(200),
    @NotAutoLoad bit,
    @AutoReload bit,
    @Buttons nvarchar(50),
    @Caption nvarchar(100),
    @GroupOn bit,
    @PageSize int,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        DocType, DocSQL, DocSQLWhere, DocSQLOrderBy, Comment,
        DocSQLGroupBy, DocSQLIDValue, NotAutoLoad, AutoReload, Buttons,
        Caption, GroupOn, PageSize /*, _USERID_ */ 
    FROM SYDocListSQL
            /* WHERE DocSQL = @DocSQL AND DocSQLWhere = @DocSQLWhere AND DocSQLOrderBy = @DocSQLOrderBy AND Comment = @Comment AND DocSQLGroupBy = @DocSQLGroupBy AND
            DocSQLIDValue = @DocSQLIDValue AND NotAutoLoad = @NotAutoLoad AND AutoReload = @AutoReload AND Buttons = @Buttons AND Caption = @Caption AND
            GroupOn = @GroupOn AND PageSize = @PageSize /*  AND _USERID_ = @_USERID_ */ */
GO