SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[AST_INWLN_ASTOBJv]  as
SELECT 
	--sia_objid, oba_objid,*,
	--sia_barcode, AST_CODE, AST_SUBCODE,
	 SIA_ROWID
	,SIA_LP = (row_number() over(partition by SIA_SINID order by AST_CODE, AST_SUBCODE))
	,SIA_SINID
	,SIA_CODE
	,SIA_ASTSUBCODE = AST_SUBCODE 
	,SIA_BARCODE = isnull(OBJ_CODE, 'Brak w ZMT')
	,SIA_ROWGUID
	,SIA_CCDID = AST_CCDID
	,SIA_CCD = CCD_CODE
	,SIA_CCD_DESC = CCD_DESC
	,SIA_ASTID = AST_ROWID
	,SIA_ASTCODE = AST_CODE
	,SIA_ASTDESC = isnull(OBJ_DESC + '. ', '') + '(SAP: ' + isnull(AST_DESC + ')', '')
	,SIA_ASSET = AST_CODE + ' - '+ AST_SUBCODE 
	,SIA_OBJID = OBJ_ROWID
	,SIA_ORG
	,SIA_DESC
	,SIA_NOTE
	,SIA_DATE
	,SIA_STATUS
	,SIA_STATUS_DESC = (select STA_DESC from dbo.STA where STA_ENTITY = 'SIL' and STA_CODE = SIA_STATUS)
	,SIA_ICONSTATUS = dbo.GetStatusImage ('SIA', SIA_STATUS)
	,SIA_TYPE
	,SIA_TYPE_DESC = null--typ1.DES_TEXT
	,SIA_TYPE2
	,SIA_TYPE2_DESC = null--typ2.DES_TEXT
	,SIA_TYPE3
	,SIA_TYPE3_DESC = null--typ3.DES_TEXT
	,SIA_RSTATUS = SIN_RSTATUS
	,SIA_CREUSER
	,SIA_CREUSER_DESC = dbo.UserName(SIA_CREUSER)
	,SIA_CREDATE
	,SIA_UPDUSER
	,SIA_UPDUSER_DESC = dbo.UserName(SIA_UPDUSER)
	,SIA_UPDDATE
	,SIA_NOTUSED
	,SIA_ID
	,SIA_TXT01,SIA_TXT02,SIA_TXT03,SIA_TXT04,SIA_TXT05
	,SIA_TXT06,SIA_TXT07,SIA_TXT08,SIA_TXT09
	,SIA_NTX01,SIA_NTX02,SIA_NTX03,SIA_NTX04,SIA_NTX05
	,SIA_COM01,SIA_COM02
	,SIA_DTX01,SIA_DTX02,SIA_DTX03,SIA_DTX04,SIA_DTX05
	,SIA_OLDQTY
	,SIA_NEWQTY
	,SIA_DIFF = SIA_NEWQTY - isnull(SIA_OLDQTY, 0)
	,SIA_PRICE
	,SIA_LANGID = 'PL'
	,SIA_EQUIPMENT = case when left(AST_CODE,1) = '3' then 1 else 0 end
	,SIA_OBJ_LINES = 
				'<a href="'+ dbo.VS_EncryptLink('/Tabs3.aspx/' +
				'?WHO=INWASTLN_LSRC'+
				'&FID=INWAST_ADD_OBJ_PROPERTIES'+
				'&FLD=Btn_ObjLines'+
				'&A=Btn_ObjLines'+
				'&OBJ=' + OBJ_CODE + 
				'&OBJ_DESC=' + OBJ_DESC + 
				'&ANOID=' + cast(OBJ_ANOID as nvarchar)+ 
				'&STS=' + STS_CODE) + 
				'" target="_blank" title="Pokaż parametry">'+
				'<img src="/Images/24x24/Format%20Numbering.png" border="none" type="image" width="24" height="24"/></a>'
						
			--~/Tabs3.aspx/?MID=ZMT_INVEST&TGR=INVTSK&TAB=INVTSK_NEW_OBJ_PROPERTIES&FID=INVTSK_NEW_OBJ_PROPERTIES 
     ,SIA_ANLKL  = AST_SAP_ANLKL
     ,SIA_KEYS = ''
     ,SIA_PK = binary_checksum(SIA_ID, OBJ_CODE)
       
from dbo.AST_INWLN(nolock)
	inner join dbo.ST_INW(nolock) on SIN_ROWID = SIA_SINID
	inner join dbo.ASSET(nolock) on AST_ROWID = SIA_ASSETID and AST_NOTUSED = 0	and AST_SAP_DEAKT is null
	left join dbo.OBJASSET (nolock) on OBA_ASTID = AST_ROWID and isnull (SIA_OBJID, OBA_OBJID) = OBA_OBJID 
	left join dbo.OBJ (nolock) on OBJ_ROWID = OBA_OBJID
	left join dbo.STENCIL (nolock) on STS_ROWID = OBJ_STSID 
	inner join dbo.COSTCODE (nolock) on CCD_ROWID = AST_CCDID
 where 
	isnull(AST_NOTUSED,0) = 0 
	and AST_SAP_DEAKT is null
GO