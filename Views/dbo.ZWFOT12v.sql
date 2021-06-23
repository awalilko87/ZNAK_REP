SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT12v]  
as  
SELECT   
  
 [OT12_ROWID]  
 ,[OT12_KROK]  
 ,[OT12_BUKRS]  
 ,[OT12_DATA_WYST]  
 ,[OT12_DOC_NUM]  
 ,[OT12_SAPUSER]  
 ,[OT12_IMIE_NAZWISKO]  
 ,[OT12_MUZYTKID]  
 ,[OT12_MUZYTK]  
 ,[OT12_KOSTL]  
 ,[OT12_KOSTL_POSKI]  
 ,[OT12_GDLGRP]  
 ,[OT12_GDLGRP_POSKI]  
 ,[OT12_SERNR]  
 ,[OT12_SERNR_POSKI]   
 ,[OT12_POSNR]  
 ,[OT12_POSNR_POSKI]  
 ,[OT12_HERST]  
 ,[OT12_HERST_POSKI]  
 ,[OT12_NR_DOW_DOST]  
 ,[OT12_DATA_DOST] = convert(datetime,cast([OT12_ROK_DOST]as nvarchar) + '-' + cast( [OT12_MIES_DOST] as nvarchar) + '-01')  
 ,[OT12_MIES_DOST]  
 ,[OT12_ROK_DOST]  
 ,[OT12_PRZEW_OKRES]  
 ,[OT12_WOJEWODZTWO]  
 ,[OT12_NR_TECHNOL]  
 ,[OT12_WART_TOTAL]  
 ,[OT12_ANLKL]  
 ,[OT12_ANLKL_POSKI]  
 ,[OT12_IF_STATUS]  
 ,[OT12_IF_SENTDATE]   
 ,[OT12_IF_EQUNR]  = cast(isnull([OT12_IF_EQUNR],'Brak w SAP') as nvarchar(30))  
 ,[OT12_IF_EQUNR_ALL] =   
  Stuff((SELECT N'; ' + cast(isnull(replace(sub_ot12.[OT12_IF_EQUNR],'0000000000','Niewysłany'),'Brak w SAP') as nvarchar(30))   
  FROM [SAPO_ZWFOT12] sub_ot12 (nolock) where [ZWFOT].OT_ROWID = sub_ot12.[OT12_ZMT_ROWID] FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(max)'),1,2,N'')  
 ,[OT12_ZMT_ROWID]      
 ,[ZMT_OBJ_CODE] --tylko dla konkretnego dokuemntu w SAP  
 ,[OT12_PODZ_USL_P]  
 ,[OT12_PODZ_USL_S]  
 ,[OT12_PODZ_USL_B]  
 ,[OT12_PODZ_USL_C]  
 ,[OT12_PODZ_USL_U]  
 ,[OT12_PODZ_USL_H]  
 ,[OT12_CZY_FORM]  
 ,[OT12_ZZ_NR_FORM]    
 ,[OT12_ZZ_TYP_DOK]  
 ,[OT12_ZZ_POZ_FORM]  
 ,[OT12_ZZ_NR_DOK]  
  
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
 ,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT12')  
 ,[OT_TYPE]  
 ,[OT_RSTATUS]  
 ,[OT12_RSTATUS] = [OT_RSTATUS]  
 ,[OT_ID]  
 ,[OT_CREUSER]  
 ,[OT_CREUSER_DESC] = dbo.UserName(OT_CREUSER)  
 ,[OT_CREDATE]  
 ,[OT_UPDUSER]  
 ,[OT_UPDUSER_DESC] = dbo.UserName(OT_UPDUSER)  
 ,[OT_UPDDATE]   
 ,[OT_LINES_LINK] = '<a href="javascript:Simple_Popup(''' +  dbo.VS_EncryptLink('/Forms/SimplePopup.aspx/?WHO=OT12_RC&FID=OT12_LN&FLD=OT12_LN_FORM&A=OT12_LN_FORM&OT12ID=' + cast(OT12_ROWID as nvarchar(50))) + ''',''mywindowtitle'')"   
 title="Wyświetl linie dla dokumentu"><img src="/Images/32x32/zoom%20in.png" border="none" type="image" width="50" height="50"/></a>'  
 ,[OT_LINES_COUNT] = (select COUNT(*) from [ZWFOTLN] (nolock) where isnull(OTL_NOTUSED,0) = 0 and OTL_OTID = OT_ROWID)  
 ,[OT_ATTACH_ICO]   = case when exists (select 1  from dbo.SYFiles (nolock)        
inner join dbo.DOCENTITIES (nolock) on [FileID2] = DAE_DOCUMENT        
where dae_entity = 'POT' and OT_CODE+'#'+OT_ORG = DAE_CODE) then 1 else 0 end 

FROM [dbo].[SAPO_ZWFOT12] (nolock)  
 join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT12_ZMT_ROWID]  
 left join [dbo].[PSP] (nolock) on PSP.PSP_ROWID = [OT_PSPID]  
 left join [dbo].[INVTSK] (nolock) on INVTSK.ITS_ROWID = [OT_ITSID]  
 --left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OT_OBJID]  
where   
 [OT12_IF_STATUS] <> 4  
 and [OT_TYPE] = 'SAPO_ZWFOT12'  
    
     
  
 ----,[OT12_TYP_SKLADNIKA]  
 ----,[OT12_CZY_BUD]    
 ----,[OT12_ANLN1_INW]  
 ----,[OT12_ANLN1]  
 ----,[OT12_INVNR_NAZWA]  
 ----,[OT12_CZY_FUND]  
 ----,[OT12_CZY_SKL_POZW]  
 ----,[OT12_CZY_NIEMAT]   
 ----,[OT12_LAND1]     
 ----,[OT12_NAZWA_DOK]  
 ----,[OT12_NUMER_DOK]  
 ----,[OT12_DATA_DOK]  
 ----,[OT12_WART_NAB_PLN]    
 ----,[OT12_BRANZA]   
 ----,[OT12_CZY_BUDOWLA]  
 ----,[ZMT_OBJ_CODE] --tylko dla konkretnego dokuemntu w SAP  
  
 --Potwierdzenie dostarczenia składnika ZWFOT12_REALIZATOR-CZY_FORM  
 --Numer formularza ZWFOT12_REALIZATOR-_NR_FORM  
 --Typ dokumentu ZWFOT12_REALIZATOR-TYP_DOK  
 --Pozycja formularza ZWFOT12_REALIZATOR-POZ_FORM  
 --Numer dokumentu ZWFOT12_REALIZATOR-NR_DOK  
  
 --Nr dowodu dostawy ZWFOT12_REALIZATOR-NR_DOW_DOST  
 --Data dostawy ZWFOT12_REALIZATOR-DATA_DOST  
 --Numer technologliczny ZWFOT12_REALIZATOR-NR_TECHNOL  
  
  
  
   
  
  
  
GO