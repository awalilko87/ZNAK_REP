SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SYSettings_ChangePassCoding] (
	@PType nvarchar(50),
	@sTxtin nvarchar(50),
	@UserID nvarchar(30)
)

WITH ENCRYPTION

AS

IF @PType = 'bez'
	BEGIN
		UPDATE SYSettings SET SettingValue = '' WHERE KeyCode = 'PTYPE' AND ModuleCode = 'VISION'
		UPDATE SYUsers SET Password = @sTxtin WHERE UserID = @UserID
	END
IF @PType = 'P1'
	BEGIN
		UPDATE SYSettings SET SettingValue = 'P1' WHERE KeyCode = 'PTYPE' AND ModuleCode = 'VISION'
		UPDATE SYUsers SET Password = (SELECT dbo.P1(@sTxtin)) WHERE UserID = @UserID
	END
IF @PType = 'D7i'
	BEGIN
		UPDATE SYSettings SET SettingValue = 'D7i' WHERE KeyCode = 'PTYPE' AND ModuleCode = 'VISION'
		UPDATE SYUsers SET Password  = (SELECT dbo.Pass_D7i(@sTxtin)) WHERE UserID = @UserID
	END
IF @PType = 'MP2'
	BEGIN
		UPDATE SYSettings SET SettingValue = 'MP2' WHERE KeyCode = 'PTYPE' AND ModuleCode = 'VISION'
		UPDATE SYUsers SET Password  = (SELECT dbo.Pass_MP2(@sTxtin)) WHERE UserID = @UserID
	END



GO