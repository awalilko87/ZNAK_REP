SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYDocListFilters_RemoveByDocTypeID](
    @DocTypeID nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYDocListFilters
            WHERE DocTypeID = @DocTypeID
GO