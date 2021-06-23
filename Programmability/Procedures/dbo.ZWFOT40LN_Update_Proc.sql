SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT40LN_Update_Proc]
(	@p_FormID nvarchar(50), 
	@p_ROWID int,
	@p_OT40ID int,
	@p_CODE nvarchar(30), 
	@p_ID nvarchar(50),
	@p_ORG nvarchar(30),
	@p_RSTATUS int,
	@p_STATUS nvarchar(30),
	@p_STATUS_old nvarchar(30),
	@p_TYPE nvarchar(30), 
	@p_ANLN1_POSKI nvarchar(30),
	@p_ANLN2 nvarchar(30), 
	@p_PROC decimal(10,2),
	@p_OPIS nvarchar(30), 
	@p_ZMT_ROWID int,  
	@p_OTLID int,
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
		, @v_ITSID int
		, @v_OTID int
		, @v_OT nvarchar(30)
		, @v_OTLID int
		, @v_OTL_COUNT int =  0
		, @v_OT_STATUS nvarchar(30)
		, @v_ANLN1  nvarchar(30)
		, @v_GDLGRP nvarchar(30)
		, @v_KOSTL  nvarchar(30)
		
 
	-- czy klucze niepuste
	if @p_ID is null OR @p_ORG IS NULL -- ## dopisac klucze
	begin
		print @p_org
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
 
	set @v_date = getdate()
 	select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS
 
 	select @v_ITSID = OT_ITSID, @v_OTID = OT_ROWID from ZWFOT (nolock) join SAPO_ZWFOT40 (nolock) on OT40_ZMT_ROWID = OT_ROWID where OT40_ROWID = @p_OT40ID
 	select @v_OTL_COUNT = COUNT(*) from dbo.ZWFOTLN where OTL_OTID = @v_OTID 
 	select @v_OT_STATUS = OT_STATUS from dbo.ZWFOT (nolock) where OT_ROWID = @v_OTID --OT40_60
 	 	   
 	--rzutowanie zmiennych z SAP (POSKI jest polem jedynie do wyświetlania (zadanie inwestycyjne to wyjątek)
	select @v_ANLN1 = AST_SAP_ANLN1 from [dbo].[ASSET] (nolock) where AST_CODE = @p_ANLN1_POSKI
  
	--insert
	if not exists (select * from dbo.ZWFOTLN (nolock) where OTL_ID = @p_ID)
	begin  
		BEGIN TRY

			--linia LTS w ZMT
			insert into dbo.ZWFOTLN 
			(
				OTL_OTID, OTL_STATUS, OTL_RSTATUS, OTL_ID, OTL_ORG, OTL_CODE, OTL_TYPE, OTL_CREDATE, OTL_CREUSER, OTL_OBJID, OTL_OTLID
			)
			select distinct
				@v_OTID, NULL, 0, @p_ID, @p_ORG, cast(@v_OT as nvarchar)+ '/' + cast(@v_OTL_COUNT+1 as nvarchar), NULL, getdate(), @p_UseriD, NULL, @p_OTLID
			from ZWFOT (nolock) where OT_ROWID = @v_OTID
 
			select @v_OTLID = SCOPE_IDENTITY()
			
			--linia LTS do integracji w SAP
			insert into dbo.SAPO_ZWFOT40LN
			(  
				OT40LN_BUKRS
				, OT40LN_ANLN1, OT40LN_ANLN1_POSKI
				, OT40LN_ANLN2 
				, OT40LN_PROC, OT40LN_OPIS
				, OT40LN_ZMT_ROWID, OT40LN_OT40ID
			) 		
			select distinct
				OT40_BUKRS
				, @v_ANLN1, @p_ANLN1_POSKI
				, @p_ANLN2
				, @p_PROC, @p_OPIS
				, @v_OTLID, @p_OT40ID
			from dbo.SAPO_ZWFOT40 (nolock)
			where OT40_ROWID = @p_OT40ID

			insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OTLID, OTO_OBJID, OTO_ASTCODE, OTO_ASTSUBCODE, OTO_CREUSER, OTO_CREDATE)
			select @v_OTID, @v_OTLID, OBJ_ROWID, AST_CODE, AST_SUBCODE, @p_UserID, getdate()
			from dbo.OBJASSETv
			where AST_CODE = @p_ANLN1_POSKI and AST_SUBCODE = @p_ANLN2 and AST_NOTUSED = 0
			and not exists (select 1 from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID and OTO_OBJID = OBJ_ROWID)
  
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT40LN_002' -- blad wstawienia
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
				OTL_OTLID = @p_OTLID,
				OTL_STATUS = @P_STATUS, 
				OTL_RSTATUS = @v_RSTATUS,  
				OTL_ORG = @P_ORG, 
				OTL_CODE = @P_CODE, 
				OTL_TYPE = @p_TYPE, 
				OTL_UPDDATE = @v_date, 
				OTL_UPDUSER = @p_UserID
 
			where OTL_ID = @P_ID
			 
			update [dbo].[SAPO_ZWFOT40LN]
			set   
				OT40LN_ANLN1 = @v_ANLN1,
				OT40LN_ANLN1_POSKI = @p_ANLN1_POSKI,
				OT40LN_ANLN2 = @p_ANLN2,
				OT40LN_PROC = @p_PROC, 
				OT40LN_OPIS = @p_OPIS 
			where
				OT40LN_ROWID = @p_ROWID
 
			--with a as
			--	(
			--		select OT40_ROWID, sum(OT40LN_WART_ELEME) suma
			--		from [dbo].[SAPO_ZWFOT40LN] (nolock) 
			--			join [dbo].[SAPO_ZWFOT40] (nolock) on OT40_ROWID = OT40LN_OT40ID
			--		where ot40ln_ot40id = @v_OT40ID
			--		group by OT40_ROWID
			--	)
			--update UPD set UPD.OT40_WART_TOTAL = suma 
			--	from [dbo].[SAPO_ZWFOT40] UPD
			--		join A on A.OT40_ROWID = UPD.OT40_ROWID
			--	where UPD.OT40_ROWID = A.OT40_ROWID

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