SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYMenus_Remove](
    @MenuKey nvarchar(50),
    @ModuleName nvarchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYMenus
            WHERE MenuKey = @MenuKey OR MenuKey LIKE @MenuKey + '[_]%' AND ModuleName = @ModuleName
GO