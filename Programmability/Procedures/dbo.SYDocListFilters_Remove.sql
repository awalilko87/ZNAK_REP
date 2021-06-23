SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListFilters_Remove](
    @FilterID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYDocListFilters
            WHERE FilterID = @FilterID
GO