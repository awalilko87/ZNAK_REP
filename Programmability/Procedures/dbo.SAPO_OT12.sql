SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPO_OT12] 
as
begin

	declare @id_12 int
	declare @v_ret tinyint

	Select top 1 @id_12 = OT12_ROWID from SAPO_ZWFOT12 where OT12_IF_STATUS = 1 order  by OT12_ROWID asc

	exec @v_ret = dbo.SAPO_ErrorSend_Proc 'OT12', @id_12

	if @v_ret = 1
	begin
		set @id_12 = null
	end

	select 
		BUKRS,
		DATA_WYST,
		DOC_NUM,
		WYST_SAPUSER,
		WYST_NAME,
		MUZYTK,
		KOSTL,
		GDLGRP,
		SERNR,
		POSNR,
		HERST,
		NR_DOW_DOST,
		DATA_DOST,
		MIES_DOST,
		ROK_DOST,
		PRZEW_OKRES,
		WOJEWODZTWO,
		NR_TECHNOL,
		WART_TOTAL,
		ANLKL,
		PODZ_USL_P, 
		PODZ_USL_S, 
		PODZ_USL_B, 
		PODZ_USL_C, 
		PODZ_USL_U, 
		PODZ_USL_H, 
		CZY_FORM,
		ZZ_NR_FORM,
		ZZ_TYP_DOK,
		ZZ_POZ_FORM,
		ZZ_NR_DOK
		
	from dbo.SAPO_ZWFOT12v where OT12_ROWID = @id_12

	select 
		INVNR_NAZWA,
		CHAR_SKLAD,
		WART_ELEME,
		ANLN1,
		ANLN2,
		ZMT_OBJ_CODE
	from dbo.SAPO_ZWFOT12LNv where OT12LN_OT12ID = @id_12
	order by OT12LN_LP
	

	select 
		TDFORMAT, 
		TDLINE
	from dbo.SAPO_ZWFOT12COMv where OT12COM_OT12ID = @id_12

	return
end
GO