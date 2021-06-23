SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYSettings_Update](
    @KeyCode nvarchar(50) OUT,
    @ModuleCode nvarchar(20) OUT,
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

IF @KeyCode is null
    SET @KeyCode = NewID()
IF @KeyCode =''
    SET @KeyCode = NewID()
IF @ModuleCode is null
    SET @ModuleCode = NewID()
IF @ModuleCode =''
    SET @ModuleCode = NewID()

IF NOT EXISTS (SELECT * FROM SYSettings WHERE KeyCode = @KeyCode AND ModuleCode = @ModuleCode)
BEGIN
    INSERT INTO SYSettings(
        KeyCode, ModuleCode, SettingValue, Description, Length,
        Type, DataSource, OrderBy, Visible /*, _USERID_ */ )
    VALUES (
        @KeyCode, @ModuleCode, @SettingValue, @Description, @Length,
        @Type, @DataSource, @OrderBy, @Visible /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE SYSettings SET
        SettingValue = @SettingValue, Description = @Description, Length = @Length, Type = @Type, DataSource = @DataSource,
        OrderBy = @OrderBy, Visible = @Visible /* , _USERID_ = @_USERID_ */ 
        WHERE KeyCode = @KeyCode AND ModuleCode = @ModuleCode
END
GO