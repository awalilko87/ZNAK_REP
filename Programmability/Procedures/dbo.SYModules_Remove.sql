SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYModules_Remove](
    @ModuleCode nvarchar(20),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYModules
            WHERE ModuleCode = @ModuleCode
GO