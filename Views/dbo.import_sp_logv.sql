SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view  [dbo].[import_sp_logv]          
as          
select          
 lsp_sqlidentity          
, lsp_stncode          
, lsp_stscode        
, lsp_param           
, lsp_importuser          
, lsp_reason          
, lsp_date       
, lsp_stacja     
, lps_stskod = (select STN_CODE from STATION where STN_ROWID = lsp_stacja)   
, lsp_sts = (select STN_DESC from STATION where STN_ROWID = lsp_stacja)        
from  import_sp_log 
GO