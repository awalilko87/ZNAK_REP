SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserMenu_Remove](
    @MenuKey nvarchar(50),
    @UserID nvarchar(30),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYUserMenu
            WHERE MenuKey = @MenuKey AND UserID = @UserID
GO