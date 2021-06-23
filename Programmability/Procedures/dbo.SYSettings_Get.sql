SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYSettings_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        KeyCode, ModuleCode, SettingValue, Description, Length,
        Type, DataSource, OrderBy, Visible /*, _USERID_ */ 
    FROM SYSettings
GO