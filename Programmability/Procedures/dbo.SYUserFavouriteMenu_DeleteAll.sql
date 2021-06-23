SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserFavouriteMenu_DeleteAll](
     @UserID nvarchar(30)
)
WITH ENCRYPTION
AS

    DELETE
    FROM SYUserFavouriteMenu
    WHERE UserID = @UserID
GO