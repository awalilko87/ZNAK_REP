SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT42LNv]  
as  
  
select  
 [OT42LN_LP] = ROW_NUMBER() OVER(PARTITION BY [OT42LN_OT42ID] ORDER BY [OT42LN_ANLN1] ASC)  
   ,[OT42LN_ROWID]  
 ,[OT42LN_BUKRS]  
 ,[OT42LN_ANLN1]  
 ,[OT42LN_ANLN1_POSKI]  
 ,[OT42LN_ANLN1_POSKI_DESC] = (select top 1 AST_DESC from dbo.ASSET (nolock) where AST_CODE = [OT42LN_ANLN1_POSKI] and AST_SUBCODE = OT42LN_ANLN2)  
 ,[OT42LN_ANLN2]  
 ,[OT42LN_KOSTL]  
 ,[OT42LN_KOSTL_POSKI]  
 ,[OT42LN_KOSTL_POSKI_DESC] = (select CCD_DESC from COSTCODEv where CCD_CODE = [OT42LN_KOSTL_POSKI] )  
   
 ,[OT42LN_GDLGRP]  
 ,[OT42LN_GDLGRP_POSKI]  
 ,[OT42LN_GDLGRP_POSKI_DESC] = (select KL5_DESC from KLASYFIKATOR5 (nolock) where KL5_CODE = [OT42LN_GDLGRP_POSKI] )  
 ,[OT42LN_ODZYSK]  
 ,[OT42LN_LIKWCZESC] = case when [OT42LN_LIKWCZESC] = 'X' then 'X' else '0' end --SAP przyjmuje tylko 'X' lub '', Vision dla '' się gubi  
 ,[OT42LN_PROC] --gdy LIKWCZESC = '' to musi być 100  
 ,[OT42LN_ZMT_ROWID]  
 ,[OT42LN_OT42ID]  
   
 --dane pozycji ZMT  
 ,[OTL_ROWID]  
 ,[OTL_OTID]  
 ,[OTL_OBJID]  
 ,[OTL_OBJ] = [OBJ_CODE]  
 ,[OTL_OBJ_DESC] = [OBJ_DESC]  
 ,[OTL_CODE]  
 ,[OTL_ORG]  
 ,[OTL_STATUS]  
 ,[OTL_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT42')  
 ,[OTL_TYPE]  
 ,[OTL_RSTATUS] = [OT_RSTATUS]  
 ,[OTL42_RSTATUS] = [OT_RSTATUS]  
 ,[OTL_ID]  
 ,[OTL_CREUSER]  
 ,[OTL_CREUSER_DESC] = dbo.UserName([OTL_CREUSER])  
 ,[OTL_CREDATE]  
 ,[OTL_UPDUSER]  
 ,[OTL_UPDUSER_DESC] = dbo.UserName(OTL_UPDUSER)  
 ,[OTL_UPDDATE]   
  
 --dane nagłówka  
 ,[OT_ID]
 ,[OT_ROWID]  
 ,[OT_CODE]  
 ,[OT_STATUS]  
 ,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT42')  
 ,[OT42_IF_EQUNR]   
 ,[OTL_VALUE] = AST_SAP_URWRT * [OT42LN_PROC] / 100  
 ,[OTL_URWRT] = convert(numeric(15,2), AST_SAP_URWRT)  
 ,[OTL_NETVALUE] = AST_NETVALUE
 ,[OTL_ACTVALUEDATE] = AST_ACTVALUEDATE
  
from  
[dbo].[SAPO_ZWFOT42LN] (nolock)  
 join [dbo].[SAPO_ZWFOT42] (nolock) on OT42_ROWID = OT42LN_OT42ID  
 join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT42LN_ZMT_ROWID  
 join [dbo].[ZWFOT] (nolock) on OT_ROWID = OTL_OTID --takie połączenie również prawidłowe: [ZWFOT].OT_ROWID = [OT42_ZMT_ROWID]  
 left join [dbo].[PSP] (nolock) on PSP.PSP_ROWID = [OT_PSPID]  
 left join [dbo].[INVTSK] (nolock) on INVTSK.ITS_ROWID = [OT_ITSID]  
 left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OTL_OBJID]  
 left join [dbo].[ASSET] (nolock) on AST_CODE = [OT42LN_ANLN1_POSKI] and AST_SUBCODE = [OT42LN_ANLN2]  
where   
 [OT42_IF_STATUS] <> 4  
 and [OT_TYPE] = 'SAPO_ZWFOT42'  
 and isnull([OTL_NOTUSED],0) = 0  
GO