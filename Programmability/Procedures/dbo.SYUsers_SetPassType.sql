SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUsers_SetPassType](
    @PType nvarchar(50) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF NOT EXISTS(SELECT * FROM SYSettings WHERE KeyCode = 'PTYPE' AND ModuleCode = 'VISION')
	INSERT Into SYSettings (KeyCode, ModuleCode, SettingValue) VALUES ('PTYPE', 'VISION', @PType)
ELSE
	UPDATE SYSettings SET SettingValue = @PType WHERE KeyCode = 'PTYPE' AND ModuleCode = 'VISION'
GO