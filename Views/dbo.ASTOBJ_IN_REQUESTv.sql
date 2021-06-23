SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ASTOBJ_IN_REQUESTv]    
as    
select    
 --std    
   o.OBJ_ROWID    
 , o.OBJ_PARENTID    
 , OBJ_LP = (row_number() over(partition by '' order by p.OBJ_CODE, o.OBJ_CODE))    
 , OBJ_PARENT = p.OBJ_CODE    
 , OBJ_PARENT_DESC = p.OBJ_DESC    
 , OBJ_STNID = OSA_STNID    
 , OBJ_STATION = s.STN_CODE    
 , OBJ_STATION_DESC = s.STN_DESC    
 , o.OBJ_PSPID    
 , OBJ_PSP = PSP_CODE    
 , OBJ_PSPDESC = PSP_CODE    
 , OBJ_ITSID = INVTSK.ITS_ROWID    
 , OBJ_ITS = ITS_CODE    
 , OBJ_ITSDESC = ITS_DESC    
 , OBJ_STSID = STS_ROWID    
 , OBJ_STS = STS_CODE    
 , OBJ_STSDESC = STS_DESC    
 , o.OBJ_OTID    
 , OOT.OT_ROWID    
 , OBJ_OT = OOT.OT_CODE    
 , o.OBJ_INOID    
 , o.OBJ_SIGNED    
 , o.OBJ_SIGNLOC    
 , o.OBJ_VALUE     
 , o.OBJ_CODE    
 , o.OBJ_ORG    
 , o.OBJ_DESC    
 , o.OBJ_NOTE    
 , o.OBJ_DATE    
 , OBJ_TIME = (dbo.e2_im_gettimefromdatetime(isnull(o.OBJ_DATE,'1900-01-01')))    
 , o.OBJ_STATUS    
 , OBJ_STATUS_DESC = (select STA_DESC from STA (nolock) where STA_CODE = o.OBJ_STATUS and STA_ENTITY = 'OBJ')    
 , OBJ_ICONSTATUS =  dbo.[GetStatusImage] ('OBJ', o.OBJ_STATUS)    
 , o.OBJ_LEFT    
 , o.OBJ_PM_TOSEND    
 , o.OBJ_PM    
 , o.OBJ_TYPE     
 , OBJ_TYPE_DESC = (select TYP_DESC from TYP (nolock) where TYP_CODE = o.OBJ_TYPE and TYP_ENTITY = 'OBJ')    
 , o.OBJ_TYPE2    
 , OBJ_TYPE2_DESC = (select TYP2.TYP2_DESC from TYP2 (nolock) join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = o.OBJ_TYPE and TYP_ENTITY = 'OBJ')    
 , o.OBJ_TYPE3    
 , OBJ_TYPE3_DESC = (select TYP3.TYP3_DESC from TYP3 (nolock) join TYP2 (nolock) on TYP2.TYP2_ROWID = TYP3.TYP3_TYP2ID join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = o.OBJ_TYPE and TYP_ENTITY = 'OBJ')    
 , o.OBJ_RSTATUS    
 , o.OBJ_CREUSER    
 , OBJ_CREUSER_DESC = dbo.UserName(o.OBJ_CREUSER)    
 , o.OBJ_CREDATE    
 , o.OBJ_UPDUSER    
 , OBJ_UPDUSER_DESC = dbo.UserName(o.OBJ_UPDUSER)    
 , o.OBJ_UPDDATE    
 , o.OBJ_NOTUSED    
 , o.OBJ_ID    
 , o.OBJ_GROUPID     
 , OBJ_GROUP = OBG_CODE    
 , OBJ_GROUP_DESC = OBG_DESC    
 , o.OBJ_MANUFACID    
 , OBJ_MANUFAC = (select MFC_CODE from dbo.MANUFAC (nolock) where MFC_ROWID = o.OBJ_MANUFACID)     
 , o.OBJ_VENDORID     
 , OBJ_ASSETID = OBA_ASTID    
 , OBJ_ASSET = AST_CODE     
 , OBJ_ASSET_SUBCODE = AST_SUBCODE     
 , OBJ_ASSET_DESC = AST_DESC     
 , o.OBJ_PERSON    
 , OBJ_PERSON_DESC = dbo.EmpDesc(o.OBJ_PERSON,o.OBJ_ORG)      
 , o.OBJ_PARTSLISTID    
 , OBJ_PARTSLIST = (select OPL_CODE from dbo.OBJPARTSLIST (nolock) where OPL_ROWID = o.OBJ_PARTSLISTID)    
 , o.OBJ_LOCID    
 , OBJ_LOC  = (select LOC_CODE from dbo.LOCATION (nolock) where LOCATION.LOC_ROWID = o.OBJ_LOCID)    
 , o.OBJ_CATALOGNO    
 , o.OBJ_YEAR     
 , o.OBJ_SERIAL    
       
 , o.OBJ_ACCOUNTID    
 , OBJ_ACCOUNT = null     
 , o.OBJ_COSTCENTERID     
 , OBJ_CCDID = CCD_ROWID    
 , OBJ_CCD = CCD_CODE    
 , OBJ_KL5ID = KL5_ROWID    
 , OBJ_KL5 = KL5_CODE    
 , o.OBJ_MRCID    
 , OBJ_MRC = (select MRC_CODE from dbo.MRC (nolock) where MRC_ROWID = o.OBJ_MRCID)    
    
 --udf    
 , o.OBJ_TXT01     
 , o.OBJ_TXT02    
 , o.OBJ_TXT03    
 , o.OBJ_TXT04    
 , o.OBJ_TXT05    
 , o.OBJ_TXT06    
 , o.OBJ_TXT07    
 , o.OBJ_TXT08    
 , o.OBJ_TXT09    
 , o.OBJ_NTX01    
 , o.OBJ_NTX02     
 , o.OBJ_NTX03    
 , o.OBJ_NTX04    
 , o.OBJ_NTX05    
 , o.OBJ_COM01    
 , o.OBJ_COM02    
 , o.OBJ_DTX01    
 , o.OBJ_DTX02    
 , o.OBJ_DTX03    
 , o.OBJ_DTX04    
 , o.OBJ_DTX05    
     
 , AST_CODE    
 , AST_SUBCODE    
 , SRQ_CODE    
 , SRQ_TYPE    
 , SRQ_TYPE_DESC = (select TYP_DESC from TYP (nolock) where TYP_CODE = SRQ_TYPE and TYP_ENTITY = 'SRQ')    
 , SRQ_REPLACEMENT    
 , SRQ_STNID_FROM    
 , SRQ_KL5ID_TO    
 , SRQ_STNID_TO    
 , SRQ_ROWID    
 , SRQ_STATUS    
 , SRQ_STATUS_DESC = (select STA_DESC from STA (nolock) where STA_CODE = SRQ_STATUS and STA_ENTITY = 'SRQ')    
 , SRQ_NOTE    
 , SRQ_ID    
 , SRQ_REASON    
 , SRQ_NR_ZAW_PM 
 , SRQ_CREDATE
 , SRQ_CREUSER
 , SRQ_CREUSER_DESC = (select UserName from SyUsers where UserID = SRQ_CREUSER) 
 , SRQ_UPDDATE
 , SRQ_UPDUSER 
 , SRQ_UPDUSER_DESC = (select UserName from SyUsers where UserID = SRQ_UPDUSER)     
 , s_to.STN_CODE as STN_CODE_TO    
 , s_to.STN_DESC as STN_DESC_TO    
 , STS_ROTARY    
    
