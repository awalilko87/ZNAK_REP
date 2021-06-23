SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SAPO_OT41] 
as
begin

	declare @id_41 int
	declare @v_ret tinyint

	Select top 1 @id_41 = OT41_ROWID from SAPO_ZWFOT41 where OT41_IF_STATUS = 1 order  by OT41_ROWID asc

	exec @v_ret = dbo.SAPO_ErrorSend_Proc 'OT41', @id_41

	if @v_ret = 1
	begin
		set @id_41 = null
	end

	select 
		[DOC_NUM],
		[DOC_YEAR],
		[AKCJA],
		[GUID],
		[KROK] = ISNULL([KROK],1),
		[BUKRS],
		[WYST_SAPUSER],
		[WYST_NAME]
	from dbo.SAPO_ZWFOT41v where OT41_ROWID = @id_41

	--select 
	--	TDFORMAT, 
	--	TDLINE
	--from dbo.SAPO_ZWFOT11COMv where OT11COM_OT11ID = @id_41
	
	 select 
		TDFORMAT, 
		TDLINE
	from dbo.[SAPO_ZWFOT41COMv] where OT41COM_OT41ID = @id_41

	select 
		[BUKRS],
		[ANLN1], 
		[KOSTL],
		[GDLGRP],
		[UZASA],
		[MENGE] 
	from dbo.SAPO_ZWFOT41LNv where OT41LN_OT41ID = @id_41

	update dbo.SAPO_ZWFOT41 set
		 OT41_IF_STATUS = 2
		,OT41_IF_SENTDATE = getdate()
	where OT41_ROWID = @id_41
	
	return
end
GO