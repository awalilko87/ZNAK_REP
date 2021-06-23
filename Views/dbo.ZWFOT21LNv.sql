SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT21LNv]
as

select
	[OT21LN_LP] = ROW_NUMBER() OVER(PARTITION BY [OT21LN_OT21ID] ORDER BY case when [OBJ_ROWID] = [OBJ_PARENTID] then 0 else 1 end, [OBJ_CODE],[OT21LN_NZWYP] ASC)
	,[OT21LN_ROWID]
	 
	,[OT21LN_WART_NAB_PLN]
	,[OT21LN_DOSTAWCA]
	,[OT21LN_DOSTAWCA_DESC] = (select VEN_DESC from dbo.VENDOR (nolock) where VEN_CODE = OT21LN_DOSTAWCA)
	,[OT21LN_NR_DOW_DOSTAWY]
	,[OT21LN_DT_DOSTAWY]
	,[OT21LN_GRUPA]-- nowe
	,[OT21LN_ILOSC]-- nowe
	,[OT21LN_NZWYP]-- nowe
	,[OT21LN_MUZYTK]--nowe
  	,[OT21LN_ANLN1]
  	,[OT21LN_ANLN1_POSKI]
	,[OT21LN_ANLN2]
	,[OT21LN_ZMT_ROWID]
	,[OT21LN_OT21ID]
	,[OT21LN_ZMT_OBJ_CODE]

	--dane pozycji ZMT
	,[OTL_ROWID]
	,[OTL_OTID]
	,[OTL_OBJID]
	,[OTL_OBJ] = [OBJ_CODE]
	,[OTL_OBJ_DESC] = [OBJ_DESC]
	,[OTL_CODE]
	,[OTL_ORG]
	,[OTL_STATUS]
	,[OTL_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT21')
	,[OTL_TYPE]
	,[OTL_RSTATUS] = [OT_RSTATUS]
	,[OTL21LN_RSTATUS] = [OT_RSTATUS]
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
	,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT21')
	,[OT21_IF_EQUNR] 
	,[OT21_ZMT_OBJ_CODE] = [SAPO_ZWFOT21].[ZMT_OBJ_CODE]
	
from
[dbo].[SAPO_ZWFOT21LN] (nolock)
	join [dbo].[SAPO_ZWFOT21] (nolock) on OT21_ROWID = OT21LN_OT21ID
	join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT21LN_ZMT_ROWID
	join [dbo].[ZWFOT] (nolock) on OT_ROWID = OTL_OTID --takie połączenie również prawidłowe: [ZWFOT].OT_ROWID = [OT21_ZMT_ROWID]
	left join [dbo].[PSP] (nolock) on PSP.PSP_ROWID = [OT_PSPID]
	left join [dbo].[INVTSK] (nolock) on INVTSK.ITS_ROWID = [OT_ITSID]
	left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OTL_OBJID]
where 
	[OT21_IF_STATUS] <> 4
	and [OT_TYPE] = 'SAPO_ZWFOT21'
	and isnull([OTL_NOTUSED],0) = 0
 









GO