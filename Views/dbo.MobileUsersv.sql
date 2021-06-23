SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[MobileUsersv]
as
select
	UserID
	,UserName
	,[Password]
	,Module
	,UserGroupID
	,[LangID]
	,[Admin]
	,NoActive
	,orgguid = convert(nvarchar(50),orgguid)
	,rowguid = convert(nvarchar(50),rowguid)
	-- Do wydruku etykiet
	,CODE = null
	,[FileName] = null
from MobileUsers


GO