SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SYUsers_GetByMessageRights]
(
	@MessageRightID int
	)
WITH ENCRYPTION
AS

SELECT  DISTINCT   
        '' AS UserID, '' AS UserName, '' AS Password, '' AS PIN, '' AS UserSignature,
        CAST(0 AS bit) AS Admin, '' AS DefWorkerID, '' AS Module, '' AS DepartmentID, '' AS ASOID,
        '' AS Email, 0 AS ScheduleFlags, NoActive, '' AS UserGroupID, '' AS SiteID,
        MessageRights, MessageEmail, MessagePhone, LangID, DefUrl,
		PasswordLastChange, AccountExpirationDate, FileID,
		DateLocked, Violations, LastSuccessfulLogin, LastFailedLogin, ADLogin, ManageDataSpy,LoginWith2fa
FROM SYUsers
WHERE (MessageRights & @MessageRightID = @MessageRightID) AND NoActive = 0
GO