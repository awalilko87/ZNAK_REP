SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[GetStsPspObj] (@p_PSP nvarchar(30), @p_INOID int)  
returns table 
as return  
select   
PARENT.STS_ROWID  as STS_PARENTID,  
PARENT.STS_CODE as STS_PARENT,  
PARENT.STS_DESC as STS_PARENTDESC,  
CHILD.STS_ROWID as STS_CHILDID,  
CHILD.STS_CODE as STS_CHILD,  
CHILD.STS_DESC as STS_CHILDDESC,  
countv.OBJ_PSPID as OBJ_PSPID,  
countv.OBJ_PSP as OBJ_PSP,  
countv.OBJ_PSPDESC as OBJ_PSPDESC,  
isnull(OBJ_COUNT,0) as OBJ_COUNT,  
OBJ_VALUE,  
STL_DEFAULT_NUMBER = case     
						when STL_ONE = 'TAK' then 1    
						else isnull(ln.STL_DEFAULT_NUMBER, 1)    
					end 
from STENCIL (nolock) PARENT  
join STENCILLN ln (nolock) on STL_PARENTID = PARENT.STS_ROWID   
join STENCIL (nolock) CHILD on STL_CHILDID = CHILD.STS_ROWID   
left join [STSPSPOBJ_COUNTv] countv on   
countv.STS_CHILDID = CHILD.STS_ROWID   
and countv.STS_PARENTID = PARENT.STS_ROWID   
and OBJ_PSP = @p_PSP  
and INO_ROWID = @p_INOID  
GO