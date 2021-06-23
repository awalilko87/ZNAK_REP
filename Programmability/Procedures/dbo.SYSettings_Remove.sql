SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYSettings_Remove](
    @KeyCode nvarchar(50),
    @ModuleCode nvarchar(20),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    DELETE
        FROM SYSettings
            WHERE KeyCode = @KeyCode AND ModuleCode = @ModuleCode
GO