SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserMenu_Update](
    @UserID nvarchar(30) OUT,
    @MenuKey nvarchar(50) OUT,
    @ModuleCode nvarchar(50),
    @DisableInsert bit,
    @DisableEdit bit,
    @DisableDelete bit,
    @_USERID_ nvarchar(30) = null
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

IF NOT EXISTS (SELECT * FROM SYUserMenu WHERE MenuKey = @MenuKey AND UserID = @UserID)
BEGIN
    INSERT INTO SYUserMenu(
        UserID, MenuKey, ModuleCode, DisableInsert, DisableEdit,
        DisableDelete)
    VALUES (
        @UserID, @MenuKey, @ModuleCode, @DisableInsert, @DisableEdit,
        @DisableDelete)
END
ELSE
BEGIN
    UPDATE SYUserMenu SET
        ModuleCode = @ModuleCode, DisableInsert = @DisableInsert, DisableEdit = @DisableEdit, DisableDelete = @DisableDelete
        WHERE MenuKey = @MenuKey AND UserID = @UserID
END
GO