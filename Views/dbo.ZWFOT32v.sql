SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT32v]  
as  
SELECT   
  
  [OT32_ROWID]  
 ,[OT32_KROK]  
 ,[OT32_BUKRS]  
 ,[OT32_SAPUSER]  
 ,[OT32_IMIE_NAZWISKO]  
 ,[OT32_IF_STATUS]  
 ,[OT32_IF_SENTDATE]   
 ,[OT32_IF_EQUNR] = cast(isnull([OT32_IF_EQUNR],'Brak w SAP') as nvarchar(30))  
 ,[OT32_IF_EQUNR_ALL] =   
  Stuff((SELECT N'; ' + cast(isnull(replace(sub_ot32.[OT32_IF_EQUNR],'0000000000','Niewysłany'),'Brak w SAP') as nvarchar(30))   
  FROM [SAPO_ZWFOT32] sub_ot32 (nolock) where [ZWFOT].OT_ROWID = sub_ot32.[OT32_ZMT_ROWID] FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(max)'),1,2,N'')  
 ,[OT32_ZMT_ROWID]      
 ,[OT32_CCD_DEFAULT]    
  
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
 ,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT32')  
 ,[OT_TYPE]  
 ,[OT_RSTATUS]  
 ,[OT32_RSTATUS] = [OT_RSTATUS]  
 ,[OT_ID]  
 ,[OT_CREUSER]  
 ,[OT_CREUSER_DESC] = dbo.UserName(OT_CREUSER)  
 ,[OT_CREDATE]  
 ,[OT_UPDUSER]  
 ,[OT_UPDUSER_DESC] = dbo.UserName(OT_UPDUSER)  
 ,[OT_UPDDATE]   
 ,[OT_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT32_RC&FID=OT32_LN&FLD=OT32_LN_FORM&A=OT32_LN_FORM&OT32ID=' + cast(OT32_ROWID as nvarchar(50))) + ''',''mywindowtitle'')"   
 title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'  
 ,[OT_LINES_COUNT] = (select COUNT(*) from [ZWFOTLN] (nolock) where isnull(OTL_NOTUSED,0) = 0 and OTL_OTID = OT_ROWID)  
 ,[OT_NR_PM]  
 ,[OT_OBSZAR]  
 ,[OT32LN_MPK_WYDANIA]  
 ,[OT32LN_GDLGRP]  
 ,[OT32LN_GDLGRP_POSKI]  
 ,[OT32LN_GDLGRP_POSKI_DESC] = (select top 1 KL5_DESC from KLASYFIKATOR5 (nolock) where KL5_CODE = [OT32LN_GDLGRP_POSKI])  
 ,[OT32LN_MPK_WYDANIA_POSKI]  
 ,[OT32LN_MPK_WYDANIA_POSKI_DESC] = (select top 1 CCD_DESC from COSTCODE (NOLOCK) where CCD_CODE = [OT32LN_MPK_WYDANIA_POSKI])  
 ,[OT32LN_MPK_PRZYJECIA]  
 ,[OT32LN_MPK_PRZYJECIA_POSKI]  
 ,[OT32LN_MPK_PRZYJECIA_POSKI_DESC] = (select top 1 CCD_DESC from COSTCODE (NOLOCK) where CCD_CODE = [OT32LN_MPK_PRZYJECIA_POSKI])  
 ,[OT32LN_UZYTKOWNIK]  
 ,[OT32LN_UZYTKOWNIK_POSKI]  
 ,[OT32LN_UZYTKOWNIK_POSKI_DESC] = (select top 1 KL5_DESC from KLASYFIKATOR5 (nolock) where KL5_CODE = [OT32LN_UZYTKOWNIK_POSKI])  
  
FROM [dbo].[SAPO_ZWFOT32] (nolock)  
 join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT32_ZMT_ROWID]  
 left join [dbo].[PSP] (nolock) on PSP.PSP_ROWID = [OT_PSPID]  
 left join [dbo].[INVTSK] (nolock) on INVTSK.ITS_ROWID = [OT_ITSID]  
 --left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OT_OBJID]  
 left join (select distinct OT32ln_OT32ID,   
     OT32LN_MPK_WYDANIA,  
     OT32LN_GDLGRP,  
     OT32LN_MPK_WYDANIA_POSKI,  
     OT32LN_GDLGRP_POSKI,  
     OT32LN_MPK_PRZYJECIA,  
     OT32LN_UZYTKOWNIK,  
     OT32LN_MPK_PRZYJECIA_POSKI,  
     OT32LN_UZYTKOWNIK_POSKI   
    from [dbo].[SAPO_ZWFOT32LN]  
    join ZWFOTLN (nolock) on  OT32LN_ZMT_ROWID = OTL_ROWID  
    where OTL_NOTUSED = 0) a on OT32LN_OT32ID = OT32_ROWID  
where   
 [OT32_IF_STATUS] <> 4  
 and [OT_TYPE] = 'SAPO_ZWFOT32'  
GO