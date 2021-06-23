SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT31LN_Update_Proc]
(
	@p_FormID nvarchar(50), 
	@p_ROWID int,
	@p_OT31ID int,
	@p_CODE nvarchar(30), 
	@p_ID nvarchar(50),
	@p_ORG nvarchar(30),
	@p_RSTATUS int,
	@p_STATUS nvarchar(30),
	@p_STATUS_old nvarchar(30),
	@p_TYPE nvarchar(30),
 	@p_LP int,
	@p_BUKRS nvarchar(30), 
	@p_ANLN1_POSKI nvarchar(30), 
	@p_UZASADNIENIE nvarchar(200), 
	@p_DT_WYDANIA datetime,
	@p_MPK_WYDANIA_POSKI nvarchar(30), 
	@p_GDLGRP_POSKI nvarchar(30), 
	@p_DT_PRZYJECIA datetime,
	@p_MPK_PRZYJECIA_POSKI nvarchar(10), 
	@p_UZYTKOWNIK_POSKI nvarchar(30), 
	@p_ZMT_ROWID int,
	@p_PRACOWNIK nvarchar(8), 
	@p_OBJ nvarchar(30),

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
		--, @v_ITSID int
		, @v_OTID int
		, @v_OT nvarchar(30)
		, @v_OTLID int
		, @v_OTL_COUNT int =  0
		, @v_ANLN1 nvarchar(30)
		, @v_MPK_WYDANIA nvarchar(30)
		, @v_GDLGRP nvarchar(30)
		, @v_MPK_PRZYJECIA nvarchar(30) 
		, @v_UZYTKOWNIK nvarchar(30)
		, @v_KOSTL_POSKI nvarchar(40)
		
 
	set @v_date = getdate()
 	select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS
 	   
 	select @v_OTID = OT31_ZMT_ROWID from dbo.SAPO_ZWFOT31 (nolock) where OT31_ROWID = @p_OT31ID
 	select @v_OTL_COUNT = COUNT(*) from ZWFOTLN where OTL_OTID = @v_OTID 
 	    
	select @v_ANLN1 = AST_SAP_ANLN1 from [dbo].[ASSET] (nolock) where AST_CODE = @p_ANLN1_POSKI
	select @v_MPK_WYDANIA = CCD_SAP_KOSTL from [dbo].[COSTCODE] (nolock) where CCD_CODE = @p_MPK_WYDANIA_POSKI
	select @v_GDLGRP = KL5_SAP_GDLGRP from [dbo].[KLASYFIKATOR5] (nolock) where KL5_CODE = @p_GDLGRP_POSKI
	select @v_MPK_PRZYJECIA = CCD_SAP_KOSTL from [dbo].[COSTCODE] (nolock) where CCD_CODE = @p_MPK_PRZYJECIA_POSKI
	select @v_UZYTKOWNIK = KL5_SAP_GDLGRP from [dbo].[KLASYFIKATOR5] (nolock) where KL5_CODE = @p_UZYTKOWNIK_POSKI

	-- czy klucze niepuste
	if @p_ID is null or @v_OTID is null or @p_OT31ID is null-- ## dopisac klucze
	begin 
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
		
		--OBSŁUGA BŁĘDÓW słownikowych


		--if not exists (select 1 from dbo.KLASYFIKATOR5 (nolock) where KL5_CODE = @p_GDLGRP_POSKI) begin
		--	select @v_errorcode = 'OT31LN_001' -- Wprowadzono niewłaściwego użytkownika wydania
		--	goto errorlabel end
		
		--if not exists (select 1 from dbo.KLASYFIKATOR5 (nolock) where KL5_CODE = @p_UZYTKOWNIK_POSKI) begin
		--	select @v_errorcode = 'OT31LN_002' -- Wprowadzono niewłaściwego użytkownika przyjęcia
		--	goto errorlabel end

		if not exists (select 1 from dbo.COSTCODE (nolock) where CCD_CODE = @p_MPK_WYDANIA_POSKI) begin
			select @v_errorcode = 'OT31LN_003' -- Wprowadzono niewłaściwy numer MPK dla wydania
			goto errorlabel end

		if not exists (select 1 from dbo.COSTCODE (nolock) where CCD_CODE = @p_MPK_PRZYJECIA_POSKI) begin
			select @v_errorcode = 'OT31LN_004' -- Wprowadzono niewłaściwy numer MPK dla przyjęcia
			goto errorlabel end
			
		set @v_KOSTL_POSKI = @p_MPK_WYDANIA_POSKI + '%'
		if @p_GDLGRP_POSKI not in (select KL5_CODE from KLASYFIKATOR5 where KL5_CODE like @v_KOSTL_POSKI)
		begin
			select @v_errorcode = 'OT31LN_005' -- czy użytkownik zgadza sie z mpk wydania
			goto errorlabel
		end
		
		set @v_KOSTL_POSKI = @p_MPK_PRZYJECIA_POSKI + '%'
		if @p_UZYTKOWNIK_POSKI not in (select KL5_CODE from KLASYFIKATOR5 where KL5_CODE like @v_KOSTL_POSKI)
		begin
			select @v_errorcode = 'OT31LN_006' -- czy użytkownik zgadza sie z mpk przyjęcia
			goto errorlabel
		end
			
		if isnull(@p_GDLGRP_POSKI,'') =  isnull(@p_UZYTKOWNIK_POSKI,'')
		begin 
			select @v_errorcode = 'OT31LN_010'--Wprowadzono przeniesienie z tego samego miejsca użytkownia co aktualnie.
			--select * from vs_langmsgs where objectid = 'OT31LN_006'
			goto errorlabel
		end
	
		if exists (select 1 from dbo.SAPO_ZWFOT31LN(nolock) join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT31LN_ZMT_ROWID where 
				OT31LN_OT31ID = @p_OT31ID 
				and OT31LN_ROWID <> isnull(@p_ROWID,0)
				and (OT31LN_MPK_WYDANIA_POSKI <> @p_MPK_WYDANIA_POSKI
				and isnull(OTL_NOTUSED,0) = 0
				or OT31LN_GDLGRP_POSKI <> @p_GDLGRP_POSKI
				or OT31LN_MPK_PRZYJECIA_POSKI <> @p_MPK_PRZYJECIA_POSKI
				or OT31LN_UZYTKOWNIK_POSKI <> @p_UZYTKOWNIK_POSKI)) begin
			select @v_errorcode = 'OT31LN_007' -- Dokument MT1 może zostać wystawiony dla jednego MPK wydaniai jednego MPK przyjęcia
			goto errorlabel end
		
		if exists (select 1 from dbo.SAPO_ZWFOT31LN(nolock) join [dbo].[ZWFOTLN] (nolock) on OT31LN_ZMT_ROWID = OTL_ROWID where
				OT31LN_OT31ID = @p_OT31ID 
				and OT31LN_ANLN1_POSKI = @p_ANLN1_POSKI 
				and OT31LN_ROWID <> isnull(@p_ROWID,0)
				and isnull(OTL_NOTUSED,0) = 0) begin
 			select @v_errorcode = 'OT31LN_008' -- Dla tego składnika jest już wystawiony inny dokument
			goto errorlabel end
		if not exists (select 1 from dbo.ASSET (nolock) join COSTCODE (nolock) on AST_CCDID = CCD_ROWID where AST_CODE = @p_ANLN1_POSKI and CCD_CODE = @p_MPK_WYDANIA_POSKI and AST_SAP_GDLGRP = @p_GDLGRP_POSKI) begin 
			select @v_errorcode = 'OT31LN_009' -- MPK/Użytkownik wydania niezgodny z numerem środka trwałego.
			goto errorlabel end
		
	--insert
	if not exists (select * from dbo.ZWFOTLN (nolock) where OTL_ID = @p_ID)
	begin  
		BEGIN TRY

			--linia protokołu PL w ZMT
			insert into dbo.ZWFOTLN 
			(
				OTL_OTID, OTL_STATUS, OTL_RSTATUS, OTL_ID, OTL_ORG, OTL_CODE, OTL_TYPE, OTL_CREDATE, OTL_CREUSER, OTL_OBJID
			)
			select distinct
				@v_OTID, NULL, 0, @p_ID, @p_ORG, cast(@v_OT as nvarchar)+ '/' + cast(@v_OTL_COUNT+1 as nvarchar), NULL, getdate(), @p_UseriD, NULL
			from ZWFOT (nolock) where OT_ROWID = @v_OTID
  
			select @v_OTLID = SCOPE_IDENTITY()
			 
			--linia protokołu PL do integracji w SAP
			insert into dbo.SAPO_ZWFOT31LN
			(  
				OT31LN_LP, OT31LN_BUKRS, OT31LN_UZASADNIENIE, OT31LN_DT_WYDANIA, OT31LN_DT_PRZYJECIA
				, OT31LN_ANLN1, OT31LN_ANLN1_POSKI
				, OT31LN_MPK_WYDANIA, OT31LN_MPK_WYDANIA_POSKI
				, OT31LN_GDLGRP, OT31LN_GDLGRP_POSKI
				, OT31LN_MPK_PRZYJECIA, OT31LN_MPK_PRZYJECIA_POSKI
				, OT31LN_UZYTKOWNIK, OT31LN_UZYTKOWNIK_POSKI
				, OT31LN_ZMT_ROWID, OT31LN_PRACOWNIK, OT31LN_OT31ID
			) 	
			select distinct
				@v_OTL_COUNT+1, OT31_BUKRS, right(@p_UZASADNIENIE,50) , @p_DT_WYDANIA, @p_DT_PRZYJECIA	
				, @v_ANLN1, @p_ANLN1_POSKI
				, @v_MPK_WYDANIA, @p_MPK_WYDANIA_POSKI
				, @v_GDLGRP, @p_GDLGRP_POSKI
				, @v_MPK_PRZYJECIA, @p_MPK_PRZYJECIA_POSKI
				, @v_UZYTKOWNIK, @p_UZYTKOWNIK_POSKI			
				, @v_OTLID, @p_PRACOWNIK, @p_OT31ID
			from dbo.SAPO_ZWFOT31 (nolock)
			where OT31_ROWID = @p_OT31ID

			insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OTLID, OTO_OBJID, OTO_ASTCODE, OTO_ASTSUBCODE, OTO_CREUSER, OTO_CREDATE)
			select @v_OTID, @v_OTLID, OBJ_ROWID, AST_CODE, min(AST_SUBCODE), @p_UserID, getdate()
			from dbo.OBJASSETv
			where AST_CODE = @p_ANLN1_POSKI and AST_NOTUSED = 0	and OBJ_CODE = isnull(@p_OBJ, OBJ_CODE)
			and not exists (select 1 from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID and OTO_OBJID = OBJ_ROWID)
			group by OBJ_ROWID, AST_CODE
 
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT31LN_INSERT' -- blad wstawienia
			goto errorlabel
		END CATCH;	 
		 
	end
	else
	begin
	  
		BEGIN TRY
		 
			--nagłówek
			update [dbo].[ZWFOTLN]
			set 
				OTL_OTID = @v_OTID, 
				OTL_STATUS = @P_STATUS, 
				OTL_RSTATUS = @v_RSTATUS,  
				OTL_ORG = @P_ORG, 
				OTL_CODE = @P_CODE, 
				OTL_TYPE = @p_TYPE, 
				OTL_UPDDATE = @v_date, 
				OTL_UPDUSER = @p_UserID
 
			where OTL_ID = @P_ID
			
			update [dbo].[SAPO_ZWFOT31LN]
			set   
				OT31LN_LP = @v_OTL_COUNT+1   
				, OT31LN_UZASADNIENIE = @p_UZASADNIENIE
				, OT31LN_DT_WYDANIA = @p_DT_WYDANIA
				, OT31LN_DT_PRZYJECIA = @p_DT_PRZYJECIA
				
				, OT31LN_ANLN1 = @v_ANLN1, OT31LN_ANLN1_POSKI = @p_ANLN1_POSKI
				, OT31LN_MPK_WYDANIA = @v_MPK_WYDANIA, OT31LN_MPK_WYDANIA_POSKI = @p_MPK_WYDANIA_POSKI
				, OT31LN_GDLGRP = @v_GDLGRP, OT31LN_GDLGRP_POSKI = @p_GDLGRP_POSKI
				, OT31LN_MPK_PRZYJECIA = @v_MPK_PRZYJECIA, OT31LN_MPK_PRZYJECIA_POSKI = @p_MPK_PRZYJECIA_POSKI
				, OT31LN_UZYTKOWNIK = @v_UZYTKOWNIK, OT31LN_UZYTKOWNIK_POSKI = @p_UZYTKOWNIK_POSKI
 						
				, OT31LN_PRACOWNIK = @p_PRACOWNIK
			where
				OT31LN_ROWID = @p_ROWID
 
			--with a as
			--	(
			--		select OT31_ROWID, sum(OT31LN_WART_ELEME) suma
			--		from [dbo].[SAPO_ZWFOT31LN] (nolock) 
			--			join [dbo].[SAPO_ZWFOT31] (nolock) on OT31_ROWID = OT31LN_OT31ID
			--		where ot31ln_ot31id = @v_OT31ID
			--		group by OT31_ROWID
			--	)
			--update UPD set UPD.OT31_WART_TOTAL = suma 
			--	from [dbo].[SAPO_ZWFOT31] UPD
			--		join A on A.OT31_ROWID = UPD.OT31_ROWID
			--	where UPD.OT31_ROWID = A.OT31_ROWID

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT31LN_UPDATE' -- blad aktualizacji 
			goto errorlabel
		END CATCH;
		 
	end

    --Aktualizacja doniesień (przy każdym zapisie musi zapewnić aktualność tych danych z SAP
	exec dbo.ZWFOT31DON_Recalculate @p_OT31ID = @p_OT31ID
			
	return 0

	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1

end
GO