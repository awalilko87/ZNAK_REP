SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT32LNv]
as

select
	[OT32LN_LP] = ROW_NUMBER() OVER(PARTITION BY [OT32LN_OT32ID] ORDER BY [OT32LN_ANLN1] ASC)
	
	,[OT32LN_ROWID] 
	,[OT32LN_BUKRS]
	,[OT32LN_ANLN1]
	,[OT32LN_ANLN1_POSKI]
	,[OT32LN_DT_WYDANIA]
	,[OT32LN_MPK_WYDANIA]
	,[OT32LN_MPK_WYDANIA_POSKI]
	,[OT32LN_GDLGRP]
	,[OT32LN_GDLGRP_POSKI]
	,[OT32LN_DT_PRZYJECIA]
	,[OT32LN_MPK_PRZYJECIA]
	,[OT32LN_MPK_PRZYJECIA_POSKI]
	,[OT32LN_ANLN1_PRZYJECIA]
	,[OT32LN_ANLN1_PRZYJECIA_POSKI]
	,[OT32LN_UZYTKOWNIK]
	,[OT32LN_UZYTKOWNIK_POSKI]
	,[OT32LN_ZMT_ROWID]
	,[OT32LN_PRACOWNIK]
	,[OT32LN_OT32ID]
	            
 
	--dane pozycji ZMT
	,[OTL_ROWID]
	,[OTL_OTID]
	,[OTL_OBJID]
	,[OTL_OBJ] = [OBJ_CODE]
	,[OTL_OBJ_DESC] = [OBJ_DESC]
	,[OTL_CODE]
	,[OTL_ORG]
	,[OTL_STATUS]
	,[OTL_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT32')
	,[OTL_TYPE]
	,[OTL_RSTATUS] = [OT_RSTATUS]
	,[OTL32_RSTATUS] = [OT_RSTATUS]
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
	,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT32')
	,[OT32_IF_EQUNR] 

from
[dbo].[SAPO_ZWFOT32LN] (nolock)
	join [dbo].[SAPO_ZWFOT32] (nolock) on OT32_ROWID = OT32LN_OT32ID
	join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT32LN_ZMT_ROWID
	join [dbo].[ZWFOT] (nolock) on OT_ROWID = OTL_OTID --takie połączenie również prawidłowe: [ZWFOT].OT_ROWID = [OT32_ZMT_ROWID]
	left join [dbo].[PSP] (nolock) on PSP.PSP_ROWID = [OT_PSPID]
	left join [dbo].[INVTSK] (nolock) on INVTSK.ITS_ROWID = [OT_ITSID]
	left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OTL_OBJID]
where 
	[OT32_IF_STATUS] <> 4
	and [OT_TYPE] = 'SAPO_ZWFOT32'
	and isnull([OTL_NOTUSED],0) = 0
 

 

GO