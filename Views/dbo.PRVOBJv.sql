SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[PRVOBJv]
as
select 
	[ROWID]
	,[PVO_OBJID]
	,[PVO_OBJ] = [OBJ_CODE]
	,[PVO_OBJ_DESC] = [OBJ_DESC]
	,[PVO_USERID]  
	,[PVO_USER] = UserName
	,[PVO_GROUPID] 
	,[PVO_GROUP] = GroupName
	,[PVO_OBGID]
	,[PVO_OBG] = [OBG_CODE]
	,[PVO_OBG_DESC] = [OBG_DESC]
	,[PVO_ID]
from [dbo].[PRVOBJ] (nolock) 
	left join [dbo].[OBJ] (nolock) on [OBJ_ROWID] = [PVO_OBJID]
	left join [dbo].[OBJGROUP] (nolock) on [OBG_ROWID] = [PVO_OBGID]
	left join [dbo].[SyUsers] (nolock) on [PVO_USERID] = [UserID]
	left join [dbo].[SyGroups] (nolock) on [PVO_GROUPID] = [GroupID]
GO