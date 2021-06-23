SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[STENCILLNv]  
as  
select  
--std  
  STS_ROWID    
, STS_PSEID  
, STL_PARENTID   
, STL_CHILDID   
, STS_PSE = PSE_CODE  
, STS_PSEDESC = PSE_CODE  
, STS_SETTYPE   
, STS_SETTYPEDESC = STT_DESC   
, STS_SIGNED  
, STS_SIGNLOC  
, STS_VALUE   
, STS_CODE  
, STS_ORG  
, STS_DESC  
, STS_NOTE  
, STS_DATE  
, STS_TIME = (dbo.e2_im_gettimefromdatetime(isnull(STS_DATE,'1900-01-01')))  
, STS_STATUS  
, STS_STATUS_DESC = (select STA_DESC from STA (nolock) where STA_CODE = STS_STATUS and STA_ENTITY = 'STS')  
, STS_ICONSTATUS =  dbo.[GetStatusImage] ('STS', STS_STATUS)  
    
, STS_TYPE   
, STS_TYPE_DESC = (select TYP_DESC from TYP (nolock) where TYP_CODE = STS_TYPE and TYP_ENTITY = 'OBJ')  
, STS_TYPE2  
, STS_TYPE2_DESC = (select TYP2.TYP2_DESC from TYP2 (nolock) join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = STS_TYPE and TYP_ENTITY = 'OBJ')  
, STS_TYPE3  
, STS_TYPE3_DESC = (select TYP3.TYP3_DESC from TYP3 (nolock) join TYP2 (nolock) on TYP2.TYP2_ROWID = TYP3.TYP3_TYP2ID join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = STS_TYPE and TYP_ENTITY = 'OBJ')  
, STS_RSTATUS  
, STS_CREUSER  
, STS_CREUSER_DESC = dbo.UserName(STS_CREUSER)  
, STS_CREDATE  
, STS_UPDUSER  
, STS_UPDUSER_DESC = dbo.UserName(STS_UPDUSER)  
, STS_UPDDATE  
, STS_NOTUSED  
, STS_ID  
  
, STS_PERSON  
, STS_PERSON_DESC = dbo.EmpDesc(STS_PERSON,STS_ORG)    
, STS_GROUPID   
, STS_GROUP = OBG_CODE  
, STS_GROUP_DESC = OBG_DESC  
  
, STL_REQUIRED  
, STL_ONE  
, case   
	 when STL_ONE = 'TAK' then 1  
	 else isnull(STL_DEFAULT_NUMBER, 1)  
  end STL_DEFAULT_NUMBER  
, STL_ROWID
  
from dbo.[STENCILLN] (nolock)  
 join [STENCIL] (nolock) on STL_CHILDID = STS_ROWID  
 join [SETTYPE] (nolock) on STT_CODE = STS_SETTYPE  
 left join [OBJGROUP] (nolock) on OBG_ROWID = STS_GROUPID  
 left join [PSPEDIT] (nolock) on PSE_ROWID = STS_PSEID  
where isnull(STS_CODE,'') <> '-' and isnull(STS_NOTUSED,0) <> 1  
   
   
  
  
  
GO