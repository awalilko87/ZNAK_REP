SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListFilters_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        FilterID, DocTypeID, LabelText, LabelWidth, FilterType,
        FilterWidth, DefaultValue, FilterOrder, Visible, Roles,
        DataSource /*, _USERID_ */ 
    FROM SYDocListFilters
GO