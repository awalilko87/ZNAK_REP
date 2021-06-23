SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT41_HISTv]
as
SELECT 
	[OT41_ROWID]
	,[OT41_KROK]
	,[OT41_BUKRS]
	,[OT41_IMIE_NAZWISKO]
	,[OT41_IF_STATUS]
	,[OT41_IF_SENTDATE] 
	,[OT41_IF_EQUNR]
	,[OT41_ZMT_ROWID]
	,[OT41_SAPUSER]
  

	--dane nagłówka
	,[OT_ROWID]
	,[OT_PSPID]
	--,[OT_PSP] = [PSP_CODE]
	--,[OT_PSP_DESC] = [PSP_DESC]
	,[OT_ITSID]
	--,[OT_ITS] = [ITS_CODE]
	--,[OT_ITS_DESC] = [ITS_DESC]
	--,[OT_OBJID]
	--,[OT_OBJ] = [OBJ_CODE]
	--,[OT_OBJ_DESC] = [OBJ_DESC]
	,[OT_CODE]
	,[OT_ORG]
	,[OT_STATUS]
	,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT41')
	,[OT_TYPE]
	,[OT_RSTATUS]
	,[OT41_RSTATUS] = [OT_RSTATUS]
	,[OT_ID]
	,[OT_CREUSER]
	,[OT_CREUSER_DESC] = dbo.UserName([OT_CREUSER])
	,[OT_CREDATE]
	,[OT_UPDUSER]
	,[OT_UPDUSER_DESC] = dbo.UserName([OT_UPDUSER])
	,[OT_UPDDATE]
--, alter table [dbo].[SAPO_ZWFOT41] add [OT41_CODE] nvarchar(30)
FROM [dbo].[SAPO_ZWFOT41] (nolock)
	join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT41_ZMT_ROWID]
	--left join [dbo].[PSP] (nolock) on PSP.PSP_ROWID = [OT_PSPID]
	--left join [dbo].[INVTSK] (nolock) on INVTSK.ITS_ROWID = [OT_ITSID]
	--left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OT_OBJID]
where  
	[OT_TYPE] = 'SAPO_ZWFOT41'
   





GO