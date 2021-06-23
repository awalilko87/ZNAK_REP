SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT21_Update_Proc]
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
	@p_GDLGRP_POSKI nvarchar(30), 
	@p_IF_EQUNR nvarchar(30), 
	@p_IF_SENTDATE datetime,
	@p_IF_STATUS int,
	@p_IMIE_NAZWISKO nvarchar(80), 
	@p_KOSTL_POSKI nvarchar(30),
	@p_MUZYTKID int,
	@p_MUZYTK nvarchar(30), 
	@p_POSNR_POSKI nvarchar(30),
	@p_SAPUSER nvarchar(21),
	@p_SERNR_POSKI nvarchar(30),  
	@p_CZY_FORM nvarchar(1),
	@p_NR_FORM nvarchar(25),
	@p_TYP_DOK nvarchar(50),
	@p_POZ_FORM nvarchar(10),
	@p_NR_DOK nvarchar(25),
	@p_KWPRZEKSIEGS numeric(13,2),
	
	@p_ZMT_ROWID int, 
	@p_ZMT_OBJ_CODE nvarchar(30),
	@p_INOID int,
	 
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
		@v_OT21ID int,
		@v_IF_STATUS int,
		@v_RSTATUS int,
		@v_KL5ID int,
		@v_PSPID int, --PSP 
		@v_POSNR int, --PSP
		@v_ITSID int, --ZAD INW
		@v_SERNR nvarchar(30), --ZAD INW
		@v_GDLGRP nvarchar(30),
		@v_KOSTL nvarchar(30),
		@v_OBJID int,
		@v_MUZYTK nvarchar(30),
		@c_OBJID int,
		@v_KOSTL_POSKI nvarchar(40)

	if @p_STATUS = 'OT21_60'
		set @p_STATUS = 'OT21_61' --odblokowanie dokumentu (procedura zakłada nowe pozycje do integracji)
 
	select @v_IF_STATUS = case @p_STATUS 
		when 'OT21_10' then 0
		when 'OT21_61' then 0
		when 'OT21_20' then 1
		else @p_IF_STATUS
	end
		 
	--rzutowanie zmiennych z SAP (POSKI jest polem jedynie do wyświetlania (zadanie inwestycyjne to wyjątek)
	--select @p_SAPUSER = @p_IMIE_NAZWISKO 
	select @v_PSPID = PSP_ROWID, @v_POSNR = PSP_SAP_PSPNR from [dbo].[PSP] (nolock) where PSP_CODE = @p_POSNR_POSKI -- pole przekazywane do SAP - element PSP
	select @v_ITSID = ITS_ROWID, @v_SERNR = ITS_SAP_POSKI from [dbo].[INVTSK] (nolock) where ITS_CODE = @p_SERNR_POSKI --pole przekazywane do SAP - Zadanie inw
	select @v_GDLGRP = KL5_SAP_GDLGRP, @v_KL5ID = KL5_ROWID from [dbo].[KLASYFIKATOR5] (nolock) where KL5_CODE = @p_GDLGRP_POSKI
	select @v_KOSTL = CCD_SAP_KOSTL from [dbo].[COSTCODE] (nolock) where CCD_CODE = @p_KOSTL_POSKI
	select @v_OBJID = OBJ_ROWID from [dbo].[OBJ] (nolock) where OBJ_CODE = @p_ZMT_OBJ_CODE 
	select @v_MUZYTK = STN_DESC from [dbo].[STATION] (nolock) where STN_ROWID = @p_MUZYTKID --@p_MUZYTK nieużywane, pobierane z DDLa

	select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID
	select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS

	set @v_date = getdate()
	
			--OBSŁUGA BŁĘDÓW TECHNICZNYCH
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

			--OBSŁUGA BŁĘDÓW słownikowych
			if not exists (select 1 from dbo.KLASYFIKATOR5 (nolock) where KL5_CODE = @p_GDLGRP_POSKI) begin
				select @v_errorcode = 'OT21_001' -- Wprowadzono niewłaściwego użytkownika
				goto errorlabel end
		
			if not exists (select 1 from dbo.COSTCODE (nolock) where CCD_CODE = @p_KOSTL_POSKI) begin
				select @v_errorcode = 'OT21_002' -- Wprowadzono niewłaściwy numer MPK
				goto errorlabel end
			
			set @v_KOSTL_POSKI = @p_KOSTL_POSKI + '%'
			if @p_GDLGRP_POSKI not in (select KL5_CODE from KLASYFIKATOR5 where KL5_CODE like @v_KOSTL_POSKI)
			begin
				select @v_errorcode = 'OT21_003' -- czy użytkownik zgadza sie z mpk
				goto errorlabel
			end
	
			if not exists (select 1 from STATION (nolock) where STN_KL5ID = @v_KL5ID and STN_ROWID = @p_MUZYTKID)
			begin
				select @v_errorcode = 'OT21_005' -- Wybrana stacja paliw (miejsce użytkowania) nie jest powiązana z klasyfikatorem 5 (użytkownikiem)
				goto errorlabel
			end

	if not exists (select * from dbo.OBJSTATION (nolock) where OSA_OBJID = @v_OBJID) and @v_OBJID is not null
	begin
		insert into dbo.OBJSTATION (OSA_OBJID, OSA_STNID, OSA_KL5ID, OSA_CREDATE, OSA_CREUSER)
		select @v_OBJID, @p_MUZYTKID, @v_KL5ID, GETDATE(), @p_UserID
	end
	else 
	begin
		update dbo.OBJSTATION
		set OSA_STNID = @p_MUZYTKID
		where OSA_OBJID = @v_OBJID
	end
	


  	--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++     
	--+++++++++++++++++++++++++++++++++++++++++INSERT+++++++++++++++++++++++++++++++++++++++++++
	--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	if not exists (select * from dbo.ZWFOT (nolock) where OT_ID = @p_ID)
	begin
	  
		--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		--Nagłówek (jeden dla wszystkich dokumentów do integracji)
		--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		BEGIN TRY
			insert into dbo.ZWFOT  
			( 
				OT_STATUS, OT_RSTATUS, OT_ID, OT_ORG, OT_CODE, OT_TYPE, OT_CREDATE, OT_CREUSER, OT_ITSID, OT_PSPID, OT_INOID
			)
			select 
				@p_STATUS, @v_RSTATUS, @p_ID, @p_ORG, LEFT(NEWID(),5), 'SAPO_ZWFOT21', GETDATE(), @p_UserID, @v_ITSID, @v_PSPID, @p_INOID
 
			select @v_OTID = IDENT_CURRENT('ZWFOT')

			--aktualizuje OBJ_OTID składnika głównego
			update OBJ set OBJ_OTID = @v_OTID where OBJ_ROWID = @v_OBJID

			if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')     
			begin    
				exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = '-', @p_UserID = @p_UserID    
			end 
		   
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT21_001' -- blad wstawienia
			goto errorlabel
		END CATCH;
		
		--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		--Nagłówek dla SAP (Każdy wysłany dokuemnt to jeden wpis)
		--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		BEGIN TRY
			--status integracji (inicjowanie) IF_STATUS
			--0 – nieaktywny (czyli pozycja czeka)
			--1 – do wysłania (oczekuje na PI)
			--2 – wysłane (procesowane po stronie PI)
			--3 – odpowiedź bez błędu
			--4 - odrzucony (archiwum)
			--9 – odpowiedź z błędem
			insert into dbo.SAPO_ZWFOT21
			(  
				OT21_BUKRS, OT21_IMIE_NAZWISKO
				, OT21_SERNR, OT21_SERNR_POSKI
				, OT21_POSNR, OT21_POSNR_POSKI
				, OT21_KOSTL, OT21_KOSTL_POSKI
				, OT21_GDLGRP, OT21_GDLGRP_POSKI
				, OT21_MUZYTKID, OT21_MUZYTK, OT21_IF_STATUS, OT21_IF_SENTDATE, OT21_IF_EQUNR, OT21_ZMT_ROWID, OT21_SAPUSER, ZMT_OBJ_CODE
				, OT21_CZY_FORM, OT21_NR_FORM, OT21_TYP_DOK, OT21_POZ_FORM, OT21_NR_DOK
			) 		
			select  
				@p_BUKRS, @p_IMIE_NAZWISKO
				, @v_SERNR, @p_SERNR_POSKI
				, @v_POSNR, @p_POSNR_POSKI
				, @v_KOSTL, @p_KOSTL_POSKI
				, @v_GDLGRP, @p_GDLGRP_POSKI
				, @p_MUZYTKID, @v_MUZYTK, 0,  NULL, NULL, @v_OTID, @p_SAPUSER, @p_ZMT_OBJ_CODE
				, @p_CZY_FORM, @p_NR_FORM, @p_TYP_DOK, @p_POZ_FORM, @p_NR_DOK
				
			select @v_OT21ID = SCOPE_IDENTITY()

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT21_002' -- blad wstawienia
			goto errorlabel
		END CATCH;

		--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		--pozycje z wyposażenia ZMT (uzupełnianie tylko podczas wprowadzania nowego OT21, aktualizacja poprzez inne formatki)
		--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		BEGIN TRY
			
			---------------------------------------------------------------------------------
			------------------uzupełnienie OBJSTATION----------------------------------------
			---------------------------------------------------------------------------------
			declare c_OBJ_ALL cursor for
			select ZMT.OBJ_ROWID from dbo.OBJ ZMT  (nolock) where ZMT.OBJ_PARENTID = @v_OBJID
			
			open c_OBJ_ALL
			
			fetch next from c_OBJ_ALL
			into @c_OBJID
			
			while @@FETCH_STATUS = 0
			begin
				if not exists (select * from dbo.OBJSTATION (nolock) where OSA_OBJID = @c_OBJID) and @c_OBJID is not null
				begin
					insert into dbo.OBJSTATION (OSA_OBJID, OSA_STNID, OSA_KL5ID, OSA_CREDATE, OSA_CREUSER)
					select @c_OBJID, @p_MUZYTKID, @v_KL5ID, GETDATE(), @p_UserID
				end
				else 
				begin
					update dbo.OBJSTATION
					set OSA_STNID = @p_MUZYTKID
					where OSA_OBJID = @c_OBJID
				end
				
				fetch next from c_OBJ_ALL
				into @c_OBJID
			end
			
			close c_OBJ_ALL
			deallocate c_OBJ_ALL

			----------------------------------------------------------------------------------
			--------------------linie wyposażenia OT w ZMT------------------------------------
			----------------------------------------------------------------------------------
			insert into dbo.ZWFOTLN 
			(
				OTL_OTID, OTL_STATUS, OTL_RSTATUS, OTL_ID, OTL_ORG, OTL_CODE, OTL_TYPE, OTL_CREDATE, OTL_CREUSER, OTL_OBJID
			)
			select
				@v_OTID, NULL, 0, newid(), @p_ORG, OT_CODE + '/' + cast(ROW_NUMBER() OVER(PARTITION BY OT_CODE ORDER BY OBJ_DESC ASC) as nvarchar(50)) , NULL, getdate(), @p_UseriD, OBJ_ROWID
			from OBJ (nolock) 
				join STENCIL (nolock) on STS_ROWID = OBJ_STSID
				join ZWFOT (nolock) on OT_ROWID = @v_OTID
			where OBJ_PARENTID = @v_OBJID
				--and OBJ_PARENTID <> OBJ_ROWID --nie rozliczamy oddzielnie głównego składnika
				--and STS_SETTYPE = 'EKOM'
			order by STS_DESC
			
			---------------------------------------------------------------------------------
			--------------------linie wyposażenia W  do integracji w SAP---------------------
			---------------------------------------------------------------------------------
			insert into dbo.SAPO_ZWFOT21LN
			(  
				OT21LN_WART_NAB_PLN, OT21LN_DOSTAWCA, OT21LN_NR_DOW_DOSTAWY, OT21LN_DT_DOSTAWY, OT21LN_GRUPA, OT21LN_ANLN1, OT21LN_ANLN2, OT21LN_ZMT_ROWID, OT21LN_OT21ID, OT21LN_ZMT_OBJ_CODE
				, OT21LN_NZWYP
			) 		
			select distinct
				NULL, NULL, NULL, NULL, '', '', '', NULL, @v_OT21ID, OBJ_CODE 
				, left(OBJ_DESC,50)
			from OBJ (nolock) 
				join STENCIL (nolock) on STS_ROWID = OBJ_STSID
			where OBJ_PARENTID = @v_OBJID
				--and OBJ_PARENTID <> OBJ_ROWID --nie rozliczamy oddzielnie głównego składnika
				--and STS_SETTYPE = 'EKOM'
			order by left(OBJ_DESC,50)

			insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OBJID, OTO_ASTCODE, OTO_ASTSUBCODE, OTO_CREUSER, OTO_CREDATE)
			select @v_OTID, OBJ_ROWID, null, null, @p_UserID, getdate()
			from dbo.OBJ
			where OBJ_PARENTID = @v_OBJID
			and not exists (select 1 from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID and OTO_OBJID = OBJ_ROWID)

			---------------------------------------------------------------------------------------------------------------------
			--------------------uzupełnia OT21LN_ZMT_ROWID (takie trochę przesadzone, -------------------------------------------
			--------------------generalnie można by to ogarnąć kursorem ale to wydaje mi się jest wydajniejsze ------------------
			-------------------3 operacje na zbiorach zamiast 2 operacji x ilość przejść kursora)--------------------------------
			---------------------------------------------------------------------------------------------------------------------			
			update SAP 
				set SAP.OT21LN_ZMT_ROWID = ZMT.OTL_ROWID
			from dbo.ZWFOTLN ZMT  (nolock)
				join dbo.OBJ (nolock) on OBJ.OBJ_ROWID = ZMT.OTL_OBJID
				join dbo.SAPO_ZWFOT21LN SAP(nolock) on SAP.OT21LN_ZMT_OBJ_CODE = OBJ.OBJ_CODE
			where	
				SAP.OT21LN_OT21ID = @v_OT21ID
				and ZMT.OTL_OTID = @v_OTID
				
			-------------------------------------------------------------------------------
			--------------------aktualizuje kolumne OBJ_OTID na pozycjach------------------
			-------------------------------------------------------------------------------
			update OBJ set OBJ_OTID = @v_OTID where OBJ_ROWID in (select ZMT.OTL_OBJID from dbo.ZWFOTLN ZMT  (nolock) where ZMT.OTL_OTID = @v_OTID)

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT21_002' -- blad wstawienia
			goto errorlabel
		END CATCH;
		 
	end
	else
	begin
  		--+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=     
		--+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=UPDATE+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
		--+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
		
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
				OT_UPDDATE = getdate(), 
				OT_UPDUSER = @p_UserID
				--OT_ITSID = @v_ITSID, 
				--OT_PSPID = @v_PSPID,
				--OT_INOID = @p_INOID

			where OT_ID = @P_ID
	
			--update OBJ set OBJ_OTID = @p_ZMT_ROWID where OBJ_ROWID = @v_OBJID
			
		   if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')     
		   begin    
				exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = @p_STATUS_old, @p_UserID = @p_UserID    
		   end 		
			
			if @p_STATUS = 'OT21_20' 
			and exists (select 1 from dbo.ZWFOT21LNv (nolock) join dbo.ZWFOT21v (nolock) on OT21_ROWID = OT21LN_OT21ID where isnull(OT21LN_WART_NAB_PLN,0) = 0 and OT21_ZMT_ROWID = @p_ZMT_ROWID )
			--sa zera w liniach kompletacji
	 		begin
				select @v_syserrorcode = error_message()
				select @v_errorcode = 'OT21_LN_001' -- blad wspoluzytkowania
				goto errorlabel
			end   
						
			--w takim przypadku wysyła nowy dokument (wraca ze statusu OT21_60 - Anulowany, z SAPa dostał status 9)
			if  @p_STATUS_old = 'OT21_60' and @p_STATUS_old <> @p_STATUS and @p_IF_STATUS in (3,9)
			begin

				--nowy nagłówek do SAP
				insert into dbo.SAPO_ZWFOT21
				(  
					OT21_BUKRS, OT21_IMIE_NAZWISKO
					, OT21_SERNR, OT21_SERNR_POSKI
					, OT21_POSNR, OT21_POSNR_POSKI
					, OT21_KOSTL, OT21_KOSTL_POSKI
					, OT21_GDLGRP, OT21_GDLGRP_POSKI			
					, OT21_MUZYTKID, OT21_MUZYTK, OT21_IF_STATUS, OT21_IF_SENTDATE, OT21_IF_EQUNR, OT21_ZMT_ROWID, OT21_SAPUSER
					, OT21_CZY_FORM, OT21_NR_FORM, OT21_TYP_DOK, OT21_POZ_FORM, OT21_NR_DOK
				) 					
				select 
					@p_BUKRS, @p_IMIE_NAZWISKO
					, @v_SERNR, @p_SERNR_POSKI
					, @v_POSNR, @p_POSNR_POSKI
					, @v_KOSTL, @p_KOSTL_POSKI
					, @v_GDLGRP, @p_GDLGRP_POSKI			
					, @p_MUZYTKID, @v_MUZYTK, @v_IF_STATUS, NULL, NULL, @p_ZMT_ROWID, @p_SAPUSER
					, @p_CZY_FORM, @p_NR_FORM, @p_TYP_DOK, @p_POZ_FORM, @p_NR_DOK
					
				select @v_OT21ID = IDENT_CURRENT('SAPO_ZWFOT21')

				--nowe linie wyposażenia OT do integracji w SAP (dane w  ZWFOTLN sie nie zmieniaja!!)
				insert into dbo.SAPO_ZWFOT21LN
				(  
					OT21LN_WART_NAB_PLN, OT21LN_DOSTAWCA, OT21LN_NR_DOW_DOSTAWY, OT21LN_DT_DOSTAWY, OT21LN_GRUPA, OT21LN_ANLN1, OT21LN_ANLN2, OT21LN_ZMT_ROWID, OT21LN_OT21ID, OT21LN_ZMT_OBJ_CODE,
					OT21LN_ILOSC, OT21LN_NZWYP, OT21LN_MUZYTK, OT21LN_NR_PRA_UZYTK, OT21LN_SKL_RUCH, OT21LN_ANLN1_POSKI
				)
				select
					OT21LN_WART_NAB_PLN, OT21LN_DOSTAWCA, OT21LN_NR_DOW_DOSTAWY, OT21LN_DT_DOSTAWY, OT21LN_GRUPA, OT21LN_ANLN1, OT21LN_ANLN2, OT21LN_ZMT_ROWID, @v_OT21ID, OT21LN_ZMT_OBJ_CODE,
					OT21LN_ILOSC, OT21LN_NZWYP, OT21LN_MUZYTK, OT21LN_NR_PRA_UZYTK, OT21LN_SKL_RUCH, OT21LN_ANLN1_POSKI
				from dbo.SAPO_ZWFOT21LN (nolock)
					 join dbo.SAPO_ZWFOT21 (nolock) on OT21_ROWID = OT21LN_OT21ID
  					 join dbo.ZWFOTLN (nolock) on OTL_ROWID = OT21LN_ZMT_ROWID
				where 
					OT21_ZMT_ROWID = @p_ZMT_ROWID 
					and OT21_IF_STATUS in (3,9)
					and isnull(OTL_NOTUSED,0) = 0  	
					 
				--zmiana statusu odrzuconego wniosku
				update dbo.SAPO_ZWFOT21 SET
 					OT21_IF_STATUS = 4  --archiwum
				where 
					OT21_ZMT_ROWID = @p_ZMT_ROWID 
					and OT21_IF_STATUS in (3,9)
 					
			end
			--nagłówek integracji (aktualizacja dla nagłówka integracji)
			else if 
				(@p_STATUS_old <> 'OT21_61' and @p_STATUS in ('OT21_10','OT21_20'))
				or (@p_STATUS_old = 'OT21_61' and @p_STATUS in ('OT21_20','OT21_61'))
			begin

				UPDATE dbo.SAPO_ZWFOT21 SET
					OT21_BUKRS = @p_BUKRS, OT21_IMIE_NAZWISKO = @p_IMIE_NAZWISKO
					, OT21_SERNR = @v_SERNR, OT21_SERNR_POSKI = @p_SERNR_POSKI
					, OT21_POSNR = @v_POSNR, OT21_POSNR_POSKI = @p_POSNR_POSKI
					, OT21_KOSTL = @v_KOSTL, OT21_KOSTL_POSKI = @p_KOSTL_POSKI
					, OT21_GDLGRP = @v_GDLGRP, OT21_GDLGRP_POSKI = @p_GDLGRP_POSKI		
					, OT21_MUZYTKID = @p_MUZYTKID, OT21_MUZYTK = @v_MUZYTK, OT21_IF_STATUS = @v_IF_STATUS, OT21_IF_SENTDATE = @p_IF_SENTDATE, OT21_IF_EQUNR = @p_IF_EQUNR, OT21_SAPUSER = @p_SAPUSER, ZMT_OBJ_CODE = @p_ZMT_OBJ_CODE
					, OT21_CZY_FORM = @p_CZY_FORM, OT21_NR_FORM = @p_NR_FORM, OT21_TYP_DOK = @p_TYP_DOK, OT21_POZ_FORM = @p_POZ_FORM, OT21_NR_DOK = @p_NR_DOK
				where OT21_ZMT_ROWID = @p_ZMT_ROWID and OT21_IF_STATUS not in (3,4)

			end

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