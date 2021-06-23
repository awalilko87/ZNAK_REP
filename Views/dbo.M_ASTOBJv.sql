SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[M_ASTOBJv]
as
--with CE_OBJASSET as (select OBA_OBJID, max(oba_astid) as OBA_ASTID from OBJASSET (nolock) group by oba_objid )
select
	 OBJ_ID= convert(uniqueidentifier,o.OBJ_ID)
	, OBJ_ROWID= o.OBJ_ROWID
	, OBJ_ASTID = AST_ROWID
	, OBJ_SIGNED = isnull(o.OBJ_SIGNED,0)
	, o.OBJ_SIGNEDEXISTS
	, o.OBJ_CODE
	, o.OBJ_ORG
	, o.OBJ_DESC
	, o.OBJ_NOTE
	, OBJ_ASSETID = OBA_ASTID
	, OBJ_ASSET = AST_CODE 
	, OBJ_ASSET_SUBCODE = AST_SUBCODE 
	, OBJ_ASSET_DESC = AST_DESC 
from dbo.OBJASSET (nolock) 
	right join OBJ o on OBA_OBJID = o.OBJ_ROWID
	join dbo.OBJGROUP (nolock) on OBG_ROWID = o.OBJ_GROUPID
	left join dbo.OBJ (nolock) p on p.OBJ_ROWID = o.OBJ_PARENTID
	left join dbo.OBJSTATION (nolock) os on os.OSA_OBJID = o.OBJ_ROWID
	left join dbo.STATION s (nolock) on s.STN_ROWID = OSA_STNID
	left join dbo.COSTCODE (nolock) on CCD_ROWID = STN_CCDID
	left join dbo.KLASYFIKATOR5(nolock) on KL5_ROWID = OSA_KL5ID
	left join dbo.ASSET (nolock) on AST_ROWID = OBA_ASTID
	left join dbo.PSP (nolock) on PSP_ROWID = p.OBJ_PSPID
	left join dbo.INVTSK (nolock) on ITS_ROWID = PSP_ITSID 
	left join dbo.STENCIL (nolock) on O.OBJ_STSID = STS_ROWID
	left join dbo.ZWFOT (nolock) OOT on OOT.OT_ROWID = o.OBJ_OTID
where 
	isnull(o.OBJ_NOTUSED,0) <> 1

GO