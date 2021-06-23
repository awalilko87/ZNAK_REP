SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT31DON_Update_Proc]
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
	@p_ANLN1 nvarchar(30), 
	@p_ANLN2 nvarchar(30), 
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
 
	set @v_date = getdate()
 	select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS
 	   
 	select @v_OTID = OT_ROWID from ZWFOT (nolock) join SAPO_ZWFOT31 (nolock) on OT31_ZMT_ROWID = OT_ROWID where OT31_ROWID = @p_OT31ID
 	select @v_OTD_COUNT = COUNT(*) from ZWFOTDON where OTD_OTID = @v_OTID 
 	    
	-- czy klucze niepuste
	if @p_ID is null or @v_OTID is null or @p_OT31ID is null-- ## dopisac klucze
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
			insert into dbo.SAPO_ZWFOT31DON
			(  
				OT31DON_LP, OT31DON_BUKRS, OT31DON_ANLN1, OT31DON_ANLN2
				, OT31DON_ZMT_ROWID, OT31DON_OT31ID
			) 		
			select distinct
				@v_OTD_COUNT+1, OT31_BUKRS,  @p_ANLN1, 	@p_ANLN2		
				, @v_OTDID, @p_OT31ID
			from dbo.SAPO_ZWFOT31 (nolock)
			where OT31_ROWID = @p_OT31ID
  
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT31DON_002' -- blad wstawienia
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
			
			update [dbo].[SAPO_ZWFOT31DON]
			set   
				OT31DON_LP = @v_OTD_COUNT+1,  
				OT31DON_ANLN1 = @p_ANLN1,  
				OT31DON_ANLN2 = @p_ANLN2
			where
				OT31DON_ROWID = @p_ROWID
   
			--with a as
			--	(
			--		select OT31_ROWID, sum(OT31DON_WART_ELEME) suma
			--		from [dbo].[SAPO_ZWFOT31DON] (nolock) 
			--			join [dbo].[SAPO_ZWFOT31] (nolock) on OT31_ROWID = OT31DON_OT31ID
			--		where OT31DON_ot31id = @v_OT31ID
			--		group by OT31_ROWID
			--	)
			--update UPD set UPD.OT31_WART_TOTAL = suma 
			--	from [dbo].[SAPO_ZWFOT31] UPD
			--		join A on A.OT31_ROWID = UPD.OT31_ROWID
			--	where UPD.OT31_ROWID = A.OT31_ROWID

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT31_002' -- blad aktualizacji 
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