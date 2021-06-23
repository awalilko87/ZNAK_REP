SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT40_Update_Proc] 
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
	@p_KROK nvarchar(10),
	@p_BUKRS nvarchar(30),
	@p_PL_DOC_NUM nvarchar(30),
	@p_PL_DOC_YEAR int,
	@p_IF_EQUNR nvarchar(30),
	@p_IF_SENTDATE datetime,
	@p_IF_STATUS int,
	@p_SAPUSER nvarchar(12),
	@p_IMIE_NAZWISKO nvarchar(80),
	@p_ZMT_ROWID int,
 
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
		@v_OT nvarchar(30),
		@v_IF_STATUS int,
		@v_RSTATUS int, 
		@v_ITSID int,
		@v_MUZYTK nvarchar(30),
		@v_OT40ID int,
		@v_OTLID int,
		@v_OTL_COUNT int,
		@v_PL_OTID int,
		@v_AKCJA nvarchar(20)
		
	declare
		@c_PLLN_OTID int,
		@c_PLLN_BUKRS nvarchar(30), 
		@c_PLLN_OT42LN_ANLN1 nvarchar(40), 
		@c_PLLN_OT42LN_ANLN1_POSKI nvarchar(30), 
		@c_PLLN_OT42LN_ANLN2 nvarchar(4), 
		@c_PLLN_OT42LN_PROC decimal(10,2)
	
	if @p_STATUS = 'OT40_60'
		set @p_STATUS = 'OT40_61' --odblokowanie dokumentu (procedura zakłada nowe pozycje do integracji)
 
	select @v_IF_STATUS = case 
		when @p_STATUS = 'OT40_10' then 0
		when @p_STATUS = 'OT40_61' then 0
		when @p_STATUS = 'OT40_20' then 1
		when @p_STATUS = 'OT40_70' and isnull(@p_IF_EQUNR, '0000000000') <> '0000000000' then 1
		else @p_IF_STATUS
	end
	
	select @p_SAPUSER = @p_IMIE_NAZWISKO 
 
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

	select @v_PL_OTID = OT42_ZMT_ROWID from dbo.SAPO_ZWFOT42 where OT42_IF_EQUNR = @p_PL_DOC_NUM and OT42_IF_YEAR = @p_PL_DOC_YEAR

	set @v_date = getdate()
  	     
	--insert
	if not exists (select * from dbo.ZWFOT (nolock) where OT_ID = @p_ID)
	begin
	  
		--Nagłówek (jeden dla wszystkich dokumentów do integracji)
		BEGIN TRY
			insert into dbo.ZWFOT  
			( 
				OT_STATUS, OT_RSTATUS, OT_ID, OT_ORG, OT_CODE, OT_TYPE, OT_CREDATE, OT_CREUSER, OT_ITSID, OT_PSPID
			)
			select 
				@p_STATUS, @v_RSTATUS, @P_ID, @P_ORG, LEFT(NEWID(),5), 'SAPO_ZWFOT40', GETDATE(), @p_UserID, @v_ITSID, NULL

			select @v_OTID = IDENT_CURRENT('ZWFOT')

		   if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')     
		   begin    
				exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = '-', @p_UserID = @p_UserID    
		   end  
		   
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT40_001' -- blad wstawienia
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
			insert into dbo.SAPO_ZWFOT40
			(  
				OT40_KROK,OT40_BUKRS,OT40_IMIE_NAZWISKO,OT40_SAPUSER,
 				OT40_PL_DOC_NUM, OT40_PL_DOC_YEAR, 
				OT40_IF_STATUS,OT40_IF_SENTDATE,OT40_IF_EQUNR,OT40_ZMT_ROWID
			) 		
			select  
				@p_KROK,@p_BUKRS,@p_IMIE_NAZWISKO,@p_SAPUSER,
				@p_PL_DOC_NUM, @p_PL_DOC_YEAR, 
				0,NULL,NULL,@v_OTID

			select @v_OT40ID = IDENT_CURRENT('SAPO_ZWFOT40')
 
			---------------------------------------------------------------------------------------------------------------------------------
			-------------------------------------------------tu dajemy kursor z pozycji PL!!-------------------------------------------------
			---------------------------------------------------------------------------------------------------------------------------------
			declare c_PL_LINES cursor for
			select
				OT_ROWID, OT42LN_BUKRS, OT42LN_ANLN1, OT42LN_ANLN1_POSKI, OT42LN_ANLN2, OT42LN_PROC
			from dbo.SAPO_ZWFOT42LN (nolock) 
			join dbo.ZWFOT42v (nolock) on  OT42_ROWID = OT42LN_OT42ID
			join dbo.ZWFOTLN on OTL_ROWID = OT42LN_ZMT_ROWID and OTL_NOTUSED = 0
			where
				OT42_DOC_NUM = @p_PL_DOC_NUM	
				and OT42_DOC_YEAR = @p_PL_DOC_YEAR
			
			open c_PL_LINES
			
			fetch next from c_PL_LINES
			into  @c_PLLN_OTID, @c_PLLN_BUKRS, @c_PLLN_OT42LN_ANLN1, @c_PLLN_OT42LN_ANLN1_POSKI, @c_PLLN_OT42LN_ANLN2, @c_PLLN_OT42LN_PROC
			
			while @@FETCH_STATUS = 0
			begin
			
				select @v_OT = OT_CODE from ZWFOT (nolock) where OT_ROWID = @v_OTID
				select @v_OTL_COUNT = COUNT(*) from ZWFOTLN (nolock) where OTL_OTID = @v_OTID
				
				insert into dbo.ZWFOTLN 
				(
					OTL_OTID, OTL_STATUS, OTL_RSTATUS, OTL_ID, OTL_ORG, OTL_CODE, OTL_TYPE, OTL_CREDATE, OTL_CREUSER, OTL_OBJID, OTL_OTLID
				)
				select distinct
					@v_OTID, NULL, 0, NEWID(), @p_ORG, cast(@v_OT as nvarchar)+ '/' + cast(@v_OTL_COUNT+1 as nvarchar), NULL, getdate(), @p_UseriD, NULL, @c_PLLN_OTID
				from ZWFOT (nolock) where OT_ROWID = @v_OTID
	 
				select @v_OTLID = SCOPE_IDENTITY()
			 
				insert into dbo.SAPO_ZWFOT40LN(
					OT40LN_BUKRS, 
					OT40LN_ANLN1, 
					OT40LN_ANLN1_POSKI,
					OT40LN_ANLN2, 
					OT40LN_PROC, 
					OT40LN_OPIS,
					OT40LN_ZMT_ROWID,
					OT40LN_OT40ID)
				select 
					@c_PLLN_BUKRS, 
					@c_PLLN_OT42LN_ANLN1, 
					@c_PLLN_OT42LN_ANLN1_POSKI, 
					@c_PLLN_OT42LN_ANLN2, 
					@c_PLLN_OT42LN_PROC, 
					'',
					@v_OTLID,
					@v_OT40ID

				insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OTLID, OTO_OBJID, OTO_ASTCODE, OTO_ASTSUBCODE, OTO_CREUSER, OTO_CREDATE)
				select @v_OTID, @v_OTLID, OBJ_ROWID, AST_CODE, AST_SUBCODE, @p_UserID, getdate()
				from dbo.OBJASSETv
				cross apply (select OTO_OBJID obid from dbo.ZWFOTOBJ where OTO_OTID = @v_PL_OTID and OTO_ASTCODE = AST_CODE and OTO_ASTSUBCODE = AST_SUBCODE and OTO_OBJID = OBJ_ROWID)pl_obj
				where AST_CODE = @c_PLLN_OT42LN_ANLN1_POSKI and AST_SUBCODE = @c_PLLN_OT42LN_ANLN2 and AST_NOTUSED = 0
				and not exists (select 1 from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID and OTO_OBJID = OBJ_ROWID)
					
				fetch next from c_PL_LINES
				into  @c_PLLN_OTID, @c_PLLN_BUKRS, @c_PLLN_OT42LN_ANLN1, @c_PLLN_OT42LN_ANLN1_POSKI, @c_PLLN_OT42LN_ANLN2, @c_PLLN_OT42LN_PROC
			
			end
			
			close c_PL_LINES
			deallocate c_PL_LINES	
			
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT40_002' -- blad wstawienia
			goto errorlabel
		END CATCH;

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
			select @v_errorcode = 'SYS_040' -- blad wspoluzytkowania
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
				OT_ITSID = @v_ITSID, 
				OT_PSPID = NULL

			where OT_ID = @P_ID
			
		   if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')     
		   begin    
				exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = '-', @p_UserID = @p_UserID    
		   end  			
			
			--w takim przypadku wysyła nowy dokument (wraca ze statusu OT40_60 - Anulowany, z SAPa dostał status 9 - błąd)
			if  @p_STATUS_old = 'OT40_60' and @p_STATUS_old <> @p_STATUS and @p_IF_STATUS in (3,9)
			begin

				insert into dbo.SAPO_ZWFOT40
				(  
					OT40_KROK,OT40_BUKRS,OT40_IMIE_NAZWISKO,OT40_SAPUSER,
					OT40_PL_DOC_NUM, OT40_PL_DOC_YEAR, 
					OT40_IF_STATUS,OT40_IF_SENTDATE,OT40_IF_EQUNR,OT40_ZMT_ROWID
				) 		
				select  
					@p_KROK,@p_BUKRS,@p_IMIE_NAZWISKO,@p_SAPUSER,
					@p_PL_DOC_NUM, @p_PL_DOC_YEAR, 
					@v_IF_STATUS,NULL,nullif(@p_IF_EQUNR, 'Brak w SAP'),@p_ZMT_ROWID
				
				select @v_OT40ID = IDENT_CURRENT('SAPO_ZWFOT40')
 
				--nowe linie kompletacji OT do integracji w SAP (dane w  ZWFOTLN sie nie zmieniaja!!)
				insert into dbo.SAPO_ZWFOT40LN
				(  
					OT40LN_BUKRS, OT40LN_ANLN1, OT40LN_ANLN2, OT40LN_PROC, OT40LN_OPIS,
					OT40LN_ZMT_ROWID, OT40LN_OT40ID,
	 				OT40LN_ANLN1_POSKI
					
				) 		
				select
					OT40LN_BUKRS, OT40LN_ANLN1, OT40LN_ANLN2, OT40LN_PROC, OT40LN_OPIS,
	 				OT40LN_ZMT_ROWID, @v_OT40ID,
	 				OT40LN_ANLN1_POSKI
				from dbo.SAPO_ZWFOT40LN (nolock)
					 join dbo.SAPO_ZWFOT40 (nolock) on OT40_ROWID = OT40LN_OT40ID
					 join dbo.ZWFOTLN (nolock) on OTL_ROWID = OT40LN_ZMT_ROWID
				where 
					OT40_ZMT_ROWID = @p_ZMT_ROWID 
					and OT40_IF_STATUS in (3,9)
					and isnull(OTL_NOTUSED,0) = 0
					
				update dbo.SAPO_ZWFOT40 SET
 					OT40_IF_STATUS = 4  
				where 
					OT40_ZMT_ROWID = @p_ZMT_ROWID
					and OT40_IF_STATUS in (3,9)
 
				
			end
			--nagłówek integracji (aktualizacja dla nagłówka integracji)
			else if 
				(@p_STATUS_old <> 'OT40_61' and @p_STATUS in ('OT40_10','OT40_20'))
				or (@p_STATUS_old = 'OT40_61' and @p_STATUS in ('OT40_20','OT40_61','OT40_70'))
			begin

				set @v_AKCJA = case
								when @p_STATUS = 'OT40_70' then 'ODRZ'
								when @p_IF_EQUNR is not null then 'AKT'
								else null
							end
									
 
				UPDATE dbo.SAPO_ZWFOT40 SET
					OT40_KROK = @p_KROK,
					OT40_BUKRS = @p_BUKRS,
					OT40_IMIE_NAZWISKO = @p_IMIE_NAZWISKO,
					OT40_SAPUSER = @p_SAPUSER,
					OT40_PL_DOC_NUM = @p_PL_DOC_NUM, 
					OT40_PL_DOC_YEAR = @p_PL_DOC_YEAR, 
					OT40_IF_STATUS = @v_IF_STATUS,
					OT40_IF_AKCJA = @v_AKCJA
				where OT40_ZMT_ROWID = @p_ZMT_ROWID and OT40_IF_STATUS not in (3,4)

			end

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT40_002' -- blad aktualizacji 
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