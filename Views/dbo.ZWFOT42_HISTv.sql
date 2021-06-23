SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT42_HISTv]
as
SELECT 
	[OT42_ROWID]
	,[OT42_KROK]
	,[OT42_BUKRS]
	,[OT42_IMIE_NAZWISKO]
	,[OT42_IF_STATUS]
	,[OT42_IF_SENTDATE] 
	,[OT42_IF_EQUNR]
	,[OT42_ZMT_ROWID]
	,[OT42_SAPUSER]
 
	,[OT42_UZASADNIENIE]
	,[OT42_KOSZT]
	,[OT42_SZAC_WART_ODZYSKU]
	,[OT42_SPOSOBLIKW]
	,[OT42_PSP]  
	,[OT42_ROK]  
	,[OT42_MIESIAC] 

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
	,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT42')
	,[OT_TYPE]
	,[OT_RSTATUS]
	,[OT42_RSTATUS] = [OT_RSTATUS]
	,[OT_ID]
	,[OT_CREUSER]
	,[OT_CREUSER_DESC] = dbo.UserName([OT_CREUSER])
	,[OT_CREDATE]
	,[OT_UPDUSER]
	,[OT_UPDUSER_DESC] = dbo.UserName([OT_UPDUSER])
	,[OT_UPDDATE]
--, alter table [dbo].[SAPO_ZWFOT42] add [OT42_CODE] nvarchar(30)
FROM [dbo].[SAPO_ZWFOT42] (nolock)
	join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT42_ZMT_ROWID]
	--left join [dbo].[PSP] (nolock) on PSP.PSP_ROWID = [OT_PSPID]
	--left join [dbo].[INVTSK] (nolock) on INVTSK.ITS_ROWID = [OT_ITSID]
	--left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OT_OBJID]
where  
	[OT_TYPE] = 'SAPO_ZWFOT42'
   




GO