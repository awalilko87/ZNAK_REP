SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[M_AST_INWLNv] 
as
with OBJASSET_ONE as (select OBA_ASTID, min(OBA_OBJID) OBA_OBJID from OBJASSET (nolock) group by OBA_ASTID)
SELECT 
	 --SIA_ROWID
	SIA_LP = (row_number() over(partition by SIA_SINID, LangID order by AST_CODE, AST_SUBCODE))
	,SIA_SINID
	,SIA_CODE
	,SIA_ASTSUBCODE = AST_SUBCODE 
	,SIA_BARCODE  = isnull(OBJ_CODE, SIA_BARCODE)  
	,SIA_ROWGUID
	,SIA_OBJ_SIGNED = isnull(OBJ_SIGNED,0)
	,SIA_OBJ_SIGNEDEXISTS = OBJ_SIGNEDEXISTS
	,SIA_SURPLUS = ISNULL(SIA_SURPLUS,0)
	,SIA_CCDID = AST_CCDID
	,SIA_CCD = CCD_CODE
	,SIA_CCD_DESC = CCD_DESC
	,SIA_ASTID = AST_ROWID
	,SIA_ASTCODE = AST_CODE
	,SIA_ASTDESC = isnull(OBJ_DESC + '. ', '') + '(SAP: ' + isnull(AST_DESC + ')', '')
	,SIA_OBJID = isnull(OBJ_ROWID, 0)
	,SIA_ORG
	,SIA_NOTE
	,SIA_DATE
	,SIA_STATUS
	,SIA_STATUS_DESC = sta.DES_TEXT
	,SIA_ID
	,SIA_OLDQTY
	,SIA_NEWQTY
	,SIA_DIFF = SIA_NEWQTY - isnull(SIA_OLDQTY, 0)
	,SIA_PRICE
	,SIA_LANGID = LangID
	,SIA_EQUIPMENT = case when left(AST_CODE,1) = '3' then 1 else 0 end
    ,SIA_ANLKL  = AST_SAP_ANLKL
	,SIA_CONFIRMUSER
	,SIA_CONFIRMUSER_DESC = dbo.UserName(SIA_CONFIRMUSER)
	,SIA_CONFIRMDATE 
	,SIA_PDA_DATE
from dbo.AST_INWLN(nolock)
	inner join dbo.ST_INW(nolock) on SIN_ROWID = SIA_SINID
	left join dbo.ASSET(nolock) on AST_ROWID = SIA_ASSETID 
	left join OBJASSET_ONE on OBA_ASTID = AST_ROWID
	--left join dbo.OBJ (nolock) on (OBJ_ROWID = OBA_OBJID and OBA_ASTID is not null) or (OBJ_ROWID = SIA_OBJID and OBA_ASTID is null)
	left join dbo.OBJ (nolock) on OBJ_ROWID = OBA_OBJID 
	left join dbo.STENCIL (nolock) on STS_ROWID = OBJ_STSID 
	left join dbo.COSTCODE (nolock) on CCD_ROWID = AST_CCDID
	cross join VS_Langs
	left join dbo.DESCRIPTIONS_SILv sta(nolock) on sta.DES_TYPE = 'STAT' and sta.DES_CODE = SIA_STATUS and sta.DES_LANGID = LangID
	left join dbo.DESCRIPTIONS_SILv typ1(nolock) on typ1.DES_TYPE = 'TYP1' and typ1.DES_CODE = SIA_TYPE and typ1.DES_LANGID = LangID
	left join dbo.DESCRIPTIONS_SILv typ2(nolock) on typ2.DES_TYPE = 'TYP2' and typ2.DES_CODE = SIA_TYPE+'#'+SIA_TYPE2 and typ2.DES_LANGID = LangID
	left join dbo.DESCRIPTIONS_SILv typ3(nolock) on typ3.DES_TYPE = 'TYP3' and typ3.DES_CODE = SIA_TYPE+'#'+SIA_TYPE2+'#'+SIA_TYPE3 and typ3.DES_LANGID = LangID
where 
	(AST_SUBCODE = '0000' or AST_SAP_ANLKL  in ('888-1***','486-***1', '902-1***','491-****') or AST_ROWID is null)
	and isnull(AST_NOTUSED,0) = 0
	and [LangID] = 'PL'
	and AST_SAP_DEAKT is null
	and isnull(OBJ_CODE, SIA_BARCODE) is not null 
	and SIN_STATUS = 'SIN_003'

GO