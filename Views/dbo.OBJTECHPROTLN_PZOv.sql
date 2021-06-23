SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[OBJTECHPROTLN_PZOv]    
as    
select    
 POL_ROWID    
,POL_POTID = POL_POTID    
,POL_OBJ = o.OBJ_CODE    
,POL_OBJ_DESC = o.OBJ_DESC    
,POL_OBJ_PARENT = case when o.OBJ_ROWID = o.OBJ_PARENTID then '' else p.OBJ_CODE end     
,POL_OBJ_PARENT_DESC = case when o.OBJ_ROWID = o.OBJ_PARENTID then '' else p.OBJ_DESC end    
,POL_OBJ_STATUS_DESC = (select STA_DESC from STA (nolock) where STA_CODE = o.OBJ_STATUS and STA_ENTITY = 'OBJ')    
,POL_OBJ_TYPE_DESC = (select TYP_DESC from TYP (nolock) where TYP_CODE = o.OBJ_TYPE and TYP_ENTITY = 'OBJ')          
,POL_OBJ_GROUP_DESC = OBG_DESC    
,POL_OBJ_PSP = PSP_CODE    
,POL_OBJ_ASSET = AST_CODE_FULL    
,POL_STATUS    
,POL_COM01    
,POL_COM02   
,POL_COM03   
,POL_DATE    
,POL_DTX01  
,POL_PS_ACCEPT  
,POL_PS_COMMENT    
from dbo.OBJ o    
inner join dbo.OBJ p on p.OBJ_ROWID = o.OBJ_PARENTID    
inner join dbo.OBJGROUP on OBG_ROWID = o.OBJ_GROUPID    
inner join dbo.OBJTECHPROTLN on POL_OBJID = o.OBJ_ROWID    
left join dbo.PSP (nolock) on PSP_ROWID = o.OBJ_PSPID          
outer apply (select top 1 AST_CODE_FULL = AST_CODE + ' - '+ AST_SUBCODE from dbo.ASSET (nolock) join dbo.OBJASSET (nolock) on AST_ROWID = OBA_ASTID where OBA_OBJID = o.OBJ_ROWID order by AST_SUBCODE)ast 


GO