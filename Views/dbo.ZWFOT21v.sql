SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT21v]
as
SELECT 

	[OT21_ROWID]
	,[OT21_BUKRS]
	,[OT21_SAPUSER]
	,[OT21_IMIE_NAZWISKO]
	,[OT21_MUZYTKID]
	,[OT21_MUZYTK]
	,[OT21_KOSTL] 
	,[OT21_KOSTL_POSKI]
	,[OT21_GDLGRP]
	,[OT21_GDLGRP_POSKI]
	,[OT21_SERNR]
	,[OT21_SERNR_POSKI]
	,[OT21_POSNR]
	,[OT21_POSNR_POSKI]
	,[OT21_CZY_FORM] 
	,[OT21_NR_FORM]
	,[OT21_TYP_DOK]
	,[OT21_POZ_FORM]
	,[OT21_NR_DOK]
	,[OT21_KWPRZEKSIEGS]
	,[ZMT_OBJ_CODE]
	,[OT21_IF_STATUS]
	,[OT21_IF_SENTDATE]
	,[OT21_IF_EQUNR]  = cast(isnull([OT21_IF_EQUNR],'Brak w SAP') as nvarchar(30))
	,[OT21_IF_EQUNR_ALL] = 
		Stuff((SELECT N'; ' + cast(isnull(replace(sub_ot21.[OT21_IF_EQUNR],'0000000000','Niewysłany'),'Brak w SAP') as nvarchar(30)) 
		FROM [SAPO_ZWFOT21] sub_ot21 (nolock) where [ZWFOT].OT_ROWID = sub_ot21.[OT21_ZMT_ROWID] FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(max)'),1,2,N'')
	,[OT21_ZMT_ROWID]     
	
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
	,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT21')
	,[OT_TYPE]
	,[OT_RSTATUS]
	,[OT21_RSTATUS] = [OT_RSTATUS]
	,[OT_ID]
	,[OT_CREUSER]
	,[OT_CREUSER_DESC] = dbo.UserName(OT_CREUSER)
	,[OT_CREDATE]
	,[OT_UPDUSER]
	,[OT_UPDUSER_DESC] = dbo.UserName(OT_UPDUSER)
	,[OT_UPDDATE] 
	,[OT_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT21_RC&FID=OT21_LN&FLD=OT21_LN_FORM&A=OT21_LN_FORM&OT21ID=' + cast(OT21_ROWID as nvarchar(50))) + ''',''mywindowtitle'')" 
	title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'
   	,[OT_LINES_COUNT] = (select COUNT(*) from [ZWFOTLN] (nolock) where isnull(OTL_NOTUSED,0) = 0 and OTL_OTID = OT_ROWID)
	  
FROM [dbo].[SAPO_ZWFOT21] (nolock)
	join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT21_ZMT_ROWID]
	left join [dbo].[PSP] (nolock) on PSP.PSP_ROWID = [OT_PSPID]
	left join [dbo].[INVTSK] (nolock) on INVTSK.ITS_ROWID = [OT_ITSID]
	--left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OT_OBJID]
where 
	[OT21_IF_STATUS] <> 4
	and [OT_TYPE] = 'SAPO_ZWFOT21'
  
  --do usuniecia z formatek (OT21 powstał jako kopia z OT12)
	--,[OT21_KROK]
 -- 	,[OT21_DATA_WYST]
	--,[OT21_DOC_NUM]
 --   	,[OT21_HERST]
	--,[OT21_NR_DOW_DOST]
	--,[OT21_DATA_DOST] = convert(datetime,cast([OT21_ROK_DOST]as nvarchar) + '-' + cast( [OT21_MIES_DOST] as nvarchar) + '-01')
	--,[OT21_MIES_DOST]
	--,[OT21_ROK_DOST]
	--,[OT21_PRZEW_OKRES]
	--,[OT21_WOJEWODZTWO]
	--,[OT21_NR_TECHNOL]
	--,[OT21_WART_TOTAL]
	--,[OT21_ANLKL]














GO