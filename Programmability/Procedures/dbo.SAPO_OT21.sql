SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPO_OT21] 
as
begin

	declare @id_21 int
	declare @v_ret tinyint

	
	Select top 1 @id_21 = OT21_ROWID from SAPO_ZWFOT21 where OT21_IF_STATUS = 1 order  by OT21_ROWID asc

	exec @v_ret = dbo.SAPO_ErrorSend_Proc 'OT21', @id_21

	if @v_ret = 1
	begin
		set @id_21 = null
	end

	select 
		OT21_ROWID,
		SERNR,
		POSNR,
		KOSTL,
		GDLGRP,
		MUZYTK,
		BUKRS,
		WYST_SAPUSER,
		WYST_NAME,
		ZZ_NR_FORM,
		ZZ_TYP_DOK,
		ZZ_POZ_FORM,
		ZZ_NR_DOK,
		CZY_FORM		
	from dbo.SAPO_ZWFOT21v where OT21_ROWID = @id_21

	select 
		TDFORMAT,
		TDLINE 
	from dbo.SAPO_ZWFOT21COMv where OT21COM_OT21ID = @id_21

	select 
		ILOSC, --row_number() over(partition by OT21LN_OT21ID order by ZMT_OBJ_CODE),
		NZWYP,
		NR_PRA_UZYTK,
		GRUPA,
		SKL_RUCH,
		MUZYTK,
		WART_NAB_PLN=Replace(CONVERT(nvarchar(30),WART_NAB_PLN),',','.'),
		DOSTAWCA,
		NR_DOW_DOSTAWY,
		DT_DOSTAWY,
		ANLN1,
		ANLN2,
		ZMT_OBJ_CODE
	 
	from dbo.SAPO_ZWFOT21LNv where OT21LN_OT21ID = @id_21
	
	return
end
GO