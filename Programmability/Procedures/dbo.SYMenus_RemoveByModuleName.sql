SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYMenus_RemoveByModuleName](
    @ModuleName nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYMenus
            WHERE ModuleName = @ModuleName
GO