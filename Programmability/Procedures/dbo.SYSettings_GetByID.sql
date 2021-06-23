SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYSettings_GetByID](
    @KeyCode nvarchar(50) = '%',
    @ModuleCode nvarchar(20) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        KeyCode, ModuleCode, SettingValue, Description, Length,
        Type, DataSource, OrderBy, Visible /*, _USERID_ */ 
    FROM SYSettings
         WHERE KeyCode LIKE @KeyCode AND ModuleCode LIKE @ModuleCode
GO