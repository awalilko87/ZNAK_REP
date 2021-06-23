SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[M_STENCILv]
as
select
  STS_ROWID  
, STS_SETTYPE 
, STS_SETTYPEDESC = STT_DESC 
, STS_SIGNED
, STS_SIGNLOC
, STS_CODE
, STS_ORG
, STS_DESC
, STS_TYPE 
, STS_TYPE_DESC = (select TYP_DESC from TYP (nolock) where TYP_CODE = STS_TYPE and TYP_ENTITY = 'OBJ')
, STS_NOTUSED
, cast (STS_ID as uniqueidentifier) as STS_ID
, STS_GROUPID 
, STS_GROUP = OBG_CODE
, STS_GROUP_DESC = OBG_DESC
from dbo.[STENCIL] (nolock) o  
	join SETTYPE (nolock) on STT_CODE = STS_SETTYPE
	left join OBJGROUP (nolock) on OBG_ROWID = STS_GROUPID
	left join PSPEDIT (nolock) on PSE_ROWID = STS_PSEID
where isnull(STS_CODE,'') <> '-' and isnull(STS_NOTUSED,0) <> 1

GO