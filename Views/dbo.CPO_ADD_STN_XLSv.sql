SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[CPO_ADD_STN_XLSv]    
as    
select rowid  
,spid  
,importuser  
,lp  
,stnid  
,potid    
,mpk   
from CPO_ADD_STN_XLS



GO