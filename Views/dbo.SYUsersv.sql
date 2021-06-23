SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE view [dbo].[SYUsersv]
as
SELECT          
SYUsers.UserID, 
SYUsers.UserName, 
SYUsers.UserSignature, 
SYUsers.Admin, 
VS_Departments.DepartmentName as DepartmentID, 
DepartmentName = VS_Departments.DepartmentName,
SYUsers.UserGroupID, 
[LangID] = VS_Langs.LangID, 
LangName = VS_Langs.LangName, 
SYUsers.DefUrl,  
(SYUsers.DefWorkerID) as DefWorker,
SYUsers.NoActive, 
SYUsers.Email, 
SYUsers.MessagePhone, 
SYUsers.InternalPhoneNumber,
SYUsers.PasswordLastChange,
SYUsers.SiteID,
SYUsers.MobileUser,
SYUsers.MobileAuthUser,
SYUsers.ADLogin,
SYUsers.Module
FROM SYUsers 
	LEFT OUTER JOIN VS_Langs ON SYUsers.LangID = VS_Langs.LangID
	LEFT OUTER JOIN VS_Departments ON SYUsers.DepartmentID = VS_Departments.DepartmentID

GO