SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT31LN_Delete_Proc]
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
 
	-- czy klucze niepuste
	if @p_ROWID is null
	begin
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
 
	set @v_date = getdate()
   

	BEGIN TRY

		delete from dbo.ZWFOTOBJ where OTO_OTLID = (select OT31LN_ZMT_ROWID from dbo.SAPO_ZWFOT31LN where OT31LN_ROWID = @p_ROWID)
	 
		--nagłówek
		update 
			[dbo].[ZWFOTLN]
		set
			OTL_NOTUSED = 1
		where OTL_ROWID in 
			(
				select 
					OT31LN_ZMT_ROWID 
				from  
					[dbo].[SAPO_ZWFOT31LN] (nolock)
				where
					OT31LN_ROWID = @p_ROWID
			)
		 
	END TRY
	BEGIN CATCH
		select @v_syserrorcode = error_message()
		select @v_errorcode = 'OT31_002' -- blad aktualizacji 
		goto errorlabel
	END CATCH;
	 
	--Aktualizacja doniesień (przy każdym zapisie musi zapewnić aktualność tych danych z SAP
	exec dbo.ZWFOT31DON_Recalculate @p_OT31ID = @p_ROWID

	return 0

	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1

end
GO