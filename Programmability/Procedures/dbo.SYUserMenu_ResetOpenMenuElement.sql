SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserMenu_ResetOpenMenuElement](
    @UserID nvarchar(30) OUT
)
WITH ENCRYPTION
AS

IF @UserID is null
    SET @UserID = NewID()
IF @UserID =''
    SET @UserID = NewID()

UPDATE SYUserMenu SET [Open] = 0 WHERE UserID = @UserID 

GO