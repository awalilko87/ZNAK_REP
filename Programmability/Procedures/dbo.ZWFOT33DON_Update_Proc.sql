SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT33DON_Update_Proc]
(
	@p_FormID nvarchar(50), 
	@p_ROWID int,
	@p_OT33ID int,
	@p_CODE nvarchar(30), 
	@p_ID nvarchar(50),
	@p_ORG nvarchar(30),
	@p_RSTATUS int,
	@p_STATUS nvarchar(30),
	@p_STATUS_old nvarchar(30),
	@p_TYPE nvarchar(30),
	@p_TXT50 nvarchar (50),
	@p_WARST decimal (13,2),
	@p_NDJARPER int,
	@p_MTOPER nvarchar(2),
	@p_ANLN1_POSKI nvarchar (30),
	@p_ANLN2 nvarchar (4),
	@p_ANLN1_DO_POSKI nvarchar (30),
	@p_ANLN2_DO nvarchar (4),
	@p_ANLKL_DO_POSKI nvarchar (8),
	@p_KOSTL_DO_POSKI nvarchar (10),
	@p_UZYTK_DO_POSKI nvarchar (8),
	@p_PRAC_DO int,
	@p_PRCNT_DO int,
	@p_WARST_DO decimal (13,2),
	@p_TXT50_DO nvarchar (50),
	@p_NDPER_DO int,
	@p_CHAR_DO nvarchar (50),
	@p_BELNR nvarchar (10),
	@p_ZMT_ROWID int,
	@p_STNID nvarchar(30),   
	@p_STS nvarchar(30), 
	@p_OT33_OPERATION nvarchar(2),
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
		, @v_OTDID int
		, @v_OTD_COUNT int =  0
		, @v_ANLN1_DO nvarchar (12)
		, @v_ANLKL_DO nvarchar(8)
		, @v_UZYTK_OD nvarchar(30)
		, @v_UZYTK_DO nvarchar(30)
		, @v_KOSTL_DO nvarchar(30)
		, @v_URWRT decimal(16,2)
		, @v_TXT50 nvarchar(50)

	set @v_date = getdate()
 	select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS
 	   
 	select @v_OTID = OT33_ZMT_ROWID from dbo.SAPO_ZWFOT33 where OT33_ROWID = @p_OT33ID
 	select @v_OTD_COUNT = COUNT(*) from ZWFOTDON where OTD_OTID = @v_OTID  
 	select @v_ANLN1_DO = AST_SAP_ANLN1 from [dbo].[ASSET] where AST_CODE = @p_ANLN1_DO_POSKI
	select @v_TXT50 = AST_DESC from [dbo].[ASSET] where AST_CODE = @p_ANLN1_POSKI and AST_SUBCODE = @p_ANLN2
	select @v_ANLKL_DO = CCF_SAP_ANLKL from [dbo].[COSTCLASSIFICATION] (nolock) where CCF_CODE = @p_ANLKL_DO_POSKI
	select @v_KOSTL_DO = CCD_SAP_KOSTL from [dbo].[COSTCODE] (nolock) where CCD_CODE = @p_KOSTL_DO_POSKI
	select @v_UZYTK_DO = KL5_SAP_GDLGRP from [dbo].[KLASYFIKATOR5] (nolock) where KL5_CODE = @p_UZYTK_DO_POSKI
	select @v_UZYTK_OD = OT33LN_GDLGRP from [dbo].[ZWFOT33LNv] where OT33LN_OT33ID = @p_OT33ID --jest zawsze tylko jeden
	select @v_URWRT = AST_SAP_URWRT from [dbo].[ASSET] (nolock) where AST_CODE = @p_ANLN1_POSKI and AST_SUBCODE = @p_ANLN2
	

	--if isnull(@v_URWRT,0.00) = 0.00
	--	select @p_PRCNT_DO = 100
	--else 
	--	select @p_PRCNT_DO = @p_WARST_DO/@v_URWRT * 10

		if IsNULL(@v_URWRT,0.00) <> 0.00

		select @p_PRCNT_DO = NULL
	else 
		select @p_PRCNT_DO = @p_WARST_DO/@v_URWRT * 10




	--Można na MT3 to wykonać
	--if isnull(@v_UZYTK_OD,'') =  isnull(@v_UZYTK_DO,'')
	--begin 
	--	select @v_errorcode = 'OT33DON_001'
	--	goto errorlabel
	--end
	
	if @p_ANLN2 = '0000' and @p_PRCNT_DO = 100 and exists
	(
		select ZWFOT33DONv.OT33DON_ANLN2 from ZWFOT33DONv
		left join 
			(select 
				OT33DON_MTOPER, OT33DON_ANLN2, OT33DON_ANLN1
			from 
				ZWFOT33DONv 
			where 
				OT33DON_ANLN1_POSKI = @p_ANLN1_POSKI and OT33DON_MTOPER = 'X') MTOPER_X
		on
			 MTOPER_X.OT33DON_ANLN2 = ZWFOT33DONv.OT33DON_ANLN2
		where  	
			isnull(MTOPER_X.OT33DON_MTOPER,'') <> 'X'
			and isnull(ZWFOT33DONv.OT33DON_MTOPER,'') <> 'X'  
			and OT33DON_ANLN1_POSKI = @p_ANLN1_POSKI
	)	 
	begin	
		select @v_errorcode = 'OT33DON_002' --Nie ma możliwości utworzenia MT3 dla przeniesienia 100% składnika głównego i pozostawienie doniesień
		--https://jira.eurotronic.net.pl/browse/PKNTA-201
		--select * from vs_langmsgs where objectid = 'OT33DON_002'
		goto errorlabel
	end
	 
	-- czy klucze niepuste
	if @p_ANLN1_POSKI is null or @p_ANLN2 is null or @p_OT33ID is null-- ## dopisac klucze
	begin 
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
 
	--tylko jedna pozycja może mieć MTOPER X
	update [dbo].[SAPO_ZWFOT33DON]
	set   
		OT33DON_MTOPER = '' 
	where
		OT33DON_ANLN2 <> @p_ANLN2 and 
		OT33DON_OT33ID = @p_OT33ID
		 
	
	--insert
	if not exists (select * from dbo.SAPO_ZWFOT33DON (nolock) where 
		OT33DON_ANLN2 = @p_ANLN2 and 
		OT33DON_OT33ID = @p_OT33ID)
	begin  
		BEGIN TRY

			--linia MT33 w ZMT
			insert into dbo.ZWFOTDON 
			(
				OTD_OTID, OTD_STATUS, OTD_RSTATUS, OTD_ID, OTD_ORG, OTD_CODE, OTD_TYPE, OTD_CREDATE, OTD_CREUSER, OTD_OBJID
			)
			select distinct
				@v_OTID, NULL, 0, @p_ID, @p_ORG, cast(@v_OT as nvarchar)+ '/' + cast(@v_OTD_COUNT+1 as nvarchar), NULL, getdate(), @p_UseriD, NULL
			from ZWFOT (nolock) where OT_ROWID = @v_OTID
  
			select @v_OTDID = IDENT_CURRENT('ZWFOTDON')


			--linia MT33 do integracji w SAP
			insert into dbo.SAPO_ZWFOT33DON
			(  
				OT33DON_TXT50
				, OT33DON_WARST
				, OT33DON_NDJARPER
				, OT33DON_MTOPER
				, OT33DON_ANLN1_DO
				, OT33DON_ANLN1_DO_POSKI
				, OT33DON_ANLN2
				, OT33DON_ANLN2_DO
				, OT33DON_ANLKL_DO
				, OT33DON_ANLKL_DO_POSKI
				, OT33DON_KOSTL_DO
				, OT33DON_KOSTL_DO_POSKI
				, OT33DON_UZYTK_DO
				, OT33DON_UZYTK_DO_POSKI
				, OT33DON_PRAC_DO
				, OT33DON_PRCNT_DO
				, OT33DON_WARST_DO
				, OT33DON_TXT50_DO
				, OT33DON_NDPER_DO
				, OT33DON_CHAR_DO
				, OT33DON_BELNR
				, OT33DON_ZMT_ROWID, OT33DON_OT33ID
			) 		
			select distinct
				  @v_TXT50
				, @p_WARST
				, @p_NDJARPER
				, 'X'--@p_MTOPER 
				, @v_ANLN1_DO
				, @p_ANLN1_DO_POSKI
				, @p_ANLN2
				, @p_ANLN2_DO
				, @v_ANLKL_DO
				, @p_ANLKL_DO_POSKI
				, @v_KOSTL_DO
				, @p_KOSTL_DO_POSKI
				, @v_UZYTK_DO
				, @p_UZYTK_DO_POSKI
				, @p_PRAC_DO
				, @p_PRCNT_DO
				, @p_WARST_DO
				, @p_TXT50_DO
				, @p_NDPER_DO
				, @p_CHAR_DO
				, @p_BELNR
				, @v_OTDID, @p_OT33ID
			from dbo.SAPO_ZWFOT33 (nolock)
			where OT33_ROWID = @p_OT33ID

			if (@p_OT33_OPERATION in (1, 3, 5, 7))
			begin
				-- tworzenie nowego składnika
				exec [dbo].[ZWFOT33_ADD_OBJ_Proc] @p_FormID, @v_OTDID, @p_STNID, @p_STS, @p_UserID
			end

			insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OBJID, OTO_ASTCODE, OTO_ASTSUBCODE, OTO_CREUSER, OTO_CREDATE)
			select @v_OTID, OBJ_ROWID, AST_CODE, AST_SUBCODE, @p_UserID, getdate()
			from dbo.OBJASSETv
			where AST_CODE = @p_ANLN1_POSKI and AST_SUBCODE = @p_ANLN2 and AST_NOTUSED = 0 and OBJ_CODE = isnull(@p_OBJ, OBJ_CODE)
			and not exists (select 1 from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID and OTO_OBJID = OBJ_ROWID)
  
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT33_001' -- blad wstawienia
			goto errorlabel
		END CATCH;	 
		 
	end
	else
	begin
	  
		BEGIN TRY
		 
			--nagłówek select * from [ZWFOTDON]
			update [dbo].[ZWFOTDON]
			set 
				OTD_OTID = @v_OTID, 
				OTD_STATUS = @P_STATUS, 
				OTD_RSTATUS = @v_RSTATUS,  
				OTD_ORG = @P_ORG, 
				OTD_CODE = @P_CODE, 
				OTD_TYPE = @p_TYPE, 
				OTD_UPDDATE = @v_date, 
				OTD_UPDUSER = @p_UserID
 
			where OTD_ID = @p_ID
			 
			update [dbo].[SAPO_ZWFOT33DON]
			set   
			
				OT33DON_TXT50 = @v_TXT50
				, OT33DON_WARST = @p_WARST
				, OT33DON_NDJARPER = @p_NDJARPER
				, OT33DON_MTOPER = 'X'--@p_MTOPER 
				, OT33DON_ANLN1_DO = @v_ANLN1_DO
				, OT33DON_ANLN1_DO_POSKI = @p_ANLN1_DO_POSKI
				, OT33DON_ANLN2 = @p_ANLN2
				, OT33DON_ANLN2_DO = @p_ANLN2_DO
				, OT33DON_ANLKL_DO = @v_ANLKL_DO
				, OT33DON_ANLKL_DO_POSKI = @p_ANLKL_DO_POSKI
				, OT33DON_KOSTL_DO = @v_KOSTL_DO
				, OT33DON_KOSTL_DO_POSKI = @p_KOSTL_DO_POSKI
				, OT33DON_UZYTK_DO = @v_UZYTK_DO
				, OT33DON_UZYTK_DO_POSKI = @p_UZYTK_DO_POSKI
				, OT33DON_PRAC_DO = @p_PRAC_DO
				, OT33DON_PRCNT_DO = @p_PRCNT_DO
				, OT33DON_WARST_DO = @p_WARST_DO
				, OT33DON_TXT50_DO = @p_TXT50_DO
				, OT33DON_NDPER_DO = @p_NDPER_DO
				, OT33DON_CHAR_DO = @p_CHAR_DO
				, OT33DON_BELNR = @p_BELNR
			
			where
				OT33DON_ANLN2 = @p_ANLN2 and 
				OT33DON_OT33ID = @p_OT33ID


				select @v_OTDID = OTD_ROWID from [dbo].[ZWFOTDON] where OTD_ID = @p_ID

				-- usuwanie wcześniej założonego składnika
				declare @v_OBJID int
				select @v_OBJID = OBJ_ROWID from [dbo].[OBJ] where OBJ_OT33ID = @v_OTDID

				delete from [dbo].[PROPERTYVALUES] where PRV_ENT = 'OBJ' and PRV_PKID = @v_OBJID

				delete from [dbo].[OBJSTATION] where OSA_OBJID = @v_OBJID

				delete from [dbo].[OBJ] where OBJ_ROWID = @v_OBJID
				

				if (@p_OT33_OPERATION in (1, 3, 5, 7) and not exists (select 1 from [dbo].[OBJ] where OBJ_OT33ID = @v_OTDID))
				begin
					-- tworzenie nowego składnika
					exec [dbo].[ZWFOT33_ADD_OBJ_Proc] @p_FormID, @v_OTDID, @p_STNID, @p_STS, @p_UserID
				end

				insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OBJID, OTO_ASTCODE, OTO_ASTSUBCODE, OTO_CREUSER, OTO_CREDATE)
				select @v_OTID, OBJ_ROWID, AST_CODE, AST_SUBCODE, @p_UserID, getdate()
				from dbo.OBJASSETv
				where AST_CODE = @p_ANLN1_POSKI and AST_SUBCODE = @p_ANLN2 and AST_NOTUSED = 0 and OBJ_CODE = @p_OBJ
				and not exists (select 1 from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID and OTO_OBJID = OBJ_ROWID)
				
   
			--with a as
			--	(
			--		select OT33_ROWID, sum(OT33DON_WART_ELEME) suma
			--		from [dbo].[SAPO_ZWFOT33DON] (nolock) 
			--			join [dbo].[SAPO_ZWFOT33] (nolock) on OT33_ROWID = OT33DON_OT33ID
			--		where OT33DON_ot33id = @v_OT33ID
			--		group by OT33_ROWID
			--	)
			--update UPD set UPD.OT33_WART_TOTAL = suma 
			--	from [dbo].[SAPO_ZWFOT33] UPD
			--		join A on A.OT33_ROWID = UPD.OT33_ROWID
			--	where UPD.OT33_ROWID = A.OT33_ROWID

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT33_003' -- blad aktualizacji 
			goto errorlabel
		END CATCH;
		 
	end

    --Aktualizacja doniesień (przy każdym zapisie musi zapewnić aktualność tych danych z SAP
	exec dbo.ZWFOT33DON_Recalculate @p_OT33ID = @p_OT33ID
		
	return 0

	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1

end
GO