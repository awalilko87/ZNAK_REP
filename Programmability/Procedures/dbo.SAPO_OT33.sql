SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPO_OT33] 
as
begin

	declare @id_33 int
	declare @v_ret tinyint

	Select top 1 @id_33 = OT33_ROWID from SAPO_ZWFOT33 where OT33_IF_STATUS = 1 order  by OT33_ROWID asc

	exec @v_ret = dbo.SAPO_ErrorSend_Proc 'OT33', @id_33

	if @v_ret = 1
	begin
		set @id_33 = null
	end

	--HEADER
	select 
		KROK,
		BUKRS,
		right(WYST_SAPUSER, 12) as WYST_SAPUSER,
		WYST_NAME,
		MTOPER,
CZY_BEZ_ZM,CZY_ROZ_OKR
	from dbo.SAPO_ZWFOT33v (nolock) where OT33_ROWID = @id_33

	--POS
	select 
		LP,
		BUKRS,
		ANLN1,
		TXT50,
		UZASADNIENIE,
		convert(nvarchar(10),DT_WYDANIA,121)	DT_WYDANIA,
		MPK_WYDANIA,
		GDLGRP
	from dbo.SAPO_ZWFOT33LNv (nolock) where OT33LN_OT33ID = @id_33
	
	--PARTS
	select 
		ANLN2,
		TXT50,
		WARST=COALESCE(WARST,0.00),
		NDJARPER,
		MTOPER,
		ANLN1_DO,
		ANLN2_DO,
		ANLKL_DO,
		KOSTL_DO,
		UZYTK_DO,
		PRAC_DO,
		PRCNT_DO,
		WARST_DO,
		TXT50_DO,
		NDPER_DO,
		CHAR_DO,
		BELNR
	from dbo.SAPO_ZWFOT33DONv (nolock) where OT33DON_OT33ID = @id_33

	--CHARAKTER
	select 
		LP,
		ANLN2,
		METAL,
		KATALIZATOR,
		METAL_OPIS,
		WSK_IL_METAL,
		convert(decimal(25,2),IsNull(MENGE,0))	MENGE,
		MEINS,
		RODZ_IL_METAL,
		WSK_KW_METAL,
		KW_METAL,
		RODZ_KW_METAL,
		ZRODLO,
		OPIS,
		convert(nvarchar(10),AEDAT,121)	AEDAT,
		convert(nvarchar(8),AEZET) AEZET,
		AENAM,
		ZAL,
		convert(decimal(25,2),IsNull(ILOSC_NOWA,0))		ILOSC_NOWA,
		convert(decimal(25,2),IsNull(KW_NOWA,0))		KW_NOWA
	from dbo.SAPO_ZWFOT33CHARv (nolock) where OT33CHAR_OT33ID = @id_33

	select 
		TDFORMAT, 
		TDLINE = '<![CDATA['+TDLINE+']]>'
	from dbo.SAPO_ZWFOT33COMv (nolock) where OT33COM_OT33ID = @id_33
	return
end
GO