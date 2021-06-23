SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserMenu_UpdateOpenMenuElement](
    @UserID nvarchar(30) OUT,
    @MenuKey nvarchar(50) OUT,
    @ModuleCode nvarchar(50),
    @DisableInsert bit,
    @DisableEdit bit,
    @DisableDelete bit,
    @Open bit
)
WITH ENCRYPTION
AS

IF @MenuKey is null
    SET @MenuKey = NewID()
IF @MenuKey =''
    SET @MenuKey = NewID()
IF @UserID is null
    SET @UserID = NewID()
IF @UserID =''
    SET @UserID = NewID()

UPDATE SYUserMenu SET [Open] = 0 WHERE UserID = @UserID 

IF NOT EXISTS (SELECT * FROM SYUserMenu WHERE MenuKey = @MenuKey AND UserID = @UserID)
BEGIN
    INSERT INTO SYUserMenu(
        UserID, MenuKey, ModuleCode, DisableInsert, DisableEdit,
        DisableDelete, [Open])
    VALUES (
        @UserID, @MenuKey, @ModuleCode, @DisableInsert, @DisableEdit,
        @DisableDelete, @Open)
END
ELSE
BEGIN
		UPDATE SYUserMenu 
		SET ModuleCode = @ModuleCode, DisableInsert = @DisableInsert, DisableEdit = @DisableEdit, DisableDelete = @DisableDelete, [Open] = @Open /* , _USERID_ = @_USERID_ */ 
        WHERE MenuKey = @MenuKey AND UserID = @UserID
END
GO