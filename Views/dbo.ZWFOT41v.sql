SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT41v]      
as      
SELECT       
 [OT41_ROWID]      
 ,[OT41_KROK]      
 ,[OT41_BUKRS]      
 ,[OT41_IMIE_NAZWISKO]      
 ,[OT41_IF_STATUS]      
 ,[OT41_IF_SENTDATE]       
 ,[OT41_IF_EQUNR]= cast(isnull([OT41_IF_EQUNR],'Brak w SAP') as nvarchar(30))      
 ,[OT41_IF_EQUNR_ALL] =       
  Stuff((SELECT N'; ' + cast(isnull(replace(sub_ot41.[OT41_IF_EQUNR],'0000000000','Niewysłany'),'Brak w SAP') as nvarchar(30))       
  FROM [SAPO_ZWFOT41] sub_ot41 (nolock) where [ZWFOT].OT_ROWID = sub_ot41.[OT41_ZMT_ROWID] FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(max)'),1,2,N'')      
 ,[OT41_ZMT_ROWID]      
 ,[OT41_SAPUSER]      
 ,[OT41_NR_SZKODY]                 
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
 ,[OT_OBSZAR]
 ,[OT_COSTCODEID]      
 ,[OT_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT41_RC&FID=OT41_LN&FLD=OT41_LN_FORM&A=OT41_LN_FORM&OT41ID=' + cast(OT41_ROWID as nvarchar(50))) + ''',''mywindowtitle'')"       
 title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'      
 ,[OT_LINES_COUNT] = (select COUNT(*) from [ZWFOTLN] (nolock) where isnull(OTL_NOTUSED,0) = 0 and OTL_OTID = OT_ROWID)      
       
 ,(select top 1 right(OT41LN_KOSTL, 7) from [dbo].[SAPO_ZWFOT41LN] where OT41LN_OT41ID = OT41_ROWID) as OT41LN_KOSTL      
        
--, alter table [dbo].[SAPO_ZWFOT41] add [OT41_CODE] nvarchar(30)      
FROM [dbo].[SAPO_ZWFOT41] (nolock)      
 join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT41_ZMT_ROWID]      
 left join [dbo].[PSP] (nolock) on PSP.PSP_ROWID = [OT_PSPID]      
 left join [dbo].[INVTSK] (nolock) on INVTSK.ITS_ROWID = [OT_ITSID]      
 --left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OT_OBJID]      
where [OT41_IF_STATUS] <> 4      
and [OT_TYPE] = 'SAPO_ZWFOT41' 
GO