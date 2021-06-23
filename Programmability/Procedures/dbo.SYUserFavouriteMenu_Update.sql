SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserFavouriteMenu_Update](
    @UserID nvarchar(30),
    @MenuKey nvarchar(50),
    @MenuCaption nvarchar(4000),
    @HTTPLink nvarchar(1000)
)
WITH ENCRYPTION
AS

IF NOT EXISTS (SELECT * FROM SYUserFavouriteMenu WHERE MenuKey = @MenuKey AND UserID = @UserID)
BEGIN
    INSERT INTO SYUserFavouriteMenu(UserID, MenuKey, MenuCaption, HTTPLink)
    VALUES (@UserID, @MenuKey, @MenuCaption, @HTTPLink)
END
ELSE
BEGIN
    UPDATE SYUserFavouriteMenu 
    SET MenuCaption = @MenuCaption, HTTPLink = @HTTPLink
    WHERE MenuKey = @MenuKey AND UserID = @UserID
END
GO