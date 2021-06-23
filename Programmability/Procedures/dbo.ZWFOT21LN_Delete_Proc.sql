SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT21LN_Delete_Proc]
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
	declare @v_OT21ID int
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
		 
			select @v_OTLID = OT21LN_ZMT_ROWID, @v_OT21ID = OT21LN_OT21ID, @v_OBJ_CODE = OT21LN_ZMT_OBJ_CODE from dbo.SAPO_ZWFOT21LN (nolock) where OT21LN_ROWID = @p_ROWID
			select @v_OTID = OT21_ZMT_ROWID from dbo.SAPO_ZWFOT21 (nolock) where OT21_ROWID = @v_OT21ID
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
						OT21LN_ZMT_ROWID 
					from  
						[dbo].[SAPO_ZWFOT21LN] (nolock)
					where
						OT21LN_ROWID = @p_ROWID
				)
			;
				
			----jest też w triggerze na tabeli z pozycjami. Na wszelki wypadek.
			with a as
				(
					select OT21_ROWID, sum(OT21LN_WART_NAB_PLN) suma
					from [dbo].[SAPO_ZWFOT21LN] (nolock) 
						join [dbo].[SAPO_ZWFOT21] (nolock) on OT21_ROWID = OT21LN_OT21ID
						join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT21LN_ZMT_ROWID
					where ot21ln_ot21id = @v_OT21ID and isnull(OTL_NOTUSED,0) = 0
					group by OT21_ROWID
				)
			update UPD set UPD.OT21_KWPRZEKSIEGS = suma 
				from [dbo].[SAPO_ZWFOT21] UPD
					join A on A.OT21_ROWID = UPD.OT21_ROWID
				where UPD.OT21_ROWID = A.OT21_ROWID
							  
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT21_002' -- blad aktualizacji 
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