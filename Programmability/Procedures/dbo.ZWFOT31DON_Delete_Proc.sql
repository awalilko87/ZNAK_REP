SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT31DON_Delete_Proc]
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
	declare @v_OT31ID int
	declare @v_OTID int
 
	-- czy klucze niepuste
	if @p_ROWID is null
	begin
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
 
	set @v_date = getdate()
  
	begin
	 

		BEGIN TRY
		 
			--nagłówek
			update 
				[dbo].[ZWFOTDON]
			set 
				OTD_NOTUSED = 1 
				,@v_OTID = OTD_OTID
			where OTD_ROWID in 
				(
					select 
						OT31DON_ZMT_ROWID 
					from  
						[dbo].[SAPO_ZWFOT31DON] (nolock)
					where
						OT31DON_ROWID = @p_ROWID
				)

			delete from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID
				 
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT31_002' -- blad aktualizacji 
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