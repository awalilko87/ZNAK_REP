SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserMenu_Search](
    @UserID nvarchar(30),
    @MenuKey nvarchar(50),
    @ModuleCode nvarchar(50),
    @DisableInsert bit,
    @DisableEdit bit,
    @DisableDelete bit,
    @Open bit,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        UserID, MenuKey, ModuleCode, DisableInsert, DisableEdit,
        DisableDelete, [Open] 
    FROM SYUserMenu
GO