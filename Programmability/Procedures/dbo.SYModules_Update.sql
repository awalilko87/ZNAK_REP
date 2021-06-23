SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYModules_Update](
    @ModuleCode nvarchar(20) OUT,
    @ModuleDesc nvarchar(100),
    @VerticalCaption nvarchar(200),
    @INIFileName nvarchar(50),
    @Orders numeric(18,5),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF @ModuleCode is null
    SET @ModuleCode = NewID()
IF @ModuleCode =''
    SET @ModuleCode = NewID()

IF NOT EXISTS (SELECT * FROM SYModules WHERE ModuleCode = @ModuleCode)
BEGIN
    INSERT INTO SYModules(
        ModuleCode, ModuleDesc, VerticalCaption, INIFileName, Orders /*, _USERID_ */ )
    VALUES (
        @ModuleCode, @ModuleDesc, @VerticalCaption, @INIFileName, @Orders /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE SYModules SET
        ModuleDesc = @ModuleDesc, VerticalCaption = @VerticalCaption, INIFileName = @INIFileName, Orders = @Orders /* , _USERID_ = @_USERID_ */ 
        WHERE ModuleCode = @ModuleCode
END
GO