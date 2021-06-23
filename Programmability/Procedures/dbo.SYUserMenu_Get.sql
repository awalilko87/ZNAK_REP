SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserMenu_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        UserID, MenuKey, ModuleCode, DisableInsert, DisableEdit,
        DisableDelete, [Open] 
    FROM SYUserMenu
GO