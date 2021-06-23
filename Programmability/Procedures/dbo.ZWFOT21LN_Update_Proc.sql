SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT21LN_Update_Proc]
(
	@p_FormID nvarchar(50), 
	@p_ROWID int, 
	@p_OT21ID int,
	@p_OBJID int,
	@p_CODE nvarchar(30), 
	@p_ID nvarchar(50),
	@p_ORG nvarchar(30),
	@p_RSTATUS int,
	@p_STATUS nvarchar(30),
	@p_STATUS_old nvarchar(30),
	@p_TYPE nvarchar(30),
	@p_ANLN1_POSKI nvarchar(30),
	@p_ANLN2 nvarchar(30),
	@p_WART_NAB_PLN numeric(30,2),
	@p_DOSTAWCA nvarchar(80),
	@p_NR_DOW_DOSTAWY nvarchar(30),
	@p_DT_DOSTAWY datetime,
	@p_GRUPA nvarchar(8),
	@p_ILOSC int,
	@p_NZWYP nvarchar(50),
	@p_MUZYTK nvarchar(50),
	
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
	declare @v_ANLN1 nvarchar(30)
		, @v_OT21ID int
		, @v_OTLID int
		, @v_OTID int
		
	-- czy klucze niepuste
	if @p_ID is null or @p_CODE is NULL OR @p_ORG IS NULL -- ## dopisac klucze
	begin
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
 
	set @v_date = getdate()
 	select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS
 	    
	select @v_ANLN1 = AST_SAP_ANLN1 from [dbo].[ASSET] where AST_CODE = @p_ANLN1_POSKI
	 
	--insert
	if not exists (select * from dbo.ZWFOTLN (nolock) where OTL_ID = @p_ID)
	begin
	   
	   --Nagłówek (jeden dla wszystkich dokumentów do integracji)
		BEGIN TRY
		
			select @v_OTID = OT21_ZMT_ROWID from dbo.SAPO_ZWFOT21(nolock) where OT21_ROWID = @p_OT21ID
			
			----------------------------------------------------------------------------------
			--------------------linie wyposażenia OT w ZMT------------------------------------
			----------------------------------------------------------------------------------
			insert into dbo.ZWFOTLN 
			(
				OTL_OTID, OTL_STATUS, OTL_RSTATUS, OTL_ID, OTL_ORG, OTL_CODE, OTL_TYPE, OTL_CREDATE, OTL_CREUSER, OTL_OBJID
			)
			select
				@v_OTID, NULL, 0, @p_ID, @p_ORG, OT_CODE + '/' + cast(ROW_NUMBER() OVER(PARTITION BY OT_CODE ORDER BY OBJ_DESC ASC) as nvarchar(50)) , NULL, getdate(), @p_UseriD, OBJ_ROWID
			from OBJ (nolock) 
				join STENCIL (nolock) on STS_ROWID = OBJ_STSID
				join ZWFOT (nolock) on OT_ROWID = @v_OTID
			where OBJ_PARENTID = @p_OBJID
				--and STS_SETTYPE = 'EKOM'
			order by STS_DESC
			
			select @v_OTLID = IDENT_CURRENT('ZWFOTLN')
			 
			---------------------------------------------------------------------------------
			--------------------linie wyposażenia W  do integracji w SAP---------------------
			---------------------------------------------------------------------------------
			insert into dbo.SAPO_ZWFOT21LN
			(  
				OT21LN_WART_NAB_PLN, OT21LN_DOSTAWCA, OT21LN_NR_DOW_DOSTAWY, OT21LN_DT_DOSTAWY, OT21LN_GRUPA, OT21LN_ANLN1, OT21LN_ANLN2, OT21LN_ZMT_ROWID, OT21LN_OT21ID, OT21LN_ZMT_OBJ_CODE
				, OT21LN_NZWYP
			) 		
			select distinct
				isnull(@p_WART_NAB_PLN,0), @p_DOSTAWCA, @p_NR_DOW_DOSTAWY, @p_DT_DOSTAWY, @p_GRUPA, '', '', @v_OTLID, @p_OT21ID, OBJ_CODE 
				, left(OBJ_DESC,50)
			from OBJ (nolock) 
				join STENCIL (nolock) on STS_ROWID = OBJ_STSID
			where OBJ_PARENTID = @p_OBJID
				--and STS_SETTYPE = 'EKOM'
			order by left(OBJ_DESC,50)

			insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OBJID, OTO_ASTCODE, OTO_ASTSUBCODE, OTO_CREUSER, OTO_CREDATE)
			select @v_OTID, OBJ_ROWID, null, null, @p_UserID, getdate()
			from dbo.OBJ
			where OBJ_PARENTID = @p_OBJID
			and not exists (select 1 from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID and OTO_OBJID = OBJ_ROWID)
				 
			;with a as
			---------------------------------------------------------------------------------
			-----------------------Aktualizacja warotści dokuemtnu W-------------------------
			---------------------------------------------------------------------------------
				(
					select OT21_ROWID, sum(OT21LN_WART_NAB_PLN) suma
					from [dbo].[SAPO_ZWFOT21LN] (nolock) 
						join [dbo].[SAPO_ZWFOT21] (nolock) on OT21_ROWID = OT21LN_OT21ID
						join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT21LN_ZMT_ROWID
					where ot21ln_ot21id = @p_OT21ID and isnull(OTL_NOTUSED,0) = 0 and OT21LN_WART_NAB_PLN is not null
					group by OT21_ROWID
				)
			update UPD set UPD.OT21_KWPRZEKSIEGS = suma 
				from [dbo].[SAPO_ZWFOT21] UPD
					join A on A.OT21_ROWID = UPD.OT21_ROWID
				where UPD.OT21_ROWID = A.OT21_ROWID
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT21_001' -- blad wstawienia
			goto errorlabel
		END CATCH;
		 
		 
	end
	else
	begin
	 

		BEGIN TRY
		 
			--nagłówek
			update [dbo].[ZWFOTLN]
			set 
				OTL_STATUS = @P_STATUS, 
				OTL_RSTATUS = @v_RSTATUS,	
				OTL_ORG = @P_ORG, 
				OTL_UPDDATE = getdate(), 
				OTL_UPDUSER = @p_UserID

			where OTL_ID = @P_ID
			
			update [dbo].[SAPO_ZWFOT21LN]
			set
				OT21LN_ANLN1 = @v_ANLN1,
				OT21LN_ANLN1_POSKI = @p_ANLN1_POSKI,
				OT21LN_ANLN2 = @p_ANLN2,
				OT21LN_WART_NAB_PLN = @p_WART_NAB_PLN,
				OT21LN_DOSTAWCA = @p_DOSTAWCA,
				OT21LN_NR_DOW_DOSTAWY = @p_NR_DOW_DOSTAWY,
				OT21LN_DT_DOSTAWY = @p_DT_DOSTAWY,
				OT21LN_GRUPA = @p_GRUPA,
				OT21LN_ILOSC = @p_ILOSC,
				OT21LN_NZWYP = @p_NZWYP,
				OT21LN_MUZYTK = @p_MUZYTK
			where
				OT21LN_ROWID = @p_ROWID

			select @v_OT21ID = OT21LN_OT21ID from [dbo].[SAPO_ZWFOT21LN] (nolock) where OT21LN_ROWID = @p_ROWID;

			----jest też w triggerze na tabeli z pozycjami. Na wszelki wypadek.
			with a as
				(
					select OT21_ROWID, sum(OT21LN_WART_NAB_PLN) suma
					from [dbo].[SAPO_ZWFOT21LN] (nolock) 
						join [dbo].[SAPO_ZWFOT21] (nolock) on OT21_ROWID = OT21LN_OT21ID
						join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT21LN_ZMT_ROWID
					where ot21ln_ot21id = @v_OT21ID and isnull(OTL_NOTUSED,0) = 0 and OT21LN_WART_NAB_PLN is not null
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