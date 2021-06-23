SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[ZWFOT32LN_Update_Proc]
(
	@p_FormID nvarchar(50), 
	@p_ROWID int,
	@p_OT32ID int,
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
	@p_ANLN1_PRZYJECIA_POSKI nvarchar(30), 
	@p_DT_WYDANIA datetime,
	@p_MPK_WYDANIA_POSKI nvarchar(30), 
	@p_GDLGRP_POSKI nvarchar(30), 
	@p_DT_PRZYJECIA datetime,
	@p_MPK_PRZYJECIA_POSKI nvarchar(10), 
	@p_UZYTKOWNIK_POSKI nvarchar(30), 
	@p_ZMT_ROWID int,
	@p_PRACOWNIK nvarchar(8), 

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
		, @v_ANLN1 nvarchar(12)
		, @v_ANLN1_PRZYJECIA nvarchar(12)
		, @v_GDLGRP nvarchar (30)
		, @v_MPK_WYDANIA nvarchar (30)
		, @v_UZYTKOWNIK nvarchar (30)
		, @v_MPK_PRZYJECIA nvarchar (10)
		, @v_KOSTL_POSKI nvarchar(40)
		 		
	set @v_date = getdate()
 	select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS
 	   
 	select @v_OTID = OT_ROWID from ZWFOT (nolock) join dbo.SAPO_ZWFOT32 (nolock) on OT32_ZMT_ROWID = OT_ROWID where OT32_ROWID = @p_OT32ID
 	select @v_OTL_COUNT = COUNT(*) from ZWFOTLN where OTL_OTID = @v_OTID   
 	
	--rzutowanie zmiennych z SAP (POSKI jest polem jedynie do wyświetlania 
 	select @v_ANLN1 = AST_SAP_ANLN1 from [dbo].[ASSET] where AST_CODE = @p_ANLN1_POSKI
	select @v_ANLN1_PRZYJECIA = AST_SAP_ANLN1 from [dbo].[ASSET] (nolock) where AST_CODE = @p_ANLN1_PRZYJECIA_POSKI 
	select @v_GDLGRP = KL5_SAP_GDLGRP from [dbo].[KLASYFIKATOR5] (nolock) where KL5_CODE = @p_GDLGRP_POSKI
	select @v_MPK_WYDANIA = CCD_SAP_KOSTL from [dbo].[COSTCODE] (nolock) where CCD_CODE = @p_MPK_WYDANIA_POSKI
	select @v_UZYTKOWNIK = KL5_SAP_GDLGRP from [dbo].[KLASYFIKATOR5] (nolock) where KL5_CODE = @p_UZYTKOWNIK_POSKI
	select @v_MPK_PRZYJECIA = CCD_SAP_KOSTL from [dbo].[COSTCODE] (nolock) where CCD_CODE = @p_MPK_PRZYJECIA_POSKI

	-- czy klucze niepuste
	if @p_ID is null or @v_OTID is null or @p_OT32ID is null-- ## dopisac klucze
	begin
		print @p_org
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
 
		--OBSŁUGA BŁĘDÓW słownikowych
		if not exists (select 1 from dbo.KLASYFIKATOR5 (nolock) where KL5_CODE = @p_GDLGRP_POSKI) begin
			select @v_errorcode = 'OT32LN_001' -- Wprowadzono niewłaściwego użytkownika wydania
			goto errorlabel end
		
		if not exists (select 1 from dbo.KLASYFIKATOR5 (nolock) where KL5_CODE = @p_UZYTKOWNIK_POSKI) begin
			select @v_errorcode = 'OT32LN_002' -- Wprowadzono niewłaściwego użytkownika przyjęcia
			goto errorlabel end

		if not exists (select 1 from dbo.COSTCODE (nolock) where CCD_CODE = @p_MPK_WYDANIA_POSKI) begin
			select @v_errorcode = 'OT32LN_003' -- Wprowadzono niewłaściwy numer MPK dla wydania
			goto errorlabel end

		if not exists (select 1 from dbo.COSTCODE (nolock) where CCD_CODE = @p_MPK_PRZYJECIA_POSKI) begin
			select @v_errorcode = 'OT32LN_004' -- Wprowadzono niewłaściwy numer MPK dla przyjęcia
			goto errorlabel end

		if (@p_ANLN1_POSKI = @p_ANLN1_PRZYJECIA_POSKI) begin
			select @v_errorcode = 'OT32LN_010' -- Nie można przenieść składnika na taki sam składnik
			goto errorlabel end
			
		set @v_KOSTL_POSKI = @p_MPK_WYDANIA_POSKI + '%'
		if @p_GDLGRP_POSKI not in (select KL5_CODE from KLASYFIKATOR5 where KL5_CODE like @v_KOSTL_POSKI)
		begin
			select @v_errorcode = 'OT32LN_005' -- czy użytkownik zgadza sie z mpk wydania
			goto errorlabel
		end
		
		set @v_KOSTL_POSKI = @p_MPK_PRZYJECIA_POSKI + '%'
		if @p_UZYTKOWNIK_POSKI not in (select KL5_CODE from KLASYFIKATOR5 where KL5_CODE like @v_KOSTL_POSKI)
		begin
			select @v_errorcode = 'OT32LN_006' -- czy użytkownik zgadza sie z mpk przyjęcia
			goto errorlabel
		end

		if exists (select 1 from dbo.SAPO_ZWFOT32LN(nolock) join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT32LN_ZMT_ROWID where 
				OT32LN_OT32ID = @p_OT32ID 
				and isnull(OTL_NOTUSED,0) = 0
				and OT32LN_ROWID <> isnull(@p_ROWID,0)
				and (OT32LN_MPK_WYDANIA_POSKI <> @p_MPK_WYDANIA_POSKI
				or OT32LN_GDLGRP_POSKI <> @p_GDLGRP_POSKI
				or OT32LN_MPK_PRZYJECIA_POSKI <> @p_MPK_PRZYJECIA_POSKI
				or OT32LN_UZYTKOWNIK_POSKI <> @p_UZYTKOWNIK_POSKI)) begin
			select @v_errorcode = 'OT32LN_007' -- Dokument MT1 może zostać wystawiony dla jednego MPK wydaniai jednego MPK przyjęcia
			goto errorlabel end
		
		if exists (select 1 from dbo.SAPO_ZWFOT32LN(nolock) join [dbo].[ZWFOTLN] (nolock) on OT32LN_ZMT_ROWID = OTL_ROWID where
				OT32LN_OT32ID = @p_OT32ID 
				and OT32LN_ANLN1_POSKI = @p_ANLN1_POSKI 
				and OT32LN_ROWID <> isnull(@p_ROWID,0)
				and isnull(OTL_NOTUSED,0) = 0) begin
 			select @v_errorcode = 'OT32LN_008' -- Dla tego składnika jest już wystawiony inny dokument
			goto errorlabel end
		if not exists (select 1 from dbo.ASSET (nolock) join COSTCODE (nolock) on AST_CCDID = CCD_ROWID where AST_CODE = @p_ANLN1_POSKI and CCD_CODE = @p_MPK_WYDANIA_POSKI and AST_SAP_GDLGRP = @p_GDLGRP_POSKI) begin
			select @v_errorcode = 'OT32LN_009' -- MPK/Użytkownik wydania niezgodny z numerem środka trwałego.
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
			insert into dbo.SAPO_ZWFOT32LN
			(  
				OT32LN_LP, OT32LN_BUKRS
				, OT32LN_ANLN1, OT32LN_ANLN1_POSKI
				, OT32LN_ANLN1_PRZYJECIA, OT32LN_ANLN1_PRZYJECIA_POSKI
				, OT32LN_DT_WYDANIA
				, OT32LN_MPK_WYDANIA, OT32LN_MPK_WYDANIA_POSKI
				, OT32LN_GDLGRP, OT32LN_GDLGRP_POSKI
				, OT32LN_DT_PRZYJECIA
				, OT32LN_MPK_PRZYJECIA, OT32LN_MPK_PRZYJECIA_POSKI
				, OT32LN_UZYTKOWNIK, OT32LN_UZYTKOWNIK_POSKI
				, OT32LN_ZMT_ROWID, OT32LN_PRACOWNIK, OT32LN_OT32ID
			) 		
			select distinct
				@v_OTL_COUNT+1, OT32_BUKRS
				, @v_ANLN1, @p_ANLN1_POSKI
				, @v_ANLN1_PRZYJECIA, @p_ANLN1_PRZYJECIA_POSKI
				, @p_DT_WYDANIA
				, @v_MPK_WYDANIA, @p_MPK_WYDANIA_POSKI
				, @v_GDLGRP, @p_GDLGRP_POSKI
				, @p_DT_PRZYJECIA
				, @v_MPK_PRZYJECIA, @p_MPK_PRZYJECIA_POSKI
				, @v_UZYTKOWNIK, @p_UZYTKOWNIK_POSKI		
				, @v_OTLID, @p_PRACOWNIK, @p_OT32ID
			from dbo.SAPO_ZWFOT32 (nolock)
			where OT32_ROWID = @p_OT32ID
			
			--aktualizacja nagłówka
			update [dbo].[ZWFOT]
			set
				OT_UPDUSER = @p_UserID,
				OT_UPDDATE = GETDATE()
			where OT_ROWID = @v_OTID
  
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT32LN_002' -- blad wstawienia
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
			
			update [dbo].[SAPO_ZWFOT32LN]
			set   
				OT32LN_LP = @v_OTL_COUNT+1
				, OT32LN_ANLN1 = @v_ANLN1, OT32LN_ANLN1_POSKI = @p_ANLN1_POSKI
				, OT32LN_ANLN1_PRZYJECIA = @v_ANLN1_PRZYJECIA, OT32LN_ANLN1_PRZYJECIA_POSKI = @p_ANLN1_PRZYJECIA_POSKI
				, OT32LN_DT_WYDANIA = @p_DT_WYDANIA
				, OT32LN_MPK_WYDANIA = @v_MPK_WYDANIA, OT32LN_MPK_WYDANIA_POSKI = @p_MPK_WYDANIA_POSKI 
				, OT32LN_GDLGRP = @v_GDLGRP, OT32LN_GDLGRP_POSKI = @p_GDLGRP_POSKI
				, OT32LN_DT_PRZYJECIA = @p_DT_PRZYJECIA
				, OT32LN_MPK_PRZYJECIA = @v_MPK_PRZYJECIA, OT32LN_MPK_PRZYJECIA_POSKI = @p_MPK_PRZYJECIA_POSKI
				, OT32LN_UZYTKOWNIK = @v_UZYTKOWNIK, OT32LN_UZYTKOWNIK_POSKI = @p_UZYTKOWNIK_POSKI
				, OT32LN_PRACOWNIK = @p_PRACOWNIK
			where
				OT32LN_ROWID = @p_ROWID
   
			--with a as
			--	(
			--		select OT32_ROWID, sum(OT32LN_WART_ELEME) suma
			--		from [dbo].[SAPO_ZWFOT32LN] (nolock) 
			--			join [dbo].[SAPO_ZWFOT32] (nolock) on OT32_ROWID = OT32LN_OT32ID
			--		where ot32ln_ot32id = @v_OT32ID
			--		group by OT32_ROWID
			--	)
			--update UPD set UPD.OT32_WART_TOTAL = suma 
			--	from [dbo].[SAPO_ZWFOT32] UPD
			--		join A on A.OT32_ROWID = UPD.OT32_ROWID
			--	where UPD.OT32_ROWID = A.OT32_ROWID

			--aktualizacja nagłówka
			update [dbo].[ZWFOT]
			set
				OT_UPDUSER = @p_UserID,
				OT_UPDDATE = GETDATE()
			where OT_ROWID = @v_OTID
			
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT32_002' -- blad aktualizacji 
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