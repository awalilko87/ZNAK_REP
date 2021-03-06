SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[SAPO_ZWFOT11v] as
	select 
	
		ANLKL = OT11_ANLKL,
		--ANKL_OPIS = NULL,
		AFASL = '',
		CZY_BUDOWLA = OT11_CZY_BUDOWLA,
		TYP_SKLADNIKA = OT11_TYP_SKLADNIKA,
		--TYP_SKLADNIKA_OPIS = NULL,
		ANLN1 = isnull(OT11_ANLN1,''),
		ANLN2 = isnull(NULL,''),
		INVNR_NAZWA = case when OT11_TYP_SKLADNIKA = 2 then (select convert(nvarchar(50),AST_DESC) from dbo.ASSET where AST_CODE = OT11_ANLN1_POSKI and AST_SUBCODE = '0000') else OT11_INVNR_NAZWA end,
		CZY_NIEMAT = OT11_CZY_NIEMAT,
		CZY_FUND = OT11_CZY_FUND,
		CZY_SKL_POZW = OT11_CZY_SKL_POZW,
		CZY_POZWOL = 0,
		CZY_BUD = OT11_CZY_BUD,
		CZY_FORM = isnull(2, 2),
		CZY_WYD_POZW = OT11_CZY_WYD_POZW,
		CZY_PLAN_POZW = OT11_CZY_PLAN_POZW,
		CZY_BEZ_ZM = OT11_CZY_BEZ_ZM,
		CZY_ROZ_OKR = OT11_CZY_ROZ_OKR,
		SERNR = isnull(OT11_SERNR,''),
		POSNR = isnull(OT11_POSNR,''),
		--POSNR_NAZWA = NULL, 
		ANLN1_INW = isnull(OT11_ANLN1_INW,''),
		ANLN2_INW = '',
		HERST = OT11_HERST,
		LAND1 = OT11_LAND1,
		--LAND1_TXT = NULL,
		KOSTL = OT11_KOSTL,
		--KOSTL_NAZWA = NULL,
		GDLGRP = OT11_GDLGRP,
		--GDLGRP_TXT = NULL,
		MUZYTK = OT11_MUZYTK,
		KFZKZ = '',
		IZWEK = '',
		--IZWEK_OPIS = NULL,
		NAZWA_DOK = OT11_NAZWA_DOK,
		NUMER_DOK = OT11_NUMER_DOK,
		DATA_DOK = convert(nvarchar(10),OT11_DATA_DOK,121),
		WART_NAB_PLN = convert(decimal(30,2),Replace(convert(nvarchar,OT11_WART_NAB_PLN),',','.')), 
		WART_NAB_PLN2 = 0.00,
		WART_REZYDUAL = 0.00,
		MIES_DOST = isnull(OT11_MIES_DOST,''),
		ROK_DOST = isnull(OT11_ROK_DOST,''),
		POTW_DOST = 0,
		PRZEW_OKRES = OT11_PRZEW_OKRES,
		--PRZEW_OKRES_INFO = NULL,
		PAST_AMORT = '',
		OKR_AMORT = 0,
		POWIERZCHNIA = 0.00,
		WOJEWODZTWO = OT11_WOJEWODZTWO,
		--WOJEWODZTWO_NAZWA = NULL,
		PODZ_USL_P = isnull(OT11_PODZ_USL_P,0),
		PODZ_USL_S = isnull(OT11_PODZ_USL_S,0),
		PODZ_USL_B = isnull(OT11_PODZ_USL_B,0),
		PODZ_USL_C = isnull(OT11_PODZ_USL_C,0),
		PODZ_USL_U = isnull(OT11_PODZ_USL_U,0),
		PODZ_USL_H = isnull(OT11_PODZ_USL_H,0),
		NR_PRA_UZYTK = isnull(NULL,''),
		NR_PRA_NAZWA = isnull(NULL,''),
		--KOMP_KAT = NULL,
		--KOMP_PROD = NULL,
		--KOMP_TYP = NULL,
		--KOMP_MODEL = NULL,
		--KOMP_PROC = NULL,
		--KOMP_CZEST = NULL,
		--KOMP_RAM = NULL,
		--KOMP_NRSER = NULL,
		--KOMP_MONITOR = NULL,
		--KOMP_WIELKMON = NULL,
		--KOMP_CZYTPLYT = NULL,
		--KOMP_WLKDYSKU = NULL,
		--KOMP_KARTSIEC = NULL,
		--KOMP_KARTDZWIEK = NULL,
		--KOMP_DRUKARKA = NULL,
		--KOMP_OPIS1 = NULL,
		--KOMP_OPIS2 = NULL,
		--KOMP_OPIS3 = NULL,
		BRANZA = isnull(OT11_BRANZA,''),
		--BRANZA_OPIS = NULL,
		NR_TECHNOL = isnull(ZMT_OBJ_CODE,''),
		WART_FUND = 0.00,
		--ZZ_NR_FORM = NULL,
		--ZZ_TYP_DOK = NULL,
		--ZZ_POZ_FORM = NULL,
		--ZZ_NR_DOK = NULL,
		--ZZ_ANLN1_INW = NULL,
		--ZZ_ANLN2_INW = NULL,
		--ZZ_DATA_WYD_DEC = NULL,
		--ZZ_DATA_UPRA_DEC = NULL,
		--ZZ_DATA_ZGL = NULL,
		--ZZ_DATA_UPRA_ZGL = NULL,
		--ZZ_PLAN_DAT_DEC = NULL,
		--ZZ_PLAN_DATA_ZGL = NULL,
		AUFNR = '',
		KROK = OT11_KROK,
		BUKRS = OT11_BUKRS,
		WYST_SAPUSER = OT11_SAPUSER, 
		WYST_NAME = OT11_IMIE_NAZWISKO,
		ZMT_OBJ_CODE = isnull(ZMT_OBJ_CODE,''),
		s.OT11_ROWID,
		OT11_IF_STATUS,
		OT11_IF_SENTDATE, 
		OT11_IF_EQUNR,
		ZZ_PLAN_DAT_DEC=convert(nvarchar(10),OT11_ZZ_PLAN_DAT_DEC,121), --isnull (OT11_ZZ_PLAN_DAT_DEC,''),
		ZZ_PLAN_DATA_ZGL=convert(nvarchar(10),OT11_ZZ_PLAN_DATA_ZGL,121), --isnull (OT11_ZZ_PLAN_DATA_ZGL,''),
		ZZ_DATA_WYD_DEC=convert(nvarchar(10),OT11_ZZ_DATA_WYD_DEC,121), --isnull (OT11_ZZ_DATA_WYD_DEC,''),
		ZZ_DATA_UPRA_DEC=convert(nvarchar(10),OT11_ZZ_DATA_UPRA_DEC,121), --isnull (OT11_ZZ_DATA_UPRA_DEC,''),
		ZZ_DATA_UPRA_ZGL=convert(nvarchar(10),OT11_ZZ_DATA_UPRA_ZGL,121), --isnull (OT11_ZZ_DATA_UPRA_ZGL,''),
		UDF01=isnull (OT11_UDF01,''),
		UDF02=isnull (OT11_UDF02,''),
		UDF03=isnull (OT11_UDF03,''),
		UDF04=isnull (OT11_UDF04,''),
		UDF05=isnull (OT11_UDF05,''),
		UDF06=isnull (OT11_UDF06,''),
		UDF07=isnull (OT11_UDF07,''),
		UDF08=isnull (OT11_UDF08,''),
		UDF09=isnull (OT11_UDF09,''),
		UDF10=isnull (OT11_UDF10,'')	
from dbo.SAPO_ZWFOT11 s (nolock)
GO