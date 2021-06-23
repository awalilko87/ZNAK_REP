SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPO_OT32] 
as
begin

	declare @id_32 int
	declare @v_ret tinyint

	Select top 1 @id_32 = OT32_ROWID from SAPO_ZWFOT32 where OT32_IF_STATUS = 1 
	/*wysyła tylko dokumenty z liniami */ and ((select COUNT (*) from dbo.SAPO_ZWFOT32LNv where OT32LN_OT32ID=OT32_ROWID)>0)
	order  by OT32_ROWID asc

	exec @v_ret = dbo.SAPO_ErrorSend_Proc 'OT32', @id_32

	if @v_ret = 1
	begin
		set @id_32 = null
	end
 
	select
		BUKRS,
		KROK,
		right(WYST_SAPUSER, 12) as WYST_SAPUSER,
		WYST_NAME
	from dbo.SAPO_ZWFOT32v where OT32_ROWID = @id_32

	select 
		LP,
		BUKRS,
		ANLN1,
		DT_WYDANIA=convert(nvarchar(10),DT_WYDANIA,121),
		MPK_WYDANIA,
		GDLGRP,
		DT_PRZYJECIA=convert(nvarchar(10),DT_PRZYJECIA,121),
		MPK_PRZYJECIA,
		UZYTKOWNIK,
		PRACOWNIK,
		ANLN1_PRZYJECIA

	from dbo.SAPO_ZWFOT32LNv where OT32LN_OT32ID = @id_32
	
	select 
		LP,
		BUKRS,
		ANLN1,
		ANLN2,
		ANLN1_DO,
		ANLN2_DO

	from dbo.SAPO_ZWFOT32DONv where OT32DON_OT32ID = @id_32


	select 
		TDFORMAT,
		TDLINE 
	from dbo.SAPO_ZWFOT32COMv where OT32COM_OT32ID = @id_32

	
	return
end
GO