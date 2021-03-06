SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[CPO_OBJECT_STENCILv_DEL]        
as        
select     
STS_ROWID     
,STS_CODE    
,STS_DESC      
,TYP_ROWID        
,TYP2_ROWID        
,TYP_ENTITY        
,TYP_CODE        
,TYP_DESC        
,TYP2_CODE        
,TYP2_DESC 
,CPT_CPOID         
from STENCIL    
join CPO_OBJECT_STENCIL on CPT_STSID = STS_ROWID   
LEFT JOIN TYP on STS_TYPE = TYP_CODE       
LEFT JOIN TYP2 on STS_TYPE2 = TYP_CODE 
GO