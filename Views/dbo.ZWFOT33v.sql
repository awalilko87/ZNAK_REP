SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT33v]        
as        
SELECT         
        
 [OT33_ROWID]        
 ,[OT33_KROK]        
 ,[OT33_BUKRS]        
 ,[OT33_SAPUSER]        
 ,[OT33_IMIE_NAZWISKO]        
 ,[OT33_MTOPER]        
 ,[OT33_IF_STATUS]        
 ,[OT33_IF_SENTDATE]         
 ,[OT33_IF_EQUNR] =  cast(isnull([OT33_IF_EQUNR],'Brak w SAP') as nvarchar(30))        
 ,[OT33_IF_EQUNR_ALL] =         
  Stuff((SELECT N'; ' + cast(isnull(replace(sub_ot33.[OT33_IF_EQUNR],'0000000000','Niewysłany'),'Brak w SAP') as nvarchar(30))         
  FROM [SAPO_ZWFOT33] sub_ot33 (nolock) where [ZWFOT].OT_ROWID = sub_ot33.[OT33_ZMT_ROWID] FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(max)'),1,2,N'')        
 ,[OT33_ZMT_ROWID]            
        
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
 ,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT33')        
 ,[OT_TYPE]        
 ,[OT_RSTATUS]        
 ,[OT33_RSTATUS] = [OT_RSTATUS]        
 ,[OT_ID]        
 ,[OT_CREUSER]        
 ,[OT_CREUSER_DESC] = dbo.UserName(OT_CREUSER)        
 ,[OT_CREDATE]        
 ,[OT_UPDUSER]        
 ,[OT_UPDUSER_DESC] = dbo.UserName(OT_UPDUSER)        
 ,[OT_UPDDATE]         
    ,[OT_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT33_RC&FID=OT33_LN&FLD=OT33_LN_FORM&A=OT33_LN_FORM&OT33ID=' + cast(OT33_ROWID as nvarchar(50))) + ''',''mywindowtitle'')"         
 title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'        
              
    ,[OT_DON_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT33_RC&FID=OT33_DON&FLD=OT33_DON_FORM&A=OT33_DON_FORM&OT33ID=' + cast(OT33_ROWID as nvarchar(50))) + ''',''mywindowtitle'')"         
  title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'        
 ,[OT_LINES_COUNT] = (select COUNT(*) from [ZWFOTLN] (nolock) where isnull(OTL_NOTUSED,0) = 0 and OTL_OTID = OT_ROWID)        
 ,[OT_NR_PM]        
 ,[OT_OBSZAR] 
 ,[OT_COSTCODEID]        
 ,[OT33LN_MPK_WYDANIA]        
 ,[OT33LN_GDLGRP]        
 ,[OT33LN_GDLGRP_POSKI]        
 ,[OT33LN_GDLGRP_POSKI_DESC] = (select top 1 KL5_DESC from KLASYFIKATOR5 (nolock) where KL5_CODE = [OT33LN_GDLGRP_POSKI])        
 ,[OT33LN_MPK_WYDANIA_POSKI]        
 ,[OT33LN_MPK_WYDANIA_POSKI_DESC] = (select top 1 CCD_DESC from COSTCODE (NOLOCK) where CCD_CODE = [OT33LN_MPK_WYDANIA_POSKI])        
 ,[OT33_CZY_BEZ_ZM]        
 ,[OT33_CZY_ROZ_OKR]        
 ,[OT33_TOSTNID]       
 ,[CZY_Z_PROTOKOLU] = (select 1 from dbo.[OBJTECHPROTLN] (nolock) where POL_OT33ID = OT33_ROWID)         
 ,[OT33_POTID]         
FROM [dbo].[SAPO_ZWFOT33] (nolock)        
 join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT33_ZMT_ROWID]        
 left join [dbo].[PSP] (nolock) on PSP.PSP_ROWID = [OT_PSPID]        
 left join [dbo].[INVTSK] (nolock) on INVTSK.ITS_ROWID = [OT_ITSID]        
 --left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OT_OBJID]        
 left join (select distinct OT33ln_OT33ID,         
     OT33LN_MPK_WYDANIA,        
     OT33LN_GDLGRP,        
     OT33LN_MPK_WYDANIA_POSKI,        
     OT33LN_GDLGRP_POSKI        
    from [dbo].[SAPO_ZWFOT33LN]        
    join ZWFOTLN (nolock) on  OT33LN_ZMT_ROWID = OTL_ROWID        
    where OTL_NOTUSED = 0) a on OT33LN_OT33ID = OT33_ROWID        
where         
 [OT33_IF_STATUS] <> 4        
 and [OT_TYPE] = 'SAPO_ZWFOT33' 
GO