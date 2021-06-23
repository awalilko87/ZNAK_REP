SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT11_HISTv]  
as  
SELECT   
 [OT11_ROWID]  
 ,[OT11_KROK]  
 ,[OT11_BUKRS]  
 ,[OT11_IMIE_NAZWISKO]  
 ,[OT11_TYP_SKLADNIKA]  
 ,[OT11_CZY_BUD]  
 ,[OT11_SERNR]  
 ,[OT11_POSNR]  
 ,[OT_PSP] = (select PSP_CODE from PSP where PSP_SAP_PSPNR = OT11_POSNR)
 ,[OT11_ANLN1_INW]  
 ,[OT11_ANLN1]  
 ,[OT11_INVNR_NAZWA]  
 ,[OT11_CZY_FUND]  
 ,[OT11_CZY_SKL_POZW]  
 ,[OT11_CZY_NIEMAT]  
 ,[OT11_HERST]  
 ,[OT11_LAND1]  
 ,[OT11_KOSTL]  
 ,[OT11_GDLGRP]  
 ,[OT11_MUZYTK]  
 ,[OT11_MUZYTKID]  
 ,[OT11_NAZWA_DOK]  
 ,[OT11_NUMER_DOK]  
 ,[OT11_DATA_DOK]  
 ,[OT11_WART_NAB_PLN]  
 ,[OT11_PRZEW_OKRES]  
 ,[OT11_WOJEWODZTWO]  
 ,[OT11_BRANZA]  
 ,[OT11_ANLKL]  
 ,[OT11_CZY_BUDOWLA]  
 ,[OT11_IF_STATUS]  
 ,[OT11_IF_SENTDATE]  
 ,[OT11_IF_EQUNR]  
 ,[OT11_ZMT_ROWID]  
 ,[OT11_SAPUSER]  
 ,[OT11_MIES_DOST]  
 ,[OT11_ROK_DOST]  
 ,[OT11_DATA_DOST] = convert(datetime,cast([OT11_ROK_DOST]as nvarchar) + '-' + cast( [OT11_MIES_DOST] as nvarchar) + '-01')  
 ,[ZMT_OBJ_CODE]  
 ,[OT11_PODZ_USL_P]  
 ,[OT11_PODZ_USL_S]  
 ,[OT11_PODZ_USL_B]  
 ,[OT11_PODZ_USL_C]  
 ,[OT11_PODZ_USL_U]  
 ,[OT11_PODZ_USL_H]  
 ,[OT11_CHAR]    
 ,[OT_ROWID]  
 --,[OT_OBJID]  
 ,[OT_CODE]  
 ,[OT_ORG]  
 ,[OT_STATUS]  
 ,[OT_STATUS_DESC] = (select STA_DESC from STA (nolock) where STA_CODE = [OT_STATUS] and STA_ENTITY = 'OT11')  
 ,[OT_TYPE]  
 ,[OT_RSTATUS] = 1  
 ,[OT11_RSTATUS] = 1  
 ,[OT_ID]  
 ,[OT_CREUSER]  
 ,[OT_CREUSER_DESC] = dbo.UserName(OT_UPDUSER)  
 ,[OT_CREDATE]  
 ,[OT_UPDUSER]  
 ,[OT_UPDUSER_DESC] = dbo.UserName(OT_UPDUSER)  
 ,[OT_UPDDATE]  
--, alter table [dbo].[SAPO_ZWFOT11] add [OT11_CODE] nvarchar(30)  
FROM [dbo].[SAPO_ZWFOT11]  
 join [dbo].[ZWFOT] (nolock) on [ZWFOT].OT_ROWID = [OT11_ZMT_ROWID]  
where   
 --[OT11_IF_STATUS] = 4 and  
  [OT_TYPE] = 'SAPO_ZWFOT11'  
    
    
GO