SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQL_Update](
    @DocType nvarchar(50) OUT,
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

IF @DocType is null
    SET @DocType = NewID()
IF @DocType =''
    SET @DocType = NewID()

IF NOT EXISTS (SELECT * FROM SYDocListSQL WHERE DocType = @DocType)
BEGIN
    INSERT INTO SYDocListSQL(
        DocType, DocSQL, DocSQLWhere, DocSQLOrderBy, Comment,
        DocSQLGroupBy, DocSQLIDValue, NotAutoLoad, AutoReload, Buttons,
        Caption, GroupOn, PageSize /*, _USERID_ */ )
    VALUES (
        @DocType, @DocSQL, @DocSQLWhere, @DocSQLOrderBy, @Comment,
        @DocSQLGroupBy, @DocSQLIDValue, @NotAutoLoad, @AutoReload, @Buttons,
        @Caption, @GroupOn, @PageSize /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE SYDocListSQL SET
        DocSQL = @DocSQL, DocSQLWhere = @DocSQLWhere, DocSQLOrderBy = @DocSQLOrderBy, Comment = @Comment, DocSQLGroupBy = @DocSQLGroupBy,
        DocSQLIDValue = @DocSQLIDValue, NotAutoLoad = @NotAutoLoad, AutoReload = @AutoReload, Buttons = @Buttons, Caption = @Caption,
        GroupOn = @GroupOn, PageSize = @PageSize /* , _USERID_ = @_USERID_ */ 
        WHERE DocType = @DocType
END
GO