SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListSQL_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        DocType, DocSQL, DocSQLWhere, DocSQLOrderBy, Comment,
        DocSQLGroupBy, DocSQLIDValue, NotAutoLoad, AutoReload, Buttons,
        Caption, GroupOn, PageSize /*, _USERID_ */ 
    FROM SYDocListSQL
GO