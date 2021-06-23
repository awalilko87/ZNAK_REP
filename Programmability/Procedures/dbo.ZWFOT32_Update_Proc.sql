SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT32_Update_Proc]
(
	@p_FormID nvarchar(50), 
	@p_ROWID int,
	@p_CODE nvarchar(30), 
	@p_ID nvarchar(50),
	@p_ORG nvarchar(30),
	@p_RSTATUS int,
	@p_STATUS nvarchar(30),
	@p_STATUS_old nvarchar(30),
	@p_TYPE nvarchar(30),
	@p_BUKRS nvarchar(30),  
	@p_CCD_DEFAULT nvarchar(30),
	@p_IF_EQUNR nvarchar(30), 
	@p_IF_SENTDATE datetime,
	@p_IF_STATUS int,
	@p_IMIE_NAZWISKO nvarchar(80), 
	@p_KROK nvarchar(10), 
	@p_SAPUSER nvarchar(32),
	@p_ZMT_ROWID int, 
	@p_OT_NR_PM nvarchar(50),
	 
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
	declare 
		@v_OTID int,
		@v_OT32ID int,
		@v_IF_STATUS int,
		@v_RSTATUS int
		--@v_PSPID int, --PSP 
		--@v_POSNR int, --PSP
		--@v_ITSID int, --ZAD INW
		--@v_SERNR nvarchar(30), --ZAD INW
		--@v_OBJID int,
		--@v_MUZYTK nvarchar(30)

	if @p_STATUS = 'OT32_60'
		set @p_STATUS = 'OT32_61' --odblokowanie dokumentu (procedura zakłada nowe pozycje do integracji)
 
	select @v_IF_STATUS = case @p_STATUS 
		when 'OT32_10' then 0
		when 'OT32_61' then 0
		when 'OT32_20' then 1
		else @p_IF_STATUS
	end
	 
	select @p_SAPUSER = @p_IMIE_NAZWISKO 
	--select @v_PSPID = PSP_ROWID, @v_POSNR = PSP_SAP_PSPNR from PSP (nolock) where PSP_CODE = @p_POSNR_ZMT
	--select @v_ITSID = ITS_ROWID, @v_SERNR = ITS_SAP_POSID from INVTSK (nolock) where ITS_CODE = @p_SERNR_ZMT
	--select @v_OBJID = OBJ_ROWID from OBJ (nolock) where OBJ_CODE = @p_ZMT_OBJ_CODE 
	--select @v_MUZYTK = STN_DESC from STATION (nolock) where STN_ROWID = @p_MUZYTKID
	--@p_MUZYTK nieużywane, pobierane z DDLa

	-- czy klucze niepuste
	if @p_ID is null or @p_CODE is NULL OR @p_ORG IS NULL -- ## dopisac klucze
	begin
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end

	if @p_IMIE_NAZWISKO is null
	begin
		select @v_errorcode = 'OT_SAPUSER'
		goto errorlabel
	end
  
	select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID
	select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS

	set @v_date = getdate()
  	     
	--insert
	if not exists (select * from dbo.ZWFOT (nolock) where OT_ID = @p_ID)
	begin
	  
		--Nagłówek (jeden dla wszystkich dokumentów do integracji)
		BEGIN TRY
			insert into dbo.ZWFOT  
			( 
				OT_STATUS, OT_RSTATUS, OT_ID, OT_ORG, OT_CODE, OT_TYPE, OT_CREDATE, OT_CREUSER, OT_NR_PM
			)
			select 
				@P_STATUS, @v_RSTATUS, @p_ID, @p_ORG, LEFT(NEWID(),5), 'SAPO_ZWFOT32', GETDATE(), @p_UserID, @p_OT_NR_PM

			select @v_OTID = IDENT_CURRENT('ZWFOT')
			
			if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')     
			begin    
				exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = '-', @p_UserID = @p_UserID    
			end 
		   
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT32_001' -- blad wstawienia
			goto errorlabel
		END CATCH;
		
		--Nagłówek dla SAP (Każdy wysłany dokuemnt to jeden wpis)
		BEGIN TRY
			--status integracji (inicjowanie) IF_STATUS
			--0 – nieaktywny (czyli pozycja czeka)
			--1 – do wysłania (oczekuje na PI)
			--2 – wysłane (procesowane po stronie PI)
			--3 – odpowiedź bez błędu
			--4 - odrzucony (archiwum)
			--9 – odpowiedź z błędem
			insert into dbo.SAPO_ZWFOT32
			(  
				OT32_KROK, OT32_BUKRS, OT32_IMIE_NAZWISKO, 
				OT32_IF_STATUS, OT32_IF_SENTDATE, OT32_IF_EQUNR, OT32_ZMT_ROWID, OT32_SAPUSER,
				OT32_CCD_DEFAULT
				 
			) 		
			select  
				@p_KROK, @p_BUKRS, @p_IMIE_NAZWISKO,
				0,  NULL, NULL, @v_OTID, @p_SAPUSER,
				@p_CCD_DEFAULT
				 
			select @v_OT32ID = SCOPE_IDENTITY()

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT32_002' -- blad wstawienia
			goto errorlabel
		END CATCH;
/*
		--pozycje z kompletu ZMT (uzupełnianie tylko podczas wprowadzania nowego OT32, aktualizacja poprzez inne formatki)
		BEGIN TRY

			--linia kompltacji OT w ZMT
			insert into dbo.ZWFOTLN 
			(
				OTL_OTID, OTL_STATUS, OTL_RSTATUS, OTL_ID, OTL_ORG, OTL_CODE, OTL_TYPE, OTL_CREDATE, OTL_CREUSER, OTL_OBJID
			)
			select distinct
				@v_OTID, NULL, 0, newid(), @p_ORG, OT_CODE + '/' + cast(ROW_NUMBER() OVER(PARTITION BY OT_CODE ORDER BY OBJ_DESC ASC) as nvarchar(50)) , NULL, getdate(), @p_UseriD, OBJ_ROWID
			from OBJ (nolock) 
				join ZWFOT (nolock) on OT_ROWID = @v_OTID
			where OBJ_PARENTID = @v_OBJID

			--linia kompletacji OT do integracji w SAP
			insert into dbo.SAPO_ZWFOT32LN
			(  
				OT32LN_INVNR_NAZWA, OT32LN_CHAR_SKLAD, OT32LN_WART_ELEME, OT32LN_ANLN1, OT32LN_ANLN2, OT32LN_ZMT_ROWID, OT32LN_OT32ID, OT32LN_ZMT_OBJ_CODE
			) 		
			select distinct
				OBJ_DESC, OBJ_NOTE, 0.0, NULL, NULL, NULL, @v_OT32ID, OBJ_CODE
			from OBJ (nolock) 
			where OBJ_PARENTID = @v_OBJID

			--uzupełnia OT32LN_ZMT_ROWID (takie trochę przesadzone, generalnie można by to ogarnąć kursorem ale to wydaje mi się jest wydajniejsze - 3 operacje na zbiorach zamiast 2 operacji x ilość przejść kursora)
			update SAP 
				set SAP.OT32LN_ZMT_ROWID = ZMT.OTL_ROWID
			from dbo.ZWFOTLN ZMT  (nolock)
				join dbo.OBJ (nolock) on OBJ.OBJ_ROWID = ZMT.OTL_OBJID
				join dbo.SAPO_ZWFOT32LN SAP(nolock) on SAP.OT32LN_ZMT_OBJ_CODE = OBJ.OBJ_CODE
			where	
				SAP.OT32LN_OT32ID = @v_OT32ID
				and ZMT.OTL_OTID = @v_OTID
				

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT32_002' -- blad wstawienia
			goto errorlabel
		END CATCH;
*/		 
	end
	else
	begin

		if not exists(select * from dbo.ZWFOT (nolock) where OT_ID = @p_ID and ISNULL(OT_STATUS,0) = ISNULL(@p_STATUS_old,0))
		begin
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'SYS_002' -- blad wspoluzytkowania
			goto errorlabel
		end   

		if exists(select * from dbo.ZWFOT (nolock) where OT_ID = @p_ID AND OT_CODE <> @p_CODE)
		begin
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'SYS_011' -- blad wspoluzytkowania
			goto errorlabel
		end   

		BEGIN TRY
			
			--nagłówek
			update dbo.ZWFOT
			set 
				OT_STATUS = @P_STATUS, 
				OT_RSTATUS = @v_RSTATUS,	
				OT_ORG = @P_ORG, 
				OT_UPDDATE = getdate(), 
				OT_UPDUSER = @p_UserID,
				OT_NR_PM = @p_OT_NR_PM
				
			where OT_ID = @P_ID
			
			
		   if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')     
		   begin    
				exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = '-', @p_UserID = @p_UserID    
		   end 
		   
		   /*
			if @p_STATUS = 'OT32_20' 
			and exists (select 1 from dbo.SAPO_ZWFOT32LN (nolock) join dbo.SAPO_ZWFOT32 (nolock) on OT32_ROWID = OT32LN_OT32ID where isnull(OT32LN_WART_ELEME,0) = 0 and OT32_ZMT_ROWID = @p_ZMT_ROWID )
			--sa zera w liniach kompletacji
	 		begin
				select @v_syserrorcode = error_message()
				select @v_errorcode = 'OT32_LN_001' -- blad wspoluzytkowania
				goto errorlabel
			end   
			*/
			--w takim przypadku wysyła nowy dokument (wraca ze statusu OT32_60 - Anulowany, z SAPa dostał status 9)
			if  @p_STATUS_old = 'OT32_60' and @p_STATUS_old <> @p_STATUS and @p_IF_STATUS in (3,9)
			begin
				
				--[NAG]
				--nowy nagłówek do SAP
				insert into dbo.SAPO_ZWFOT32
				(  
					OT32_KROK, OT32_BUKRS, OT32_IMIE_NAZWISKO,					
					OT32_IF_STATUS, OT32_IF_SENTDATE, OT32_IF_EQUNR, OT32_ZMT_ROWID, OT32_SAPUSER,
					OT32_CCD_DEFAULT
					
				) 					
				select 
					@p_KROK, @p_BUKRS, @p_IMIE_NAZWISKO,
					@v_IF_STATUS, NULL, NULL, @p_ZMT_ROWID, @p_SAPUSER,
					@p_CCD_DEFAULT
				 
				select @v_OT32ID = IDENT_CURRENT('SAPO_ZWFOT32')

				--[LN]
				--nowe linie kompletacji OT do integracji w SAP (dane w  ZWFOTLN sie nie zmieniaja!!)
				insert into dbo.SAPO_ZWFOT32LN
				(  
					OT32LN_LP, OT32LN_BUKRS, OT32LN_ANLN1, OT32LN_DT_WYDANIA, OT32LN_MPK_WYDANIA, 
					OT32LN_GDLGRP, OT32LN_DT_PRZYJECIA, OT32LN_MPK_PRZYJECIA, OT32LN_UZYTKOWNIK, 
					OT32LN_ZMT_ROWID, OT32LN_PRACOWNIK,	OT32LN_OT32ID,
					OT32LN_ANLN1_POSKI, OT32LN_MPK_WYDANIA_POSKI, OT32LN_GDLGRP_POSKI,
					OT32LN_ANLN1_PRZYJECIA, OT32LN_ANLN1_PRZYJECIA_POSKI, OT32LN_MPK_PRZYJECIA_POSKI, OT32LN_UZYTKOWNIK_POSKI
				) 		
				select 
					OT32LN_LP, OT32LN_BUKRS, OT32LN_ANLN1, OT32LN_DT_WYDANIA, OT32LN_MPK_WYDANIA, 
					OT32LN_GDLGRP, OT32LN_DT_PRZYJECIA, OT32LN_MPK_PRZYJECIA, OT32LN_UZYTKOWNIK, 
					OT32LN_ZMT_ROWID, OT32LN_PRACOWNIK, @v_OT32ID,
					OT32LN_ANLN1_POSKI, OT32LN_MPK_WYDANIA_POSKI, OT32LN_GDLGRP_POSKI,
					OT32LN_ANLN1_PRZYJECIA, OT32LN_ANLN1_PRZYJECIA_POSKI, OT32LN_MPK_PRZYJECIA_POSKI, OT32LN_UZYTKOWNIK_POSKI
				from dbo.SAPO_ZWFOT32LN (nolock)
					join dbo.SAPO_ZWFOT32 (nolock) on OT32_ROWID = OT32LN_OT32ID
    				join dbo.ZWFOTLN (nolock) on OTL_ROWID = OT32LN_ZMT_ROWID
				where 
					OT32_ZMT_ROWID = @p_ZMT_ROWID 
					and OT32_IF_STATUS in (3,9)
					and isnull(OTL_NOTUSED,0) = 0

				--[DON]
				--nowe linie kompletacji OT do integracji w SAP (dane w  ZWFOTLN sie nie zmieniaja!!)
				insert into dbo.SAPO_ZWFOT32DON
				(  
					OT32DON_LP, OT32DON_BUKRS, OT32DON_ANLN1, OT32DON_ANLN2,
					OT32DON_ANLN1_DO, OT32DON_ANLN2_DO, OT32DON_ZMT_ROWID,
					OT32DON_OT32ID, OT32DON_ANLN1_POSKI, OT32DON_ANLN1_DO_POSKI
				) 		
				select 
					OT32DON_LP, OT32DON_BUKRS, OT32DON_ANLN1, OT32DON_ANLN2,
					OT32DON_ANLN1_DO, OT32DON_ANLN2_DO, OT32DON_ZMT_ROWID,
					@v_OT32ID, OT32DON_ANLN1_POSKI, OT32DON_ANLN1_DO_POSKI					
				from dbo.SAPO_ZWFOT32DON (nolock)
					join dbo.SAPO_ZWFOT32 (nolock) on OT32_ROWID = OT32DON_OT32ID
    				join dbo.ZWFOTDON (nolock) on OTD_ROWID = OT32DON_ZMT_ROWID
				where 
					OT32_ZMT_ROWID = @p_ZMT_ROWID 
					and OT32_IF_STATUS in (3,9)
					and isnull(OTD_NOTUSED,0) = 0
										
				--ustawienie statusu 4 historia
				update dbo.SAPO_ZWFOT32 SET
 					OT32_IF_STATUS = 4  --archiwum
				where 
					OT32_ZMT_ROWID = @p_ZMT_ROWID 
					and OT32_IF_STATUS in (3,9)
  
			end
			--nagłówek integracji (aktualizacja dla nagłówka integracji)
			else if 
				(@p_STATUS_old <> 'OT32_61' and @p_STATUS in ('OT32_10','OT32_20'))
				or (@p_STATUS_old = 'OT32_61' and @p_STATUS in ('OT32_20','OT32_61'))  
			begin

				UPDATE dbo.SAPO_ZWFOT32 SET
					OT32_KROK = @p_KROK, OT32_BUKRS = @p_BUKRS, OT32_IMIE_NAZWISKO = @p_IMIE_NAZWISKO,					
					OT32_IF_STATUS = @v_IF_STATUS, OT32_IF_SENTDATE = @p_IF_SENTDATE, OT32_IF_EQUNR = @p_IF_EQUNR, OT32_SAPUSER = @p_SAPUSER,
					OT32_CCD_DEFAULT = @p_CCD_DEFAULT
 					
				where 
					OT32_ZMT_ROWID = @p_ZMT_ROWID 
					and OT32_IF_STATUS not in (3,4) --nie aktualizuje historycznych (IF_STATUS = 4)

			end

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT32_002' -- blad aktualizacji 
			goto errorlabel
		END CATCH;
		 
	end
	
	if @p_STATUS = 'OT32_20'
		update OBJ set OBJ_STATUS = 'OBJ_005' where OBJ_ROWID in --Przenoszony
	(	select OBJID from dbo.GetBlockedObjOT(@p_ID)
		/*select OBA_OBJID from dbo.ASSET (nolock) 
			join dbo.OBJASSET (nolock) on OBA_ASTID = AST_ROWID
		where 
			AST_SAP_ANLN1 + AST_SAP_ANLN2 in (select OT32DON_ANLN1 + OT32DON_ANLN2  from ZWFOT32DONv where OT32DON_OT32ID = @p_ROWID)*/
	)
	
	if @p_STATUS = 'OT32_70'
		update OBJ set OBJ_STATUS = 'OBJ_002' where OBJ_ROWID in --Przenoszony
	(	select OBJID from dbo.GetBlockedObjOT(@p_ID)
		/*select OBA_OBJID from dbo.ASSET (nolock) 
			join dbo.OBJASSET (nolock) on OBA_ASTID = AST_ROWID
		where 
			AST_SAP_ANLN1 + AST_SAP_ANLN2 in (select OT32DON_ANLN1 + OT32DON_ANLN2  from ZWFOT32DONv where OT32DON_OT32ID = @p_ROWID)*/
	)

	return 0

	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1

end
GO