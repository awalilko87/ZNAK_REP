SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[INWASTLN_ASTOBJ_LS_Get](@p_CCDID int, @p_KL5ID int, @p_UserID nvarchar(30))
returns table 
as return
select
 SIA_ASTID = ast.AST_ROWID
,SIA_ASSET = ast.AST_CODE + ' - '+ ast.AST_SUBCODE 
,SIA_ASTCODE = ast.AST_CODE  
,SIA_ASTDESC = case 
				when o.OBJ_ROWID is null and ast.AST_SUBCODE <> ast0.AST_SUBCODE and ast.AST_DONIESIENIE = 1 then isnull(o0.OBJ_DESC + '. ', '') + '(SAP: ' + isnull(ast.AST_DESC + ')', '')
				else isnull(o.OBJ_DESC + '. ', '') + '(SAP: ' + isnull(ast.AST_DESC + ')', '')
			end
,SIA_ASTSUBCODE = ast.AST_SUBCODE
,SIA_BARCODE = case 
				when o.OBJ_ROWID is null and ast.AST_SUBCODE <> ast0.AST_SUBCODE and ast.AST_DONIESIENIE = 1 then isnull(o0.OBJ_CODE, 'Brak w ZMT')
				else isnull(o.OBJ_CODE, 'Brak w ZMT')
			end
,SIA_EQUIPMENT = case when left(ast.AST_CODE,1) = '3' then 1 else 0 end
,SIA_LP = (row_number() over(partition by ast.AST_KL5ID order by ast.AST_CODE, ast.AST_SUBCODE))
,SIA_OBJ_LINES =   
    '<a href="'+ dbo.VS_EncryptLink('/Tabs3.aspx/' +
    '?WHO=INWASTLN_LSRC'+
    '&FID=INWAST_ADD_OBJ_PROPERTIES'+
    '&FLD=Btn_ObjLines'+
    '&A=Btn_ObjLines'+
    '&OBJ=' + o.OBJ_CODE +
    '&OBJ_DESC=' + o.OBJ_DESC +
    '&ANOID=' + cast(o.OBJ_ANOID as nvarchar)+
    '&STS=' + STS_CODE) +
    '" target="_blank" title="Pokaż parametry">'+
    '<img src="/Images/24x24/Format%20Numbering.png" border="none" type="image" width="24" height="24"/></a>'
,SIA_OBJID = o.OBJ_ROWID
,SIA_OBJCODE = o.OBJ_CODE
,SIA_ASTSAPANLKL = ast.AST_SAP_ANLKL
,SIA_ASTDONIESIENIE = ast.AST_DONIESIENIE
,SIA_KEYS = ''
from dbo.ASSET ast
inner join dbo.ASSET ast0 on ast0.AST_CODE = ast.AST_CODE and ast0.AST_SUBCODE = '0000'
outer apply (select top 1 OBJ_ROWID, OBJ_CODE, OBJ_DESC, OBJ_ANOID, OBJ_STSID from dbo.OBJ inner join dbo.OBJASSET on OBA_OBJID = OBJ_ROWID where OBA_ASTID = ast.AST_ROWID order by nullif(OBJ_PARENTID, OBJ_ROWID), OBJ_ROWID)o
outer apply (select top 1 OBJ_ROWID, OBJ_CODE, OBJ_DESC from dbo.OBJ inner join dbo.OBJASSET on OBA_OBJID = OBJ_ROWID where OBA_ASTID = ast0.AST_ROWID order by nullif(OBJ_PARENTID, OBJ_ROWID), OBJ_ROWID)o0
--outer apply (select PARENT_DESC = OBJ_DESC from dbo.OBJ o2 where o2.OBJ_ROWID = o.OBJ_PARENTID and o.OBJ_ROWID <> o.OBJ_PARENTID)p
left join dbo.STENCIL on STS_ROWID = o.OBJ_STSID
where isnull(ast.AST_NOTUSED,0)=0 and ast.AST_SAP_DEAKT is null and
ast.AST_CCDID = @p_CCDID and ast.AST_KL5ID = @p_KL5ID
GO