SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT31v]  
as  
SELECT   
 [OT31_ROWID]  
 ,[OT31_KROK]  
 ,[OT31_BUKRS]  
 ,[OT31_SAPUSER]  
 ,[OT31_IMIE_NAZWISKO]  
 ,[OT31_IF_STATUS]  
 ,[OT31_IF_SENTDATE]   
 ,[OT31_IF_EQUNR]  = cast(isnull([OT31_IF_EQUNR],'') as nvarchar(30))  
 ,[OT31_IF_EQUNR_ALL] =   
  Stuff((SELECT N'; ' + cast(isnull(replace(sub_ot31.[OT31_IF_EQUNR],'0000000000','Niewysłany'),'Brak w SAP') as nvarchar(30))   
  FROM [SAPO_ZWFOT31] sub_ot31 (nolock) where [ZWFOT].OT_ROWID = sub_ot31.[OT31_ZMT_ROWID] FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(max)'),1,2,N'')  
 ,[OT31_ZMT_ROWID]   
 ,[OT31_CCD_DEFAULT]     
  
 --dane nagłówka  
 ,[OT_ROWID]  
 ,[OT_SRQID]  
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
 ,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT31')  
 ,[OT_TYPE]  
 ,[OT_RSTATUS]  
 ,[OT31_RSTATUS] = [OT_RSTATUS]  
 ,[OT_ID]  
 ,[OT_CREUSER]  
 ,[OT_CREUSER_DESC] = dbo.UserName(OT_CREUSER)  
 ,[OT_CREDATE]  
 ,[OT_UPDUSER]  
 ,[OT_UPDUSER_DESC] = dbo.UserName(OT_UPDUSER)  
 ,[OT_UPDDATE]  
 ,[OT_NR_PM]  
 ,[OT_OBSZAR]  
 ,[OT_COSTCODEID]  
 ,[OT31LN_MPK_WYDANIA]  
 ,[OT31LN_GDLGRP]  
 ,[OT31LN_GDLGRP_POSKI]  
 ,[OT31LN_GDLGRP_POSKI_DESC] = (select top 1 KL5_DESC from KLASYFIKATOR5 (nolock) where KL5_CODE = [OT31LN_GDLGRP_POSKI])  
 ,[OT31LN_MPK_WYDANIA_POSKI]  
 ,[OT31LN_MPK_WYDANIA_POSKI_DESC] = (select top 1 CCD_DESC from COSTCODE (NOLOCK) where CCD_CODE = [OT31LN_MPK_WYDANIA_POSKI])  
 ,[OT31LN_MPK_PRZYJECIA]  
 ,[OT31LN_MPK_PRZYJECIA_POSKI]  
 ,[OT31LN_MPK_PRZYJECIA_POSKI_DESC] = (select top 1 CCD_DESC from COSTCODE (NOLOCK) where CCD_CODE = [OT31LN_MPK_PRZYJECIA_POSKI])  
 ,[OT31LN_UZYTKOWNIK]  
 ,[OT31LN_UZYTKOWNIK_POSKI]  
 ,[OT31LN_UZYTKOWNIK_POSKI_DESC] = (select top 1 KL5_DESC from KLASYFIKATOR5 (nolock) where KL5_CODE = [OT31LN_UZYTKOWNIK_POSKI])  
   
  
 --<a href="javascript:window.open('document.aspx','mywindowtitle','width=500,height=150')">open window</a>  
 --,[OT_LINES_LINK] = '<a href="'+ dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT31_RC&FID=OT31_LN&FLD=OT31_LN_FORM&A=OT31_LN_FORM&OT_ID=' + cast(OT_ID as nvarchar(50))) + '"  
 --   title="Wyświetl linie dla dokumentu" target="_blank"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'  
 ,[OT_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT31_RC&FID=OT31_LN&FLD=OT31_LN_FORM&A=OT31_LN_FORM&OT31ID=' + cast(OT31_ROWID as nvarchar(50))) + ''',''mywindowtitle'')"   
   title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'  
 ,[OT_LINES_COUNT] = (select COUNT(*) from [ZWFOTLN] (nolock) where isnull(OTL_NOTUSED,0) = 0 and OTL_OTID = OT_ROWID)  
   
FROM [dbo].[SAPO_ZWFOT31] (nolock)  
join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT31_ZMT_ROWID]  
left join [dbo].[PSP] (nolock) on [PSP].[PSP_ROWID] = [OT_PSPID]  
left join [dbo].[INVTSK] (nolock) on INVTSK.ITS_ROWID = [OT_ITSID]  
--left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OT_OBJID]  
left join (select distinct OT31ln_OT31ID,   
    OT31LN_MPK_WYDANIA,  
    OT31LN_GDLGRP,  
    OT31LN_MPK_WYDANIA_POSKI,  
    OT31LN_GDLGRP_POSKI,  
    OT31LN_MPK_PRZYJECIA,  
    OT31LN_UZYTKOWNIK,  
    OT31LN_MPK_PRZYJECIA_POSKI,  
    OT31LN_UZYTKOWNIK_POSKI   
   from [dbo].[SAPO_ZWFOT31LN]  
   join ZWFOTLN (nolock) on  OT31LN_ZMT_ROWID = OTL_ROWID  
   where OTL_NOTUSED = 0) a on OT31LN_OT31ID = OT31_ROWID  
where [OT31_IF_STATUS] <> 4   
and [OT_TYPE] = 'SAPO_ZWFOT31'
GO