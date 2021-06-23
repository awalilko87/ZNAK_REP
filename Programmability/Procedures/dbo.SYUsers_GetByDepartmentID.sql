SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SYUsers_GetByDepartmentID]
(
	@DepartmentID NVarChar(50)
	)
WITH ENCRYPTION
AS

    SELECT
        UserID, UserName, Password, PIN, UserSignature,
        Admin, DefWorkerID, Module, DepartmentID, ASOID,
        Email, ScheduleFlags, NoActive, UserGroupID, SiteID,
        MessageRights, MessagePhone, MessageEmail, LangID, DefUrl,
		PasswordLastChange, AccountExpirationDate, FileID,
		DateLocked, Violations, LastSuccessfulLogin, LastFailedLogin, ADLogin, ManageDataSpy,LoginWith2fa
    FROM SYUsers
	WHERE DepartmentID = @DepartmentID

GO