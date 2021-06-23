SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

 
CREATE view [dbo].[SP_ASTOBJv]
as
with OBJASSET_DISTINCT as (select min(OBA_OBJID) OBA_OBJID, OBA_ASTID from (select min(OBA_ASTID) OBA_ASTID, OBA_OBJID from OBJASSET group by OBA_OBJID)  X group by OBA_ASTID)
select
	--std
	  o.OBJ_ROWID
	, o.OBJ_PARENTID
	, OBJ_LP = (row_number() over(partition by '' order by p.OBJ_CODE, o.OBJ_CODE))
	, OBJ_PARENT = p.OBJ_CODE
	, OBJ_PARENT_DESC = case when o.OBJ_ROWID = o.OBJ_PARENTID then '' else p.OBJ_DESC + ' (' + p.OBJ_CODE +  ')' end
	, OBJ_STNID = OSA_STNID
	, OBJ_STATION = STN_CODE
	, OBJ_STATION_DESC = STN_DESC
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
	, o.OBJ_PM_NAME
	, o.OBJ_PM_SERVICE  
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
	, OBJ_VENDOR = (select VEN_CODE from dbo.VENDOR (nolock) where VEN_ROWID = o.OBJ_VENDORID)
	, OBJ_VENDOR_DESC = (select VEN_DESC from dbo.VENDOR (nolock) where VEN_ROWID = o.OBJ_VENDORID)
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

	, SP_OBJ_RC_LINK = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=SP_OBJ_LS&FID=SP_OBJ_RC&FLD=SP_OBJ_RC_LINK&A=BTN_REFRESH&OBJ_ID=' + cast(o.OBJ_ID as nvarchar(50))) + ''',''mywindowtitle'')" 
		title="Wyświetl szczegóły składnika"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="32" height="32"/></a>'
	
	, OBJ_PROPERTIES_LINK = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=STN_OBJ&FID=STN_OBJ_PROPERTYVALUES&FLD=HTB_OBJ_PROPERTIES&A=BTN_REFRESH&OBJID=' + cast(o.OBJ_ROWID as nvarchar(50))) + ''',''mywindowtitle'')" 
	title="Wyświetl parametry dla składnika"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="32" height="32"/></a>'
   
   --Pola niezbędne do o ołsugi przeniesień rejestrowanych przez PS
	, SRQ_STNID_TO = NULL
	, SRQ_KL5ID_TO = NULL
	, SRQ_TYPE = NULL
	, SRQ_REPLACEMENT = NULL
	
	, STS_CODE
	
	, AST_CODE
	, AST_SUBCODE

from dbo.OBJ (nolock) o  
	join dbo.OBJGROUP (nolock) on OBG_ROWID = o.OBJ_GROUPID
	left join dbo.OBJ (nolock) p on p.OBJ_ROWID = o.OBJ_PARENTID
	left join dbo.OBJSTATION (nolock) os on os.OSA_OBJID = o.OBJ_ROWID
	left join dbo.STATION s (nolock) on s.STN_ROWID = OSA_STNID
	left join dbo.COSTCODE (nolock) on CCD_ROWID = STN_CCDID
	left join dbo.KLASYFIKATOR5(nolock) on KL5_ROWID = OSA_KL5ID
	left join OBJASSET/*_DISTINCT*/ on OBA_OBJID = o.OBJ_ROWID
	left join dbo.ASSET (nolock) on AST_ROWID = OBA_ASTID
	left join dbo.PSP (nolock) on PSP_ROWID = p.OBJ_PSPID
	left join dbo.INVTSK (nolock) on ITS_ROWID = PSP_ITSID 
	left join dbo.STENCIL (nolock) on O.OBJ_STSID = STS_ROWID
	left join dbo.ZWFOT (nolock) OOT on OOT.OT_ROWID = o.OBJ_OTID
where 
	isnull(o.OBJ_NOTUSED,0) <> 1
	--and STS_SETTYPE not in ('KOM', 'ZES')
   
   
   --and o.OBJ_OTID = 335
   --SELECT OBJ_OTID, * FROM OBJ WHERE OBJ_OTID = 335








GO