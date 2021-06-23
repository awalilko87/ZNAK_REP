SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserMenu_GetByID](
    @MenuKey nvarchar(50) = '%',
    @UserID nvarchar(30) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        UserID, MenuKey, ModuleCode, DisableInsert, DisableEdit,
        DisableDelete, [Open] 
    FROM SYUserMenu
         WHERE MenuKey LIKE @MenuKey AND UserID LIKE @UserID
GO