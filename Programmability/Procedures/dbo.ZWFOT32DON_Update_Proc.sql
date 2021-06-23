SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT32DON_Update_Proc]
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
	@p_ANLN2 nvarchar(30), 
	@p_ANLN1_DO_POSKI nvarchar(30), 
	@p_ANLN2_DO nvarchar(30), 
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
	declare @v_Rstatus int 
		--, @v_ITSID int
		, @v_OTID int
		, @v_OT nvarchar(30)
		, @v_OTDID int
		, @v_OTD_COUNT int =  0
		, @v_ANLN1 nvarchar(12)
		, @v_ANLN1_DO nvarchar(12)
 
	set @v_date = getdate()
 	select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS
 	   
 	select @v_OTID = OT_ROWID from ZWFOT (nolock) join SAPO_ZWFOT32 (nolock) on OT32_ZMT_ROWID = OT_ROWID where OT32_ROWID = @p_OT32ID
 	select @v_OTD_COUNT = COUNT(*) from ZWFOTDON where OTD_OTID = @v_OTID 
 	
	select @v_ANLN1 = AST_SAP_ANLN1 from [dbo].[ASSET] (nolock) where AST_CODE = @p_ANLN1_POSKI
	select @v_ANLN1_DO = AST_SAP_ANLN1 from [dbo].[ASSET] (nolock) where AST_CODE = @p_ANLN1_DO_POSKI 
	
	-- czy klucze niepuste
	if @p_ID is null or @v_OTID is null or @p_OT32ID is null-- ## dopisac klucze
	begin
		print @p_org
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
 
	--insert
	if not exists (select * from dbo.ZWFOTDON (nolock) where OTD_ID = @p_ID)
	begin  
		BEGIN TRY

			--linia protokołu PL w ZMT
			insert into dbo.ZWFOTDON 
			(
				OTD_OTID, OTD_STATUS, OTD_RSTATUS, OTD_ID, OTD_ORG, OTD_CODE, OTD_TYPE, OTD_CREDATE, OTD_CREUSER, OTD_OBJID
			)
			select distinct
				@v_OTID, NULL, 0, @p_ID, @p_ORG, cast(@v_OT as nvarchar)+ '/' + cast(@v_OTD_COUNT+1 as nvarchar), NULL, getdate(), @p_UseriD, NULL
			from ZWFOT (nolock) where OT_ROWID = @v_OTID
  
			select @v_OTDID = SCOPE_IDENTITY()
			
			--linia protokołu PL do integracji w SAP
			insert into dbo.SAPO_ZWFOT32DON
			(  
				OT32DON_LP, OT32DON_BUKRS
				, OT32DON_ANLN1
				, OT32DON_ANLN1_POSKI
				, OT32DON_ANLN2
				, OT32DON_ANLN1_DO
				, OT32DON_ANLN1_DO_POSKI
				, OT32DON_ANLN2_DO
				, OT32DON_ZMT_ROWID, OT32DON_OT32ID
			) 		
			select distinct
				@v_OTD_COUNT+1, OT32_BUKRS
				, @v_ANLN1
				, @p_ANLN1_POSKI
				, @p_ANLN2		
				, @v_ANLN1_DO
				, @p_ANLN1_DO_POSKI
				, @p_ANLN2_DO		
				, @v_OTDID, @p_OT32ID
			from dbo.SAPO_ZWFOT32 (nolock)
			where OT32_ROWID = @p_OT32ID

			update dbo.SAPO_ZWFOT32DON set
				OT32DON_LP = lp
			from (select 
					 ot32donid = OT32DON_ROWID
					,lp = row_number() over (order by OTD_NOTUSED, OT32DON_ROWID) 
				from dbo.SAPO_ZWFOT32DON
				inner join dbo.ZWFOTDON(nolock) on OTD_ROWID = OT32DON_ZMT_ROWID
				where OT32DON_OT32ID = @p_OT32ID)don32
			where OT32DON_ROWID = ot32donid

			insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OBJID, OTO_ASTCODE, OTO_ASTSUBCODE, OTO_CREUSER, OTO_CREDATE)
			select @v_OTID, OBJ_ROWID, AST_CODE, AST_SUBCODE, @p_UserID, getdate()
			from dbo.OBJASSETv
			where AST_CODE = @p_ANLN1_POSKI and AST_SUBCODE = @p_ANLN2 and AST_NOTUSED = 0
			and not exists (select 1 from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID and OTO_OBJID = OBJ_ROWID)
  
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT32_002' -- blad wstawienia
			goto errorlabel
		END CATCH;	 
		 
	end
	else
	begin
	  
		BEGIN TRY
		 
			--nagłówek
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
 
			where OTD_ID = @P_ID
			
			update [dbo].[SAPO_ZWFOT32DON]
			set   
				OT32DON_LP = @v_OTD_COUNT+1,  
				OT32DON_ANLN1 = @v_ANLN1,
				OT32DON_ANLN1_POSKI = @p_ANLN1_POSKI,  
				OT32DON_ANLN2 = @p_ANLN2,
				OT32DON_ANLN1_DO = @v_ANLN1_DO,  
				OT32DON_ANLN1_DO_POSKI = @p_ANLN1_DO_POSKI,  
				OT32DON_ANLN2_DO = @p_ANLN2_DO
			where
				OT32DON_ROWID = @p_ROWID
 
			--with a as
			--	(
			--		select OT32_ROWID, sum(OT32DON_WART_ELEME) suma
			--		from [dbo].[SAPO_ZWFOT32DON] (nolock) 
			--			join [dbo].[SAPO_ZWFOT32] (nolock) on OT32_ROWID = OT32DON_OT32ID
			--		where OT32DON_ot32id = @v_OT32ID
			--		group by OT32_ROWID
			--	)
			--update UPD set UPD.OT32_WART_TOTAL = suma 
			--	from [dbo].[SAPO_ZWFOT32] UPD
			--		join A on A.OT32_ROWID = UPD.OT32_ROWID
			--	where UPD.OT32_ROWID = A.OT32_ROWID

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