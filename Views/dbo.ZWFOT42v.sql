SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT42v]      
as      
SELECT       
 [OT42_ROWID]      
 ,[OT42_KROK]      
 ,[OT42_BUKRS]      
 ,[OT42_IMIE_NAZWISKO]      
 ,[OT42_IF_STATUS]      
 ,[OT42_IF_SENTDATE]       
 ,[OT42_IF_EQUNR] = CAST ([OT42_IF_EQUNR] as nvarchar(30))      
 ,[OT42_IF_EQUNR_ALL] =       
  Stuff((SELECT N'; ' + cast(isnull(replace(sub_ot42.[OT42_IF_EQUNR],'0000000000','Niewysłany'),'Brak w SAP') as nvarchar(30))       
  FROM [SAPO_ZWFOT42] sub_ot42 (nolock) where [ZWFOT].OT_ROWID = sub_ot42.[OT42_ZMT_ROWID] FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(max)'),1,2,N'')      
 ,[OT42_ZMT_ROWID]      
 ,[OT42_SAPUSER]      
 ,[OT42_DOC_NUM] = cast(isnull([OT42_IF_EQUNR],'Brak w SAP') as nvarchar(30))      
 ,[OT42_DOC_YEAR] = YEAR([OT_CREDATE])      
       
 ,[OT42_UZASADNIENIE]      
 ,[OT42_KOSZT]      
 ,[OT42_SZAC_WART_ODZYSKU]      
 ,[OT42_SPOSOBLIKW]      
 ,[OT42_PSP]        
 ,[OT42_PSP_POSKI]      
 ,[OT42_ROK]        
 ,[OT42_MIESIAC]       
 ,[OT42_CZY_UCHWALA]      
 ,[OT42_CZY_DECYZJA]      
 ,[OT42_CZY_ZAKRES]      
 ,[OT42_CZY_OCENA]      
 ,[OT42_CZY_EKSPERTYZY]     
 ,[OT42_NR_SZKODY]     
       
 ,[OT42_UCHWALA_OPIS]      
 ,[OT42_DECYZJA_OPIS]      
 ,[OT42_ZAKRES_OPIS]       
 ,[OT42_OCENA_OPIS]      
 ,[OT42_EKSPERTYZY_OPIS]      
 ,[OT42_POTID]       
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
 ,[OT_OBSZAR]    
 ,[OT_COSTCODEID]    
 ,[OT_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT42_RC&FID=OT42_LN&FLD=OT42_LN_FORM&A=OT42_LN_FORM&OT42ID=' + cast(OT42_ROWID as nvarchar(50))) + ''',''mywindowtitle'')"       
  title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'      
 ,[OT_LINES_COUNT] = (select COUNT(*) from [ZWFOTLN] (nolock) where isnull(OTL_NOTUSED,0) = 0 and OTL_OTID = OT_ROWID)      
       
 ,(select top 1 right(OT42LN_KOSTL, 7) from [dbo].[SAPO_ZWFOT42LN] join dbo.ZWFOTLN on OTL_ROWID = OT42LN_ZMT_ROWID and isnull(OTL_NOTUSED,0) = 0 where OT42LN_OT42ID = OT42_ROWID) as OT42LN_KOSTL      
       
--, alter table [dbo].[SAPO_ZWFOT42] add [OT42_CODE] nvarchar(30)      
FROM [dbo].[SAPO_ZWFOT42] (nolock)      
 join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT42_ZMT_ROWID]      
 left join [dbo].[PSP] (nolock) on PSP.PSP_ROWID = [OT_PSPID]      
 left join [dbo].[INVTSK] (nolock) on INVTSK.ITS_ROWID = [OT_ITSID]      
 --left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OT_OBJID]      
where       
 [OT42_IF_STATUS] <> 4      
 and [OT_TYPE] = 'SAPO_ZWFOT42' 
GO