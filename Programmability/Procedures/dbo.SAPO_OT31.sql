SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPO_OT31] 
as
begin

	declare @id_31 int
	declare @v_ret tinyint

	Select top 1 @id_31 = OT31_ROWID from SAPO_ZWFOT31 where OT31_IF_STATUS = 1 order  by OT31_ROWID asc

	exec @v_ret = dbo.SAPO_ErrorSend_Proc 'OT31', @id_31

	if @v_ret = 1
	begin
		set @id_31 = null
	end
 
	select
		KROK,
		BUKRS,
		right(WYST_SAPUSER, 12) as WYST_SAPUSER,
		WYST_NAME
	from dbo.SAPO_ZWFOT31v where OT31_ROWID = @id_31

	select 
		LP,
		BUKRS,
		ANLN1,
		DT_WYDANIA=convert(nvarchar(10),DT_WYDANIA,121),
		MPK_WYDANIA=MPK_WYDANIA,
		GDLGRP=convert(nvarchar(8),GDLGRP),
		DT_PRZYJECIA=convert(nvarchar(10),DT_PRZYJECIA,121),
		MPK_PRZYJECIA=MPK_PRZYJECIA,
		UZYTKOWNIK=convert(nvarchar(8),UZYTKOWNIK),
		PRACOWNIK,
		UZASADNIENIE
	from dbo.SAPO_ZWFOT31LNv where OT31LN_OT31ID = @id_31
	
	select   
		LP,
		BUKRS,
		ANLN1,
		ANLN2 

	from dbo.SAPO_ZWFOT31DONv where OT31DON_OT31ID = @id_31
	
	select 
		TDFORMAT,
		TDLINE 
	from dbo.SAPO_ZWFOT31COMv where OT31COM_OT31ID = @id_31

	return
end
GO