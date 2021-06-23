﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[POP_ASSETv]      
as      
select     
   AST_ROWID    
 , AST_CODE    
 , AST_SUBCODE    
 , AST_BARCODE    
 , AST_DESC    
 , AST_STATUS_DESC = (select STA_DESC from dbo.STA (nolock) where STA_ENTITY = 'AST' and STA_CODE = AST_STATUS) --sta.DES_TEXT      
 , AST_TYPE = 'OT'--(case when (left(AST_CODE,1) = '3') then 'W' else 'OT' end)      
 , AST_TYPE_DESC = NULL    
 , AST_ID    
 , AST_CCD = CCD_CODE    
 , AST_SAP_Active      
 , AST_SAP_ANLKL     
 , AST_SAP_ERNAM      
 , AST_SAP_ERDAT     
 , AST_SAP_ZUJHR     
 , AST_SAP_AKTIV     
 , AST_SAP_HERST     
 , AST_SAP_URWRT = NULL    
 , AST_SAP_TXT50     
 , AST_SAP_GDLGRP    
 , AST_ANLUE     
 , OBG_DESC      
 , AST_SAP_NDJARPER     
 , AST_NETVALUE  
 , AST_ACTVALUEDATE  
 , AST_LANGID = 'PL'--[LangID]f 
 , AST_AMORTIZATIONPERIOD     
FROM dbo.ASSET (nolock)      
 join COSTCODE (nolock) on CCD_ROWID = AST_CCDID      
 left join OBJGROUP on OBG_ROWID = AST_OBJGROUPID    
where AST_SAP_Active = 1 and left(AST_CODE,1) in ('1','2', '3')  
GO