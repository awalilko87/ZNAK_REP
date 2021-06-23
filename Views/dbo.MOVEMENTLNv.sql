SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[MOVEMENTLNv] 
as
SELECT 
	 MOL_ROWID
	,MOL_LP = (row_number() over(partition by MOL_MOVID order by PARENT.OBJ_CODE, O.OBJ_CODE))
	,MOL_MOVID
	,MOL_TO_STNID
	,MOL_TO_STN = STN_TO.STN_CODE
	,MOL_TO_STN_DESC = STN_TO.STN_DESC
	,MOL_FROM_STNID = STN_FROM.STN_ROWID
	,MOL_FROM_STN = STN_FROM.STN_CODE
	,MOL_FROM_STN_DESC = STN_FROM.STN_DESC
	,MOL_OBJ_PARENTID = PARENT.OBJ_ROWID
	,MOL_OBJ_PARENT = case when O.OBJ_ROWID = PARENT.OBJ_ROWID then '' else PARENT.OBJ_CODE end
	,MOL_OBJ_PARENT_DESC = case when O.OBJ_ROWID = PARENT.OBJ_ROWID then '' else PARENT.OBJ_DESC end
	,MOL_CODE
	,MOL_ORG
	,MOL_DESC
	,MOL_NOTE
	,MOL_DATE
	,MOL_STATUS
	,MOL_STATUS_DESC =  (select STA_DESC from STA (nolock) where STA_CODE = MOL_STATUS and STA_ENTITY = 'MOL')
	,MOL_ICONSTATUS = dbo.GetStatusImage ('MOL', MOL_STATUS)
	,MOL_TYPE 
	,MOL_TYPE_DESC = (select TYP_DESC from TYP (nolock) where TYP_CODE = MOL_TYPE and TYP_ENTITY = 'MOL')
	,MOL_TYPE2
	,MOL_TYPE2_DESC = (select TYP2.TYP2_DESC from TYP2 (nolock) join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = MOL_TYPE and TYP_ENTITY = 'MOL')
	,MOL_TYPE3
	,MOL_TYPE3_DESC = (select TYP3.TYP3_DESC from TYP3 (nolock) join TYP2 (nolock) on TYP2.TYP2_ROWID = TYP3.TYP3_TYP2ID join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = MOL_TYPE and TYP_ENTITY = 'MOL')
	,MOL_RSTATUS = MOV_RSTATUS
	,MOL_CREUSER
	,MOL_CREUSER_DESC = dbo.UserName(MOL_CREUSER)
	,MOL_CREDATE
	,MOL_UPDUSER
	,MOL_UPDUSER_DESC = dbo.UserName(MOL_UPDUSER)
	,MOL_UPDDATE
	,MOL_NOTUSED
	,MOL_ID
	,MOL_TXT01,MOL_TXT02,MOL_TXT03,MOL_TXT04,MOL_TXT05
	,MOL_TXT06,MOL_TXT07,MOL_TXT08,MOL_TXT09
	,MOL_NTX01,MOL_NTX02,MOL_NTX03,MOL_NTX04,MOL_NTX05
	,MOL_COM01,MOL_COM02
	,MOL_DTX01,MOL_DTX02,MOL_DTX03,MOL_DTX04,MOL_DTX05
	,MOL_PRICE
	,MOL_OBJID = O.OBJ_ROWID
	,MOL_OBJ = O.OBJ_CODE
	,MOL_OBJDESC = O.OBJ_DESC 
	,MOL_OBGID = O.OBJ_GROUPID
	,MOL_ASSET = 
		(select  Stuff((select '; ' + AST_CODE + ' - '+ AST_SUBCODE   from dbo.ASSET (nolock) 
			 join dbo.OBJASSET (nolock) on AST_ROWID = OBA_ASTID 
			 where OBA_OBJID = O.OBJ_ROWID 
			 order by AST_SUBCODE
			 for xml path ('')),1,2,N''))
	,[OT31_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT31_RC&FID=OT31_LN&FLD=OT31_LN_FORM&A=OT31_LN_FORM&OT31ID=' + cast(MOL_OT31ID as nvarchar(50))) + ''',''mywindowtitle'')" 
		title="Wyświetl linie dla dokumentu MT1"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'
	,[OT32_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT32_RC&FID=OT32_LN&FLD=OT32_LN_FORM&A=OT32_LN_FORM&OT32ID=' + cast(MOL_OT32ID as nvarchar(50))) + ''',''mywindowtitle'')" 
		title="Wyświetl linie dla dokumentu MT2"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'
	,[OT33_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT33_RC&FID=OT33_LN&FLD=OT33_LN_FORM&A=OT33_LN_FORM&OT33ID=' + cast(MOL_OT33ID as nvarchar(50))) + ''',''mywindowtitle'')" 
		title="Wyświetl linie dla dokumentu MT3"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'
	
from [dbo].[MOVEMENTLN](nolock)
	inner join [dbo].[MOVEMENT](nolock) on MOV_ROWID = MOL_MOVID
	inner join [dbo].[OBJ](nolock) O on OBJ_ROWID = MOL_OBJID
	inner join [dbo].[OBJ](nolock) PARENT on PARENT.OBJ_ROWID = O.OBJ_PARENTID
	left join [dbo].[OBJSTATION] (nolock) on OSA_OBJID = O.OBJ_ROWID
	left join [dbo].[STATION] (nolock) STN_FROM on STN_FROM.STN_ROWID = OSA_STNID
	left join [dbo].[STATION] (nolock) STN_TO on STN_TO.STN_ROWID = MOL_TO_STNID
	
 




GO