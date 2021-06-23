SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYModules_Search](
    @ModuleCode nvarchar(20),
    @ModuleDesc nvarchar(100),
    @VerticalCaption nvarchar(200),
    @INIFileName nvarchar(50),
    @Orders numeric(18,5),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ModuleCode, ModuleDesc, VerticalCaption, INIFileName, Orders /*, _USERID_ */ 
    FROM SYModules
            /* WHERE ModuleDesc = @ModuleDesc AND VerticalCaption = @VerticalCaption AND INIFileName = @INIFileName AND Orders = @Orders /*  AND _USERID_ = @_USERID_ */ */
GO