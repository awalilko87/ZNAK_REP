SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT42LN_Delete_Proc]
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
	declare 
		@v_ANLN1 nvarchar(30),
		@v_ANLN2 nvarchar(30),
		@v_OT42ID int
 
	-- czy klucze niepuste
	if @p_ROWID is null
	begin
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
 
	set @v_date = getdate()
  



	 select 
		@v_ANLN1 = OT42LN_ANLN1,
		@v_ANLN2 = OT42LN_ANLN2,
		@v_OT42ID = OT42LN_OT42ID
	from ZWFOT42LNv where OT42LN_ROWID = @p_ROWID

	-------------------------------------------------------------------------------------------
	----------------https://jira.eurotronic.net.pl/browse/PKNTA-164----------------------------
	----------------System nie powinien likwidować składnika głównego bez podskładników--------
	-------------------------------------------------------------------------------------------
	----------------https://jira.eurotronic.net.pl/browse/PKNTA-332----------------------------
	----------------Możemy z dokumnetu PL usunąc składnik główny a zostawić tylko podskładniki, lecz nie możemy usuwać podskładników jeśli jest główny--------
	if 
		exists (select 1 from ZWFOT42LNv where OT42LN_OT42ID = @v_OT42ID and OT42LN_ANLN1 = @v_ANLN1 and OT42LN_ANLN2 = '0000' and OT42LN_PROC = 100) --istnieje na tym PL składnik główny do likw 100%
		and exists (select 1 from ZWFOT42LNv where OT42LN_OT42ID = @v_OT42ID and OT42LN_ANLN1 = @v_ANLN1 and OT42LN_ANLN2 <> '0000') --istnieją na tym PL podskładniki do skadnika głównego
		and @v_ANLN2 != '0000' -- możemy usunąć składnik główny z dok PL
	begin
 		select @v_errorcode = 'OT42LN_008' -- Nie można likwidować podskładników bez składnika głównego
		goto errorlabel 
	end
 
	--PKNZAKR-14 PBI 3505 mechanizm blokujący wyrzucenie podskładnika kompletacji z PL w związku z obecnością składnika głównego kompletacji w innym aktywnym PL
 	if (select [dbo].[ZWFOT42_IsLineRemovable](@p_ROWID)) = 0
		begin
			select @v_errorcode = 'OT42LN_009'
			--select @v_errorcode = 'Nie można usunąć elementu kompletacji, której składnik główny znajduje się w procesowanym dokumencie likwidacyjnym.'
			goto errorlabel
		end

	begin
	 
		BEGIN TRY
		 
			--nagłówek
			update 
				[dbo].[ZWFOTLN]
			set
				OTL_NOTUSED = 1
				,OTL_UPDUSER = @p_UserID
				,OTL_UPDDATE = getdate()
			where OTL_ROWID in 
				(
					select 
						OT42LN_ZMT_ROWID 
					from  
						[dbo].[SAPO_ZWFOT42LN] (nolock)
					where
						OT42LN_ROWID = @p_ROWID
				)

			delete from dbo.ZWFOTOBJ where OTO_OTLID = (select OT42LN_ZMT_ROWID from [dbo].[SAPO_ZWFOT42LN] (nolock) where OT42LN_ROWID = @p_ROWID)
				 
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT42_002' -- blad aktualizacji 
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