SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYSettings_Search](
    @KeyCode nvarchar(50),
    @ModuleCode nvarchar(20),
    @SettingValue nvarchar(max),
    @Description nvarchar(500),
    @Length int,
    @Type nvarchar(50),
    @DataSource nvarchar(max),
    @OrderBy int,
    @Visible bit,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT KeyCode, ModuleCode, SettingValue, Description, Length, Type, DataSource, OrderBy, Visible /*, _USERID_ */ 
    FROM SYSettings

GO