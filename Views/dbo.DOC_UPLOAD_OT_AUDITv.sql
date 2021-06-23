SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[DOC_UPLOAD_OT_AUDITv]    
as    
select     
AuditID    
,FieldName    
,UserID    
,DateWhen    
,OldValue    
,NewValue    
,TableRowID    
,SystemID    
,Oper    
,adt.LastUpdate    
,OBJ_CODE 
,OT_CODE
from VS_AUDIT adt  
left join DOCENTITIES on TableRowid = DAE_DOCUMENT  
left join OBJ on adt.ROWID = OBJ_CODE 
left join ZWFOTOBJ on OTO_OBJID = OBJ_ROWID
left join ZWFOT on OTO_OTID = OT_ROWID
left join SYFILES fil on DAE_DOCUMENT = fil.FILEID2  
where adt.TableName = 'DOCENTITIES'  

GO