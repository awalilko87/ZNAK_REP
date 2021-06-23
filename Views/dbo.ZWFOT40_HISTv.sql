SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT40_HISTv]
as
SELECT 
	[OT40_ROWID]
	,[OT40_KROK]
	,[OT40_BUKRS]
	,[OT40_IMIE_NAZWISKO]
	,[OT40_IF_STATUS]
	,[OT40_IF_SENTDATE] 
	,[OT40_IF_EQUNR] = cast(isnull([OT40_IF_EQUNR],'Brak w SAP') as nvarchar(30))
	,[OT40_ZMT_ROWID]
	,[OT40_SAPUSER]
	,[OT40_PL_DOC_NUM]
	,[OT40_PL_DOC_YEAR]
       
	--dane nagłówka
	,[OT_ROWID]
	,[OT_PSPID]
	,[OT_PSP] = [PSP_CODE]
	,[OT_PSP_DESC] = [PSP_DESC]
	,[OT_ITSID]
	,[OT_ITS] = [ITS_CODE]
	,[OT_ITS_DESC] = [ITS_DESC]
	--,[OT_OBJID]
	--,[OT_OBJ] = [OBJ_CODE]
	--,[OT_OBJ_DESC] = [OBJ_DESC]
	,[OT_CODE]
	,[OT_ORG]
	,[OT_STATUS]
	,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT40')
	,[OT_TYPE]
	,[OT_RSTATUS]
	,[OT40_RSTATUS] = [OT_RSTATUS]
	,[OT_ID]
	,[OT_CREUSER]
	,[OT_CREUSER_DESC] = dbo.UserName([OT_CREUSER])
	,[OT_CREDATE]
	,[OT_UPDUSER]
	,[OT_UPDUSER_DESC] = dbo.UserName([OT_UPDUSER])
	,[OT_UPDDATE]
	,[OT_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT40_RC&FID=OT40_LN&FLD=OT40_LN_FORM&A=OT40_LN_FORM&OT40ID=' + cast(OT40_ROWID as nvarchar(50))) + ''',''mywindowtitle'')" 
	title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'
	 
FROM [dbo].[SAPO_ZWFOT40] (nolock)
	join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT40_ZMT_ROWID]
	left join [dbo].[PSP] (nolock) on PSP.PSP_ROWID = [OT_PSPID]
	left join [dbo].[INVTSK] (nolock) on INVTSK.ITS_ROWID = [OT_ITSID] 
where 
	[OT_TYPE] = 'SAPO_ZWFOT40'
   
 
GO