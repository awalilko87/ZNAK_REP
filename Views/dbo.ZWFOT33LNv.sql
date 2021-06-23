SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT33LNv]          
as          
          
select          
 [OT33LN_LP] = ROW_NUMBER() OVER(PARTITION BY [OT33LN_OT33ID] ORDER BY [OT33LN_ANLN1] ASC)          
           
 ,[OT33LN_ROWID]           
 ,[OT33LN_BUKRS]          
 ,[OT33LN_ANLN1]          
 ,[OT33LN_ANLN1_POSKI]          
 ,[OT33LN_ANLN1_POSKI_DESC] = (select top 1 AST_DESC from ASSET (nolock) where AST_CODE = [OT33LN_ANLN1_POSKI] and AST_SUBCODE = '0000')          
 ,[OT33LN_DT_WYDANIA]          
 ,[OT33LN_MPK_WYDANIA]          
 ,[OT33LN_MPK_WYDANIA_POSKI]          
 ,[OT33LN_MPK_WYDANIA_POSKI_DESC] = (select top 1 CCD_DESC from COSTCODE (NOLOCK) where CCD_CODE = [OT33LN_MPK_WYDANIA_POSKI])          
 ,[OT33LN_GDLGRP]          
 ,[OT33LN_GDLGRP_POSKI]           
 ,[OT33LN_GDLGRP_POSKI_DESC] = (select top 1 KL5_DESC from KLASYFIKATOR5 (nolock) where KL5_CODE = [OT33LN_GDLGRP_POSKI])          
 ,[OT33LN_TXT50]          
 ,[OT33LN_UZASADNIENIE]          
 ,[OT33LN_ZMT_ROWID]          
 ,[OT33LN_OT33ID]          
              
 --dane pozycji ZMT          
 ,[OTL_ROWID]          
 ,[OTL_OTID]          
 --,OTL_OBJID = OTO_OBJID        
 ,[OTL_OBJID]       
 ,[OTL_OBJ] = [OBJ_CODE]          
 ,[OTL_OBJ_DESC] = [OBJ_DESC]          
 ,[OTL_CODE]          
 ,[OTL_ORG]          
 ,[OTL_STATUS]          
 ,[OTL_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT33')          
 ,[OTL_TYPE]          
 ,[OTL_RSTATUS] = [OT_RSTATUS]          
 ,[OTL33_RSTATUS] = [OT_RSTATUS]          
 ,[OTL_ID]          
 ,[OTL_CREUSER]          
 ,[OTL_CREUSER_DESC] = dbo.UserName([OTL_CREUSER])          
 ,[OTL_CREDATE]          
 ,[OTL_UPDUSER]          
 ,[OTL_UPDUSER_DESC] = dbo.UserName(OTL_UPDUSER)          
 ,[OTL_UPDDATE]           
          
 --dane nagłówka          
 ,[OT_ID]          
 ,[OT_CODE]          
 ,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT33')          
 ,[OT33_IF_EQUNR]           
          
from          
[dbo].[SAPO_ZWFOT33LN] (nolock)          
 join [dbo].[SAPO_ZWFOT33] (nolock) on OT33_ROWID = OT33LN_OT33ID          
 join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT33LN_ZMT_ROWID          
 join [dbo].[ZWFOT] (nolock) on OT_ROWID = OTL_OTID --takie połączenie również prawidłowe: [ZWFOT].OT_ROWID = [OT33_ZMT_ROWID]          
-- left join [dbo].[ZWFOTOBJ] (nolock) on OTO_OTID = OT_ROWID        
 left join [dbo].[PSP] (nolock) on PSP.PSP_ROWID = [OT_PSPID]          
 left join [dbo].[INVTSK] (nolock) on INVTSK.ITS_ROWID = [OT_ITSID]       
left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OTL_OBJID]         
-- left join dbo.OBJ (nolock) on OTO_OBJID = OTO_OBJID          
where           
 [OT33_IF_STATUS] <> 4          
 and [OT_TYPE] = 'SAPO_ZWFOT33'          
 and isnull([OTL_NOTUSED],0) = 0          
      
           
          
          
GO