SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYModules_GetByID](
    @ModuleCode nvarchar(20) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ModuleCode, ModuleDesc, VerticalCaption, INIFileName, Orders /*, _USERID_ */ 
    FROM SYModules
         WHERE ModuleCode LIKE @ModuleCode
GO