from SP_REQUEST     
left join dbo.OBJ (nolock) o on SRQ_OBJID = o.OBJ_ROWID    
 join dbo.OBJGROUP (nolock) on OBG_ROWID = o.OBJ_GROUPID    
 left join dbo.OBJ (nolock) p on p.OBJ_ROWID = o.OBJ_PARENTID    
 left join dbo.OBJSTATION (nolock) os on os.OSA_OBJID = o.OBJ_ROWID    
 left join dbo.STATION s (nolock) on s.STN_ROWID = OSA_STNID    
 left join dbo.COSTCODE (nolock) on CCD_ROWID = STN_CCDID    
 left join dbo.KLASYFIKATOR5(nolock) on KL5_ROWID = OSA_KL5ID    
 left join dbo.OBJASSET (nolock) on OBA_OBJID = o.OBJ_ROWID    
 left join dbo.ASSET (nolock) on AST_ROWID = OBA_ASTID    
 left join dbo.PSP (nolock) on PSP_ROWID = p.OBJ_PSPID    
 left join dbo.INVTSK (nolock) on ITS_ROWID = PSP_ITSID     
 left join dbo.STENCIL (nolock) on O.OBJ_STSID = STS_ROWID    
 left join dbo.ZWFOT (nolock) OOT on OOT.OT_ROWID = o.OBJ_OTID    
     
 left join dbo.STATION s_to (nolock) on s_to.STN_ROWID = SRQ_STNID_TO    
    
where     
 isnull(o.OBJ_NOTUSED,0) <> 1 
GO