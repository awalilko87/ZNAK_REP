SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPO_OT11]
as
begin

	declare @id_11 int
	declare @v_ret tinyint

	Select top 1 @id_11 = OT11_ROWID from SAPO_ZWFOT11 where OT11_IF_STATUS = 1 
	and OT11_ROWID not in (17) -- TEMP RM problematyczny dokument
	order  by OT11_ROWID asc

	-- repo test

	exec @v_ret = dbo.SAPO_ErrorSend_Proc 'OT11', @id_11

	if @v_ret = 1
	begin
		set @id_11 = null
	end
	
--   Select * from SAPO_ZWFOT11 where OT11_IF_STATUS = 1 
--   select * from ZWFOT11v

	select 
		ANLKL,
		AFASL,
		CZY_BUDOWLA,
		TYP_SKLADNIKA,
		ANLN1,
		ANLN2,
		INVNR_NAZWA,
		CZY_NIEMAT,
		CZY_FUND,
		CZY_SKL_POZW,
		CZY_POZWOL,
		CZY_BUD,
		CZY_FORM,
		CZY_WYD_POZW,
		CZY_PLAN_POZW,
		CZY_BEZ_ZM,
		CZY_ROZ_OKR,
		SERNR,
		POSNR,
		ANLN1_INW,
		ANLN2_INW,
		HERST,
		LAND1,
		KOSTL,
		GDLGRP,
		MUZYTK,
		KFZKZ,
		IZWEK,
		NAZWA_DOK,
		NUMER_DOK,
		DATA_DOK,
		WART_NAB_PLN,
		WART_NAB_PLN2,
		WART_REZYDUAL,
		MIES_DOST,
		ROK_DOST,
		POTW_DOST,
		PRZEW_OKRES,
		PAST_AMORT,
		OKR_AMORT,
		POWIERZCHNIA,
		WOJEWODZTWO,
		PODZ_USL_P,
		PODZ_USL_S,
		PODZ_USL_B,
		PODZ_USL_C,
		PODZ_USL_U,
		PODZ_USL_H,
		NR_PRA_UZYTK,
		NR_PRA_NAZWA,
		BRANZA,
		NR_TECHNOL,
		WART_FUND,
		AUFNR,
		KROK,
		BUKRS,
		WYST_SAPUSER,
		WYST_NAME,
		ZMT_OBJ_CODE,
		ZZ_PLAN_DAT_DEC,
		ZZ_PLAN_DATA_ZGL,
		ZZ_DATA_WYD_DEC,
		ZZ_DATA_UPRA_DEC,
		ZZ_DATA_UPRA_ZGL,
		UDF01,
		UDF02,
		UDF03,
		UDF04,
		UDF05,
		UDF06,
		UDF07,
		UDF08,
		UDF09,
		UDF10
	from dbo.SAPO_ZWFOT11v where OT11_ROWID = @id_11
 
	select top 1
		TDFORMAT,-- = 'T', 
		TDLINE-- = '_'
	from dbo.SAPO_ZWFOT11COMv  where OT11COM_OT11ID = @id_11

 	/*select  
		TDFORMAT, 
		TDLINE = '<![CDATA['+TDLINE+']]>'
	from dbo.SAPO_ZWFOT11CHARv where OT11CHAR_OT11ID = @id_11 */

	select
		 TDFORMAT = 'T'
		,TDLINE = TXT
	from dbo.SAPO_ZWFOT11
	cross apply dbo.SAPO_COMMENT_Split(OT11_CHAR, 132)
	where OT11_ROWID = @id_11
 
	return
end
GO