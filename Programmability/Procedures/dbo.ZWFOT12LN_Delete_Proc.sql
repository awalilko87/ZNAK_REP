SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT12LN_Delete_Proc]
(
	@p_FormID nvarchar(50), 
	@p_ROWID int,

	@p_UserID nvarchar(30) = NULL, -- uzytkownik
	@p_apperrortext nvarchar(4000) = null output
)
as
begin

	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @v_date datetime 
	declare @v_Pref nvarchar(10)
	declare @v_MultiOrg BIT
	declare @v_Rstatus int
	declare @v_OT12ID int
	declare @v_OTID int
	declare @v_OBJ_CODE nvarchar(30)
	declare @v_OTLID int
	
	-- czy klucze niepuste
	if @p_ROWID is null
	begin
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
 
	set @v_date = getdate()
  
	begin
	 
		BEGIN TRY
			 
			select @v_OTLID = OT12LN_ZMT_ROWID, @v_OT12ID = OT12LN_OT12ID, @v_OBJ_CODE = OT12LN_ZMT_OBJ_CODE from dbo.SAPO_ZWFOT12LN (nolock) where OT12LN_ROWID = @p_ROWID
			select @v_OTID = OT12_ZMT_ROWID from dbo.SAPO_ZWFOT12 (nolock) where OT12_ROWID = @v_OT12ID
			update OBJ set OBJ_OTID = NULL where OBJ_OTID = @v_OTID and OBJ_CODE = @v_OBJ_CODE
			
			delete from dbo.ZWFOTOBJ where OTO_OTLID = @v_OTLID
				
			--nagłówek
			update 
				[dbo].[ZWFOTLN]
			set
				OTL_NOTUSED = 1
			where OTL_ROWID in 
				(
					select 
						OT12LN_ZMT_ROWID 
					from  
						[dbo].[SAPO_ZWFOT12LN] (nolock)
					where
						OT12LN_ROWID = @p_ROWID
				)
				
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT12_002' -- blad aktualizacji 
			goto errorlabel
		END CATCH;
		 
	end

	return 0

	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1

end
GO