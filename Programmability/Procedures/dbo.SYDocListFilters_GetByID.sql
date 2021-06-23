SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListFilters_GetByID](
    @FilterID nvarchar(50) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        FilterID, DocTypeID, LabelText, LabelWidth, FilterType,
        FilterWidth, DefaultValue, FilterOrder, Visible, Roles,
        DataSource /*, _USERID_ */ 
    FROM SYDocListFilters
         WHERE FilterID LIKE @FilterID
GO