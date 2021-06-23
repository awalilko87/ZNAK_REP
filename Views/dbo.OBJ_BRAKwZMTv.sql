SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[OBJ_BRAKwZMTv]
as 
 
 
 select  
   LP = row_number() over (partition by STN_CODE order by SIA_ASTCODE asc)    
  ,SIA_ASTCODE 
  ,SIA_ASTDESC 
  ,STN_CODE
 from 


 ( select   
   SIA_ASTCODE 
  ,SIA_ASTDESC 
  ,STN_CODE  
   from  
  (  
  select    
  --LP = row_number() over (partition by OSA_STNID order by o.obj_code asc)  
  SIA_ASTCODE = ast.AST_CODE   
  ,SIA_ASTSUBCODE = ast.AST_SUBCODE     
   ,SIA_ASTDESC = ast.AST_DESC
  --,SIA_ASTDESC = case     
  -- when o.OBJ_ROWID is null and ast.AST_SUBCODE <> ast0.AST_SUBCODE and ast.AST_DONIESIENIE = 1 then isnull(o0.OBJ_DESC + '. ', '') + '(SAP: ' + isnull(ast.AST_DESC + ')', '')    
  -- else isnull(o.OBJ_DESC + '. ', '') + '(SAP: ' + isnull(ast.AST_DESC + ')', '')    
  --   end    
  
  ,SIA_BARCODE = case     
   when o.OBJ_ROWID is null and ast.AST_SUBCODE <> ast0.AST_SUBCODE and ast.AST_DONIESIENIE = 1 then isnull(o0.OBJ_CODE, 'Brak w ZMT')    
   else isnull(o.OBJ_CODE, 'Brak w ZMT')    
     end    
   , STN_CODE = IsNull((select top 1 STN_CODE from STATION where ast.AST_CCDID = STN_CCDID and ast.AST_KL5ID = STN_KL5ID),0) 
  from dbo.ASSET ast   
  left join dbo.OBJASSET (nolock) on OBA_ASTID = ast.AST_ROWID  
     
  inner join dbo.ASSET ast0 on ast0.AST_CODE = ast.AST_CODE and ast0.AST_SUBCODE = '0000'    
  outer apply (select top 1 OBJ_ROWID, OBJ_CODE, OBJ_DESC, OBJ_ANOID, OBJ_STSID from dbo.OBJ inner join dbo.OBJASSET on OBA_OBJID = OBJ_ROWID where OBA_ASTID = ast.AST_ROWID order by nullif(OBJ_PARENTID, OBJ_ROWID), OBJ_ROWID)o    
  outer apply (select top 1 OBJ_ROWID, OBJ_CODE, OBJ_DESC from dbo.OBJ inner join dbo.OBJASSET on OBA_OBJID = OBJ_ROWID where OBA_ASTID = ast0.AST_ROWID order by nullif(OBJ_PARENTID, OBJ_ROWID), OBJ_ROWID)o0    
  left join dbo.OBJSTATION (nolock) os on os.OSA_OBJID = o.OBJ_ROWID   
  --outer apply (select PARENT_DESC = OBJ_DESC from dbo.OBJ o2 where o2.OBJ_ROWID = o.OBJ_PARENTID and o.OBJ_ROWID <> o.OBJ_PARENTID)p    
  left join dbo.STENCIL on STS_ROWID = o.OBJ_STSID     
  where isnull(ast.AST_NOTUSED,0)=0 and ast.AST_SAP_DEAKT is null
  
  
  ) A  
  where  stn_code <> 0 and SIA_BARCODE = 'Brak w ZMT'
  )B
GO