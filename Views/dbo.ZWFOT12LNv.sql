SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE view [dbo].[ZWFOT12LNv]
as

select
	[OT12LN_LP] = ROW_NUMBER() OVER(PARTITION BY [OT12LN_OT12ID] ORDER BY case when [OBJ_ROWID] = [OBJ_PARENTID] then 0 else 1 end, [OBJ_CODE],[OT12LN_INVNR_NAZWA] ASC)
	,[OT12LN_ROWID]
	,[OT12LN_INVNR_NAZWA]
	,[OT12LN_CHAR_SKLAD]
	,[OT12LN_WART_ELEME]
	,[OT12LN_ANLN1]
	,[OT12LN_ANLN1_POSKI]
	,[OT12LN_ANLN2]
	,[OT12LN_ZMT_ROWID]
	,[OT12LN_OT12ID]
	,[OT12LN_ZMT_OBJ_CODE]

	--dane pozycji ZMT
	,[OTL_ROWID]
	,[OTL_OTID]
	,[OTL_OBJID]
	,[OTL_OBJ] = [OBJ_CODE]
	,[OTL_OBJ_DESC] = [OBJ_DESC]
	,[OTL_CODE]
	,[OTL_ORG]
	,[OTL_STATUS]
	,[OTL_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT12')
	,[OTL_TYPE]
	,[OTL_RSTATUS] = [OT_RSTATUS]
	,[OTL12_RSTATUS] = [OT_RSTATUS]
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
	,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT12')
	,[OT12_IF_EQUNR] 
	,[OT12_ZMT_OBJ_CODE] = [SAPO_ZWFOT12].[ZMT_OBJ_CODE]
	,[OT12_ZMT_ROWID]

from
[dbo].[SAPO_ZWFOT12LN] (nolock)
	join [dbo].[SAPO_ZWFOT12] (nolock) on OT12_ROWID = OT12LN_OT12ID
	join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT12LN_ZMT_ROWID
	join [dbo].[ZWFOT] (nolock) on OT_ROWID = OTL_OTID --takie połączenie również prawidłowe: [ZWFOT].OT_ROWID = [OT12_ZMT_ROWID]
	left join [dbo].[PSP] (nolock) on PSP.PSP_ROWID = [OT_PSPID]
	left join [dbo].[INVTSK] (nolock) on INVTSK.ITS_ROWID = [OT_ITSID]
	left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OTL_OBJID]
	--left join [dbo].[OBJ] (nolock) on OBJ.OBJ_OTLID = OTL_ROWID
where 
	[OT12_IF_STATUS] <> 4
	and [OT_TYPE] = 'SAPO_ZWFOT12'
	and isnull([OTL_NOTUSED],0) = 0
    
 
	 	



GO