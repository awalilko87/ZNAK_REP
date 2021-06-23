SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create view [dbo].[MOB_MUserRightsv] as
select 
	MUR.rowguid,
	MUR.userguid,
	MUR.refguid,
	MUR.[type],
	MUR.rightscode,
	MUR.orgguid,
	MU.UserID,
	MU.UserName,
	MU.[Password],
	MU.Module,
	MU.UserGroupID,
	MU.[LangID],
	MU.[Admin],
	MU.Noactive
from MUserRights MUR
	join MobileUsers MU on MU.rowguid = MUR.userguid

 
GO