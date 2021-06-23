SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[SAPO_ZWFOT12v] as
 
	select 
		BUKRS = OT12_BUKRS,
		DATA_WYST = convert(nvarchar(10),isnull(OT12_DATA_WYST,GETDATE()),121),
		DOC_NUM = OT12_DOC_NUM,
		WYST_SAPUSER = OT12_SAPUSER,
		WYST_NAME = OT12_IMIE_NAZWISKO, 
		MUZYTK= left(OT12_MUZYTK,20),
		KOSTL = OT12_KOSTL,
		GDLGRP = isnull(OT12_GDLGRP,''),
		SERNR = isnull(OT12_SERNR,''),
		POSNR = isnull(OT12_POSNR,''),
		HERST = OT12_HERST,
		NR_DOW_DOST = isnull(OT12_NR_DOW_DOST,''),
		DATA_DOST = convert(nvarchar(10),isnull(OT12_DATA_DOST,GETDATE()),121),
		MIES_DOST = isnull(OT12_MIES_DOST,month(getdate())),
		ROK_DOST = isnull(OT12_ROK_DOST,year(getdate())),
		PRZEW_OKRES = isnull(OT12_PRZEW_OKRES,0),
		WOJEWODZTWO = OT12_WOJEWODZTWO,
		NR_TECHNOL = isnull(ZMT_OBJ_CODE,''),
		WART_TOTAL = convert(numeric(13,2),Replace(convert(nvarchar,isnull(OT12_WART_TOTAL,0)),',','.')), 
		--convert(money,Replace(convert(nvarchar,OT12_WART_TOTAL),',','.')),
		ANLKL = isnull(OT12_ANLKL,''),
		PODZ_USL_P = isnull(OT12_PODZ_USL_P,0),
		OT12_PODZ_USL_P,
		PODZ_USL_S = isnull(OT12_PODZ_USL_S,0),
		PODZ_USL_B = isnull(OT12_PODZ_USL_B,0),
		PODZ_USL_C = isnull(OT12_PODZ_USL_C,0),
		PODZ_USL_U = isnull(OT12_PODZ_USL_U,0),
		PODZ_USL_H = isnull(OT12_PODZ_USL_H,0),
		CZY_FORM = case when OT12_CZY_FORM = '1' then 'T' else 'N' end ,		 
		ZZ_NR_FORM = OT12_ZZ_NR_FORM,
		ZZ_TYP_DOK = OT12_ZZ_TYP_DOK,
		ZZ_POZ_FORM = OT12_ZZ_POZ_FORM,
		ZZ_NR_DOK = OT12_ZZ_NR_DOK,
		s.OT12_ROWID,
		OT12_IF_STATUS,
		OT12_IF_SENTDATE, 
		OT12_IF_EQUNR
 
	from dbo.SAPO_ZWFOT12 s (nolock)
   
 --exec dbo.SAPO_OT12
  




GO