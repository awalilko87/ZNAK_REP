SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT11_Delete_Proc] 
(
  @p_FormID nvarchar(50),
  @p_ID nvarchar(50),

  @p_UserID nvarchar(30), -- uzytkownik
  @p_apperrortext nvarchar(4000) output
)
as
begin
	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @v_date datetime
	declare 
		@v_OTID int,
		@v_OT12ID int,
		@v_STATUS nvarchar(30),
		@v_RSTATUS int
 
	select 
		@v_STATUS = OT_STATUS,
		@v_OTID = OT_ROWID
	from dbo.ZWFOT (nolock) where OT_ID = @p_ID
	
 	-- czy status pozwala
	if @v_STATUS not like '%10' 
	begin
		select @v_errorcode = 'STA_DEL_ERROR'
		goto errorlabel
	end
	--delete
	BEGIN TRY

		update OBJ set OBJ_OTID = NULL where OBJ_OTID = @v_OTID
		delete from dbo.SAPO_ZWFOT11 where OT11_ZMT_ROWID = @v_OTID
		delete from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID
		delete from dbo.ZWFOT where OT_ROWID = @v_OTID


	END TRY
	BEGIN CATCH
		select @v_syserrorcode = error_message()
		select @v_errorcode = 'OT11_002' -- blad kasowania
		goto errorlabel
	END CATCH;

	return 0
	
	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1
end
GO