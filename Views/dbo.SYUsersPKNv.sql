SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE view [dbo].[SYUsersPKNv]  
as  
select            
SYUsers.UserID,   
SYUsers.UserName,   
SYUsers.UserSignature,   
SYUsers.Admin,   
VS_Departments.DepartmentName as DepartmentID,   
DepartmentName = VS_Departments.DepartmentName,  
SYUsers.UserGroupID,   
[LangID] = SYUsers.LangID,   
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
SYUsers.Module,  
FirstName,  
LastName,  
SAPLogin,  
SAPRealizator,
POT_rozliczenie,
CPO_ROZLICZANIE   
from SYUsers   
left outer join VS_Langs ON SYUsers.LangID = VS_Langs.LangID  
left outer join VS_Departments ON SYUsers.DepartmentID = VS_Departments.DepartmentID  
where isnull(UserGroupID,'') <> 'SP'
GO