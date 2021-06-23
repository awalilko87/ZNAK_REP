SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SAPO_OT40] 
AS
BEGIN

	declare @id_40 int
	declare @v_ret tinyint

	Select top 1 @id_40 = OT40_ROWID from SAPO_ZWFOT40 where OT40_IF_STATUS = 1 order  by OT40_ROWID asc

	exec @v_ret = dbo.SAPO_ErrorSend_Proc 'OT40', @id_40

	--if @v_ret = 1
	--begin
	--	set @id_40 = null
	--end

	select 
		[DOC_NUM],
		[DOC_YEAR],
		[AKCJA],
		[GUID],
		[KROK],
		[BUKRS],
		[WYST_SAPUSER],
		[WYST_NAME],
		[PL_DOC_NUM],
		[PL_DOC_YEAR]
	from dbo.SAPO_ZWFOT40v where OT40_ROWID = @id_40

	--select 
	--	[TDFORMAT] = OT40COM_TDFORMAT, 
	--	[TDLINE] = OT40COM_TDLINE
	--from dbo.SAPO_ZWFOT40COM where OT40COM_OT40ID = @id_40
	
	select 
		TDFORMAT,
		TDLINE 
	from dbo.[SAPO_ZWFOT40COMv] where OT40COM_OT40ID = @id_40

	select 
		[BUKRS],
		[ANLN1],
		[ANLN2], 
		[PROC],
		[OPIS]
	from dbo.SAPO_ZWFOT40LNv where OT40LN_OT40ID = @id_40

	update dbo.SAPO_ZWFOT40 set
		 OT40_IF_STATUS = 2
		,OT40_IF_SENTDATE = getdate()
	where OT40_ROWID = @id_40
	
	return
end
GO