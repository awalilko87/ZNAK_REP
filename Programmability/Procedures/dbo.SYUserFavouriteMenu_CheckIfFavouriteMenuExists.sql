SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserFavouriteMenu_CheckIfFavouriteMenuExists](
     @UserID nvarchar(30)
)
WITH ENCRYPTION
AS

    SELECT count(*)
    FROM SYUserFavouriteMenu
    WHERE UserID = @UserID
GO