﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ASSETv]
as
select
  AST_ROWID
, AST_CODE
, AST_SUBCODE
, AST_BARCODE
, AST_ORG
, AST_DESC
, AST_NOTE
, AST_DATE
, AST_TIME = (dbo.e2_im_gettimefromdatetime(isnull(AST_DATE,'1990-01-01')))
, AST_STATUS
, AST_STATUS_DESC = (select STA_DESC from dbo.STA (nolock) where STA_ENTITY = 'AST' and STA_CODE = AST_STATUS) --sta.DES_TEXT
, AST_TYPE = (case when (left(AST_CODE,1) = '3') then 'W' else 'OT' end)
, AST_TYPE_DESC = NULL--(select TYP_DESC from dbo.TYP (nolock) where TYP_ENTITY = 'AST' and TYP_CODE = AST_STATUS) --typ1.DES_TEXT
, AST_TYPE2 = NULL
, AST_TYPE2_DESC = NULL--(select TYP2.TYP2_DESC from TYP2 (nolock) join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = AST_TYPE2 and TYP_ENTITY = 'AST')--typ2.DES_TEXT
, AST_TYPE3 = NULL
, AST_TYPE3_DESC = NULL--(select TYP3.TYP3_DESC from TYP3 (nolock) join TYP2 (nolock) on TYP2.TYP2_ROWID = TYP3.TYP3_TYP2ID join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP3.TYP3_CODE = AST_TYPE3 and TYP_ENTITY = 'AST')--typ3.DES_TEXT
, AST_RSTATUS
, AST_CREUSER
, AST_CREUSER_DESC = dbo.UserName(AST_CREUSER)
, AST_CREDATE
, AST_UPDUSER
, AST_UPDUSER_DESC = dbo.UserName(AST_UPDUSER)
, AST_UPDDATE
, AST_NOTUSED
, AST_ID
, AST_CCDID = CCD_ROWID
, AST_CCD = CCD_CODE
, AST_CCD_DESC = CCD_DESC

, AST_STNID = STN_ROWID
, AST_STN = STN_CODE
, AST_STN_DESC = STN_DESC
 
, AST_TEXT1
, AST_TEXT2
, AST_TEXT3 --Charakterystyka opisowa składnika 
, AST_BUYVALUE --Wartość składnika

, AST_TXT01
, AST_TXT02
, AST_TXT03
, AST_TXT04
, AST_TXT05
, AST_TXT06
, AST_TXT07
, AST_TXT08
, AST_TXT09
, AST_NTX01
, AST_NTX02
, AST_NTX03
, AST_NTX04
, AST_NTX05
, AST_COM01
, AST_COM02
, AST_DTX01
, AST_DTX02
, AST_DTX03
, AST_DTX04
, AST_DTX05

, AST_PSP--Kod elementu PSP
, AST_CCTID
, AST_CCT_DESC = (select CCT_DESC from COSTCENTER (nolock) where CCT_ROWID = AST_CCTID)
, AST_SAP_Active
, AST_SAP_BUKRS
, AST_SAP_ANLN1
, AST_SAP_ANLN2
, AST_SAP_ANLKL
, AST_SAP_GEGST
, AST_SAP_ERNAM
, AST_SAP_ERDAT
, AST_SAP_AENAM
, AST_SAP_AEDAT
, AST_SAP_KTOGR
, AST_SAP_ANLTP
, AST_SAP_ZUJHR
, AST_SAP_ZUPER
, AST_SAP_ZUGDT
, AST_SAP_AKTIV
, AST_SAP_ABGDT
, AST_SAP_DEAKT
, AST_SAP_GPLAB = NULL
, AST_SAP_BSTDT = NULL
, AST_SAP_ORD41 = NULL
, AST_SAP_ORD42 = NULL
, AST_SAP_ORD43 = NULL
, AST_SAP_ORD44 = NULL
, AST_SAP_ANEQK = NULL
, AST_SAP_LIFNR = NULL
, AST_SAP_LAND1 = NULL
, AST_SAP_LIEFE = NULL
, AST_SAP_HERST
, AST_SAP_EIGKZ = NULL
, AST_SAP_URWRT = NULL
, AST_SAP_ANTEI = NULL
, AST_SAP_MEINS = NULL
, AST_SAP_MENGE = NULL
, AST_SAP_VMGLI = NULL
, AST_SAP_XVRMW = NULL
, AST_SAP_WRTMA = NULL
, AST_SAP_EHWRT = NULL
, AST_SAP_STADT = NULL
, AST_SAP_GRUFL = NULL
, AST_SAP_VBUND = NULL
, AST_SAP_SPRAS = NULL
, AST_SAP_TXT50
, AST_SAP_KOSTL
, AST_SAP_WERKS = NULL
, AST_SAP_GSBER = NULL
, AST_SAP_POSNR
, AST_SAP_GDLGRP  
, AST_SAP_DOC_IDENT 
, AST_SAP_DOC_NUM
, AST_SAP_DOC_YEAR
, AST_SAP_DATA_WYST 
, AST_SAP_OSOBA_WYST

, OBG_DESC

, AST_LANGID = 'PL'--[LangID]
FROM dbo.ASSET (nolock)
join KLASYFIKATOR5 (nolock) on KL5_ROWID = AST_KL5ID
join COSTCODE (nolock) on CCD_ROWID = AST_CCDID
--join STATION (nolock) on STN_CCDID = CCD_ROWID and STN_KL5ID = KL5_ROWID --and STN_TYPE = 'STACJA'
cross apply (select top 1 STN_ROWID, STN_CODE, STN_DESC = case when STN_TYPE = 'SERWIS' then 'Serwis' else STN_DESC end from dbo.STATION where STN_KL5ID = KL5_ROWID)s
left join OBJGROUP on OBG_ROWID = AST_OBJGROUPID
where AST_SAP_Active = 1
GO