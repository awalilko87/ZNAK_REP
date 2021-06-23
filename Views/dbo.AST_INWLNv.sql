SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[AST_INWLNv]
as
with OBJASSET_ONE as (select OBA_ASTID, min(OBA_OBJID) OBA_OBJID from OBJASSET (nolock) group by OBA_ASTID)
SELECT 
 SIA_ROWID
,SIA_LP = 0--(row_number() over(partition by SIA_SINID order by AST_CODE, AST_SUBCODE))
,SIA_SINID
,SIA_CODE
,SIA_ASTSUBCODE = AST_SUBCODE 
,SIA_BARCODE= isnull(OBJ_CODE, SIA_BARCODE)
,SIA_PARENT = (select isnull(p.OBJ_CODE,'') from OBJ p where p.OBJ_ROWID = OBJ.OBJ_PARENTID and obj.OBJ_ROWID <> obj.OBJ_PARENTID)
,SIA_ROWGUID
,SIA_CCDID = AST_CCDID
,SIA_CCD = CCD_CODE
,SIA_SURPLUS = ISNULL(SIA_SURPLUS,0)
,SIA_ASTID = AST_ROWID
,SIA_ASTCODE = IsNull(AST_CODE, N'Nadwyżka') 
,SIA_ASTDESC = isnull(OBJ_DESC + '. ', '') + '(SAP: ' + coalesce (AST_DESC, (select OBJ_DESC from OBJ where OBJ_CODE = SIA_BARCODE))+ ')' 
,SIA_OBJID = OBJ_ROWID
,SIA_SIGNED = (select convert(int,OBJ_SIGNED) from dbo.OBJ o2 where o2.OBJ_ROWID = OBJ.OBJ_ROWID)--convert(int,OBJ_SIGNED)
,SIA_ORG
,SIA_DESC
,SIA_NOTE
,SIA_DATE
,SIA_STATUS
,SIA_STATUS_DESC = case 
					when SIA_NEWQTY = 1 and SIA_STATUS = 'INW' then '<font color="green"><b>' + sta.DES_TEXT + '</b></font>'
					when SIA_NEWQTY = 0 and SIA_STATUS = 'INW' then '<font color="red"><b>' + sta.DES_TEXT + '</b></font>'
					else sta.DES_TEXT
				end
,SIA_TYPE
,SIA_TYPE_DESC = (select TYP_DESC from TYP where typ_code = SIA_TYPE and typ_entity = 'SIN')
,SIA_TYPE2
,SIA_TYPE2_DESC = (select TYP_DESC from TYP where typ_code = upper(SIN_TYPE)+'#'+upper(SIA_TYPE2) and typ_entity = 'SIN') 
,SIA_TYPE3
,SIA_TYPE3_DESC = (select TYP_DESC from typ where typ_code = upper(SIN_TYPE)+'#'+upper(SIA_TYPE2)+'#'+upper(SIA_TYPE3) and typ_entity = 'SIN')

,SIA_RSTATUS = case when (SIN_STATUS = 'SIN_003') then 0 else 1 end
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
,SIA_NEWQTY = cast(SIA_NEWQTY as int)
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

,SIA_ANLKL= AST_SAP_ANLKL
,SIA_CONFIRMUSER
,SIA_CONFIRMUSER_DESC = dbo.UserName(SIA_CONFIRMUSER)
,SIA_CONFIRMDATE 
,SIA_PDA_DATE
,AST_SAP_URWRT
,SIA_NADWYZKA
,SIA_WARTOSC = replace(replace(convert(varchar,AST_SAP_URWRT,1),',',' '),'.',',')
, AST_DESC
from dbo.AST_INWLN(nolock)
inner join dbo.ST_INW(nolock) on SIN_ROWID = SIA_SINID
left join dbo.ASSET(nolock) on AST_ROWID = SIA_ASSETID 
left join OBJASSET_one on OBA_ASTID = AST_ROWID
--left join dbo.OBJ (nolock) on (OBJ_ROWID = OBA_OBJID and OBA_ASTID is not null) or (OBJ_ROWID = SIA_OBJID and OBA_ASTID is null)
left join dbo.OBJ (nolock) on (OBJ_ROWID = OBA_OBJID and OBA_OBJID is not null) or (OBJ_CODE = SIA_BARCODE and OBA_OBJID is null)
left join dbo.STENCIL (nolock) on STS_ROWID = OBJ_STSID 
left join dbo.COSTCODE (nolock) on CCD_ROWID = AST_CCDID
left join dbo.DESCRIPTIONS_SILv sta(nolock) on sta.DES_TYPE = 'STAT' and sta.DES_CODE = SIA_STATUS and sta.DES_LANGID = 'PL'                     
GO