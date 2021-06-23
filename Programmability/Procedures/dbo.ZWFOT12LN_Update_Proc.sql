SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT12LN_Update_Proc]
(
	@p_FormID nvarchar(50), 
	@p_ROWID int,
	@p_OT12ID int,
	@p_OBJID int,
	@p_CODE nvarchar(30), 
	@p_ID nvarchar(50),
	@p_ORG nvarchar(30),
	@p_RSTATUS int,
	@p_STATUS nvarchar(30),
	@p_STATUS_old nvarchar(30),
	@p_TYPE nvarchar(30),
	@p_CHAR_SKLAD nvarchar(max),
	@p_ANLN1_POSKI nvarchar(30),
	@p_ANLN2 nvarchar(30),
	@p_WART_ELEME numeric(30,2),
	@p_INVNR_NAZWA nvarchar(50),

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
	declare @v_OT12ID int
		, @v_ANLN1 nvarchar(12)
		, @v_OTID int
		, @v_OTLID int
 
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
		
			select @v_OTID = OT12_ZMT_ROWID from dbo.SAPO_ZWFOT12(nolock) where OT12_ROWID = @p_OT12ID
			
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
			insert into dbo.SAPO_ZWFOT12LN
			(  
			
				OT12LN_INVNR_NAZWA, OT12LN_CHAR_SKLAD, OT12LN_WART_ELEME
				, OT12LN_ANLN1, OT12LN_ANLN2, OT12LN_ANLN1_POSKI
				, OT12LN_ZMT_ROWID, OT12LN_OT12ID, OT12LN_ZMT_OBJ_CODE
				
			) 		
			select distinct
				
				@p_INVNR_NAZWA, isnull(@p_CHAR_SKLAD,''), @p_WART_ELEME
				, @v_ANLN1, @p_ANLN2, @p_ANLN1_POSKI
				, @v_OTLID, @p_OT12ID, OBJ_CODE 
				
			from OBJ (nolock) 
				join STENCIL (nolock) on STS_ROWID = OBJ_STSID
			where 
				OBJ_ROWID = @p_OBJID

			insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OBJID, OTO_ASTCODE, OTO_ASTSUBCODE, OTO_CREUSER, OTO_CREDATE)
			select @v_OTID, OBJ_ROWID, null, null, @p_UserID, getdate()
			from dbo.OBJ
			where OBJ_ROWID = @p_OBJID
			and not exists (select 1 from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID and OTO_OBJID = OBJ_ROWID)
				  
			;with a as
			---------------------------------------------------------------------------------
			-----------------------Aktualizacja warotści dokuemtnu OTK-----------------------
			---------------------------------------------------------------------------------
				(
					select OT12_ROWID, sum(OT12LN_WART_ELEME) suma
					from [dbo].[SAPO_ZWFOT12LN] (nolock) 
						join [dbo].[SAPO_ZWFOT12] (nolock) on OT12_ROWID = OT12LN_OT12ID
						join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT12LN_ZMT_ROWID
					where ot12ln_ot12id = @p_OT12ID and isnull(OTL_NOTUSED,0) = 0 and OT12LN_WART_ELEME is not null
					group by OT12_ROWID
				)
			update UPD set UPD.OT12_WART_TOTAL = suma 
				from [dbo].[SAPO_ZWFOT12] UPD
					join A on A.OT12_ROWID = UPD.OT12_ROWID
				where UPD.OT12_ROWID = A.OT12_ROWID
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT12_001' -- blad wstawienia
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
			
			update [dbo].[SAPO_ZWFOT12LN]
			set
				OT12LN_CHAR_SKLAD = @p_CHAR_SKLAD,
				OT12LN_ANLN1 = @v_ANLN1,
				OT12LN_ANLN1_POSKI = @p_ANLN1_POSKI,
				OT12LN_ANLN2 = @p_ANLN2,
				OT12LN_WART_ELEME = @p_WART_ELEME,
				OT12LN_INVNR_NAZWA = @p_INVNR_NAZWA
			where
				OT12LN_ROWID = @p_ROWID

			select @v_OT12ID = OT12LN_OT12ID from [dbo].[SAPO_ZWFOT12LN] (nolock) where OT12LN_ROWID = @p_ROWID;

			with a as
				(
					select OT12_ROWID, sum(OT12LN_WART_ELEME) suma
					from [dbo].[SAPO_ZWFOT12LN] (nolock) 
						join [dbo].[SAPO_ZWFOT12] (nolock) on OT12_ROWID = OT12LN_OT12ID
					where ot12ln_ot12id = @v_OT12ID and OT12LN_WART_ELEME is not null
					group by OT12_ROWID
				)
			update UPD set UPD.OT12_WART_TOTAL = suma 
				from [dbo].[SAPO_ZWFOT12] UPD
					join A on A.OT12_ROWID = UPD.OT12_ROWID
				where UPD.OT12_ROWID = A.OT12_ROWID

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT12_002' -- blad aktualizacji 
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