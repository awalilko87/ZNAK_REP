SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[INVTSK_NEW_OBJv_Backup]            
as            
select             
  INO_ROWID            
 , INO_STSID            
 , INO_STS = STS_CODE            
 , INO_STS_DESC = STS_DESC            
 , INO_SETTYPE = STS_SETTYPE            
 , INO_PSPID            
 , INO_PSP = PSP_CODE            
 , INO_PSP_DESC = PSP_CODE + ' - ' + PSP_DESC            
 , INO_OBJID = OBJ_ROWID            
 , INO_OBJ = OBJ_CODE            
 , INO_OBJ_DESC = OBJ_DESC            
 , INO_ITSID            
 , INO_ITS = ITS_CODE            
 , INO_ITS_DESC = ITS_DESC            
 , INO_CODE            
 , INO_ORG            
 , INO_DESC            
 , INO_DATE            
 , INO_STATUS            
 , INO_STATUS_DESC = (select STA_DESC from STA (nolock) where STA_CODE = OBJ_STATUS and STA_ENTITY = 'INO')            
 , INO_TYPE            
 , INO_TYPE_DESC = (select TYP_DESC from TYP (nolock) where TYP_CODE = INO_TYPE and TYP_ENTITY = 'INO')            
 , INO_TYPE2            
 , INO_TYPE2_DESC = (select TYP2.TYP2_DESC from TYP2 (nolock) join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = INO_TYPE and TYP_ENTITY = 'INO')            
 , INO_TYPE3            
 , INO_TYPE3_DESC = (select TYP3.TYP3_DESC from TYP3 (nolock) join TYP2 (nolock) on TYP2.TYP2_ROWID = TYP3.TYP3_TYP2ID join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = INO_TYPE and TYP_ENTITY = 'INO')            
 , INO_RSTATUS            
 , INO_CREUSER            
 , INO_CREUSER_DESC = dbo.UserName(INO_CREUSER)            
 , INO_CREDATE            
 , INO_NOTUSED            
 , INO_ID            
 , INO_TXT12         
             
 , OBJ_ROWID            
 , OBJ_STNID = OSA_STNID            
 , OBJ_STATION = STN_CODE            
 , OBJ_STATION_DESC = STN_DESC            
 , OBJ_PSPID            
 , OBJ_PSP = PSP_CODE            
 , OBJ_PSPDESC = PSP_CODE            
 , OBJ_STSID            
 , OBJ_ITSID = INVTSK.ITS_ROWID            
 , OBJ_ITS = ITS_CODE            
 , OBJ_ITSDESC = ITS_CODE            
 , OBJ_OTID            
 , OBJ_SIGNED            
 , OBJ_SIGNLOC            
 , OBJ_VALUE             
 , OBJ_CODE            
 , OBJ_ORG            
 , OBJ_DESC            
 , OBJ_NOTE            
 , OBJ_DATE            
 , OBJ_TIME = (dbo.e2_im_gettimefromdatetime(isnull(OBJ_DATE,'1900-01-01')))            
 , OBJ_STATUS            
 , OBJ_STATUS_DESC = (select STA_DESC from STA (nolock) where STA_CODE = OBJ_STATUS and STA_ENTITY = 'OBJ')            
 , OBJ_ICONSTATUS =  dbo.[GetStatusImage] ('OBJ', OBJ_STATUS)            
              
 , OBJ_TYPE             
 , OBJ_TYPE_DESC = (select TYP_DESC from TYP (nolock) where TYP_CODE = OBJ_TYPE and TYP_ENTITY = 'OBJ')            
 , OBJ_TYPE2            
 , OBJ_TYPE2_DESC = (select TYP2.TYP2_DESC from TYP2 (nolock) join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = OBJ_TYPE and TYP_ENTITY = 'OBJ')            
 , OBJ_TYPE3            
 , OBJ_TYPE3_DESC = (select TYP3.TYP3_DESC from TYP3 (nolock) join TYP2 (nolock) on TYP2.TYP2_ROWID = TYP3.TYP3_TYP2ID join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = OBJ_TYPE and TYP_ENTITY = 'OBJ')            
 , OBJ_RSTATUS            
 , OBJ_CREUSER            
 , OBJ_CREUSER_DESC = dbo.UserName(OBJ_CREUSER)            
 , OBJ_CREDATE            
 , OBJ_UPDUSER            
 , OBJ_UPDUSER_DESC = dbo.UserName(OBJ_UPDUSER)            
 , OBJ_UPDDATE            
 , OBJ_NOTUSED            
 , OBJ_ID            
 , OBJ_GROUPID             
 , OBJ_GROUP = OBG_CODE            
 , OBJ_GROUP_DESC = OBG_DESC            
 , OBJ_MANUFACID            
 , OBJ_MANUFAC = (select MFC_CODE from dbo.MANUFAC (nolock) where MFC_ROWID = OBJ_MANUFACID)             
 , OBJ_VENDORID             
 , OBJ_ASSETID = AST_ROWID            
 , OBJ_ASSET = AST_CODE             
 , OBJ_ASSET_DESC = AST_DESC             
 , OBJ_PERSON            
 , OBJ_PERSON_DESC = dbo.EmpDesc(OBJ_PERSON,OBJ_ORG)              
 , OBJ_PARTSLISTID            
 , OBJ_PARTSLIST = (select OPL_CODE from dbo.OBJPARTSLIST (nolock) where OPL_ROWID = OBJ_PARTSLISTID)            
 , OBJ_LOCID            
 , OBJ_LOC  = (select LOC_CODE from dbo.LOCATION (nolock) where LOCATION.LOC_ROWID = OBJ_LOCID)            
 , OBJ_CATALOGNO           
 , OBJ_YEAR             
 , OBJ_SERIAL            
            
 , OBJ_ACCOUNTID            
 , OBJ_ACCOUNT = null             
 , OBJ_COSTCENTERID             
 , OBJ_MRCID            
 , OBJ_MRC = (select MRC_CODE from dbo.MRC (nolock) where MRC_ROWID = OBJ_MRCID)            
             
  --udf            
 , OBJ_TXT01             
 , OBJ_TXT02            
 , OBJ_TXT03            
 , OBJ_TXT04            
 , OBJ_TXT05            
 , OBJ_TXT06            
 , OBJ_TXT07            
 , OBJ_TXT08            
 , OBJ_TXT09 
 , OBJ_TXT10            
 , OBJ_NTX01            
 , OBJ_NTX02             
 , OBJ_NTX03            
 , OBJ_NTX04            
 , OBJ_NTX05            
 , OBJ_COM01            
 , OBJ_COM02            
 , OBJ_DTX01            
 , OBJ_DTX02            
 , OBJ_DTX03            
 , OBJ_DTX04            
 , OBJ_DTX05            
          
 --POWIĄZANE DOKUMENTY Z WORKFLOW select * from settype            
 , [OT_NEW_11] = case when (OT_ID is null or OT_TYPE = 'SAPO_ZWFOT11') and OSA_STNID is not null and STS_SETTYPE in ('ZES', 'EZES','SKL', 'EKOM')  then --element kompletu można rozliczyć OT 11 (http://jira.eurotronic.net.pl/browse/PKNTA-161)            
    '<a href="'+ dbo.VS_EncryptLink('/Tabs3.aspx/' +            
    '?WHO=INVTSK_NEW_OBJ_LS'+            
    '&FID=OT11_RC'+            
    '&FLD=Btn_AddOT11'+            
    '&A=Btn_AddOT11'+            
    '&OT11ID=' + isnull((select top 1 cast(OT11_ROWID as nvarchar(10)) from ZWFOT11v (nolock) where OT11_ZMT_ROWID = ZWFOTv.OT_ROWID),'') +            
    '&OBJ=' + OBJ_CODE +             
    '&OBJ_DESC=' + OBJ_DESC +             
    '&INOID=' + cast(isnull(ZWFOTv.OT_INOID, INO_ROWID) as nvarchar)+            
    '&ITS=' + ITS_CODE +             
    '&PSP=' + isnull(PSP_CODE,'')) +             
    '" target="_blank" title="Utwórz OT 11">'+            
    case when OT_ID is null then            
     '<img src="/Images/24x24/Symbol%20Add%202.png" border="none" type="image" width="24" height="24"/></a>'            
    else '<img src="/Images/24x24/Symbol%20Information.png" border="none" type="image" width="24" height="24"/></a>' end            
   else '' end                
 , [OT_NEW_12] = case when (OT_ID is null or OT_TYPE = 'SAPO_ZWFOT12') and OSA_STNID is not null and INO_TXT12 <> 'DON' and STS_SETTYPE in ('KOM','EKOM') then             
    '<a href="'+ dbo.VS_EncryptLink('/Tabs3.aspx/' +            
    '?WHO=INVTSK_NEW_OBJ_LS'+            
    '&FID=OT12_RC'+            
    '&FLD=Btn_AddOT12'+            
    '&A=Btn_AddOT12'+            
    '&OT12ID=' + isnull((select top 1 cast(OT12_ROWID as nvarchar(10)) from ZWFOT12v (nolock) where OT12_ZMT_ROWID = ZWFOTv.OT_ROWID),'') +            
    '&OBJ=' + OBJ_CODE +             
    '&OBJ_DESC=' + OBJ_DESC +             
    '&INOID=' + cast(isnull(ZWFOTv.OT_INOID, INO_ROWID) as nvarchar)+            
    '&ITS=' + ITS_CODE +             
    '&PSP=' + isnull(PSP_CODE,'')) +             
    '" target="_blank" title="Utwórz OT 12">'+            
    case when OT_ID is null then            
     '<img src="/Images/24x24/Symbol%20Add%202.png" border="none" type="image" width="24" height="24"/></a>'            
    else '<img src="/Images/24x24/Symbol%20Information.png" border="none" type="image" width="24" height="24"/></a>' end            
   else '' end            
 , [OT_NEW_21] = case when (OT_ID is null or OT_TYPE = 'SAPO_ZWFOT21') and OSA_STNID is not null and INO_TXT12 <> 'DON' and STS_SETTYPE in ('ZES', 'KOM', 'EZES','SKL', 'EKOM') and OBJ_TXT12 is null   then             
    '<a href="'+ dbo.VS_EncryptLink('/Tabs3.aspx/' +            
    '?WHO=INVTSK_NEW_OBJ_LS'+            
    '&FID=OT21_RC'+            
    '&FLD=Btn_AddOT21'+            
    '&A=Btn_AddOT21'+            
    '&OT21ID=' + isnull((select top 1 cast(OT21_ROWID as nvarchar(10)) from ZWFOT21v (nolock) where OT21_ZMT_ROWID = ZWFOTv.OT_ROWID),'') +            
    '&OBJ=' + OBJ_CODE +             
    '&OBJ_DESC=' + OBJ_DESC +             
    '&INOID=' + cast(isnull(ZWFOTv.OT_INOID, INO_ROWID) as nvarchar)+            
    '&ITS=' + ITS_CODE +             
    '&PSP=' + isnull(PSP_CODE,'')) +             
    '" target="_blank" title="Utwórz OT 21">'+            
    case when OT_ID is null then            
     '<img src="/Images/24x24/Symbol%20Add%202.png" border="none" type="image" width="24" height="24"/></a>'            
    else '<img src="/Images/24x24/Symbol%20Information.png" border="none" type="image" width="24" height="24"/></a>' end            
   else '' end            
 , [OT_OBJ_LINES] =              
    '<a href="'+ dbo.VS_EncryptLink('/Tabs3.aspx/' +        
    '?WHO=INVTSK_NEW_OBJ_LS'+            
    '&FID=INVTSK_ADD_OBJ_PROPERTIES'+            
    '&FLD=Btn_ObjLines'+            
    '&A=Btn_ObjLines'+            
    '&OBJ=' + OBJ_CODE +             
    '&OBJ_DESC=' + OBJ_DESC +             
    '&INOID=' + cast(isnull(ZWFOTv.OT_INOID, INO_ROWID) as nvarchar)+ --nie można użyć INO_ROWID            
    '&ITS=' + ITS_CODE +             
    '&STS=' + STS_CODE +            
    '&PSP=' + isnull(PSP_CODE,'')) +             
    '" target="_blank" title="Pokaż podskładniki">'+            
    '<img src="/Images/24x24/Format%20Numbering.png" border="none" type="image" width="24" height="24"/></a>'            
                   
   --~/Tabs3.aspx/?MID=ZMT_INVEST&TGR=INVTSK&TAB=INVTSK_NEW_OBJ_PROPERTIES&FID=INVTSK_NEW_OBJ_PROPERTIES             
               
 , [OT_ROWID]            
 , [OT_ID]            
 , [OT_CODE]            
 , [OT_STATUS]            
 , CASE WHEN OT_STATUS like 'OT11_70' THEN [OT_STATUS_DESC] ELSE '' END AS [OT_STATUS_DESC]
 , [OT_TYPE]            
 , [OT_TYPE_DESC]            
 , [OT_INOID]            
 , [OSA_STNID]         
 , [OBJ_CANCELLED_OT_DOC]
 , OBJ_CANCELLED_OT_DOC_PERSON

     
from [INVTSK_NEW_OBJ] (nolock)             
 join dbo.STENCIL (nolock) on STS_ROWID = INO_STSID            
 join dbo.INVTSK (nolock) on ITS_ROWID = INO_ITSID            
 left join dbo.OBJ (nolock) on INO_ROWID = OBJ_INOID            
 left join dbo.PSP (nolock) on PSP_ROWID = OBJ_PSPID            
 left join dbo.OBJASSET (nolock) on OBA_OBJID = OBJ_ROWID            
 left join dbo.ASSET (nolock) on AST_ROWID = OBA_ASTID            
 left join dbo.OBJSTATION (nolock) os on os.OSA_OBJID = OBJ_ROWID            
 left join dbo.STATION (nolock) on STN_ROWID = OSA_STNID            
 left join dbo.OBJGROUP (nolock) on OBG_ROWID = OBJ_GROUPID             
 left join dbo.ZWFOTv (nolock) on /*OT_PSPID = PSP_ROWID and OT_ITSID = ITS_ROWID and*/             
 (OBJ_OTID = OT_ROWID or OT_INOID = INO_ROWID)            
where             
 isnull(OBJ_NOTUSED,0) <> 1            
 and (isnull(OBJ_PARENTID,'') = isnull(OBJ_ROWID,'') --tylko główne            
 or INO_MULTI = 1)   
 and IsNull(AST_SUBCODE,'0000') = '0000'







GO