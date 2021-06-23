SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[OT42LN_OT40_Create_Multi]
(
	@p_Key nvarchar(max) = NULL,  
	@p_UserID varchar(30),
    @p_apperrortext nvarchar(4000) = null output
)
as
begin  
	 
	--declare @p_FormID nvarchar(50),
	--	@p_Key nvarchar(max) = NULL,  
	--	@p_UserID nvarchar(30), 
	--	@p_apperrortext nvarchar(4000) 

	--select @p_FormID = 'OT40_CREATE_MULTI', @p_Key = '94;99;100;131;135;137;142;144;145;153;', @p_UserID = 'SA';
	 
	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @v_errorid int
	declare @v_date datetime
	declare @v_Rstatus int
	declare @v_Pref nvarchar(10)
	declare @v_MultiOrg bit
	declare @v_STATUS nvarchar(30)
	declare
		--zmienne kursora 
		@c_OT42LNID int,
		@v_COUNT_LTS int,
				
		--zmienne linii PL 
		@v_IMIE_NAZWISKO nvarchar(30),
		@v_PL_DOC_NUM nvarchar(30),  
		@v_PL_DOC_YEAR int,
		@v_PL_DOC_ANLN1 nvarchar(30),
		@v_PL_DOC_ANLN1_POSKI nvarchar(30),
		@v_PL_DOC_ANLN2 nvarchar(4), 
		@v_PL_PROC decimal(10,2),
		@v_PL_OT42ID int,
		@v_PL_OTLID int,
			 
		--zmienne nagłówka LTS
		@v_OT40_ID nvarchar(50), 
		@v_OT40_ORG nvarchar(30),
		@v_OT40_STATUS  nvarchar(30),  
		@v_OT40ID int,
		--zmienne linii LTS
		@v_OT40LN_ID nvarchar(50)	
		
	declare @t_ASSET_BLOCKED table (ANLN1_ANLN2 nvarchar(30))
	insert into @t_ASSET_BLOCKED (ANLN1_ANLN2) select ANLN1_ANLN2 from dbo.GetBlockedAssets ()  --where anln1_anln2 ='4832390000'
	 		
	select @v_IMIE_NAZWISKO = SAPLogin from SyUsers(nolock) where UserID = @p_UseriD			
	
	if @v_IMIE_NAZWISKO is null
	begin
		set @v_errorcode = 'OT_SAPUSER'
		goto errorlabel
	end

	select @v_COUNT_LTS = 0
		
    declare c_PLLN cursor for 
	select string from dbo.VS_Split2(@p_KEY,';')
		where   string != '' and string != '0'

    open c_PLLN
	fetch next from c_PLLN into @c_OT42LNID
	while @@fetch_status = 0
	begin
		select 
			@v_PL_DOC_NUM = isnull(OT42_IF_EQUNR, '0000000000'),
			@v_PL_DOC_YEAR = isnull(OT42_ROK,0), 		
			@v_PL_DOC_ANLN1 = OT42LN_ANLN1,
			@v_PL_DOC_ANLN1_POSKI = OT42LN_ANLN1_POSKI,
			@v_PL_DOC_ANLN2 = OT42LN_ANLN2, 
			@v_PL_PROC = isnull(OT42LN_PROC,100),
			@v_PL_OT42ID = OT42LN_OT42ID,
			@v_PL_OTLID = OT42LN_ZMT_ROWID
		from dbo.SAPO_ZWFOT42LN (nolock) 
			join dbo.SAPO_ZWFOT42 (nolock) on OT42_ROWID = OT42LN_OT42ID
		where OT42LN_ROWID = @c_OT42LNID
			and OT42LN_ANLN1_POSKI + OT42LN_ANLN2 not in (select isnull(ANLN1_ANLN2,'') from @t_ASSET_BLOCKED)
		 
		if 
			@v_PL_OT42ID is not null 
			and @v_PL_DOC_ANLN1_POSKI is not null 
			and @v_PL_DOC_ANLN2 is not null			
			and not exists (select * from ZWFOT40LNv L join dbo.ZWFOT40v (nolock) on OT40_ROWID = L.OT40LN_OT40ID where 
				--OT40LN_OT40ID = @v_OT40ID and 
				OT40LN_ANLN1_POSKI = @v_PL_DOC_ANLN1_POSKI and 
				OT40LN_ANLN2  = @v_PL_DOC_ANLN2 and
				OT_STATUS not in ('OT40_50','OT40_60','OT40_70'))
		begin try
			--print 'LTS NAG'
			select @v_OT40_ID = NEWID()
			select @v_OT40_ORG = dbo.GetOrgDef('OT40_RC',@p_UseriD)
			select @v_OT40_STATUS = dbo.[GetStatusDef]('OT40_RC',NULL,@p_UseriD)
			  
			if 
			not exists (
				select * from SAPO_ZWFOT40LN (nolock) L join dbo.ZWFOT40v (nolock) on OT40_ROWID = L.OT40LN_OT40ID 
				where 
					OT40_PL_DOC_NUM = @v_PL_DOC_NUM
					and OT40_PL_DOC_YEAR = @v_PL_DOC_YEAR
					and OT_CREUSER = @p_UserID
					and OT_STATUS not in ('OT40_50','OT40_60','OT40_70'))
			begin
				exec [dbo].[ZWFOT40_Update_Proc] 
					@p_FormID  = 'OT40_RC',
					@p_ROWID = NULL,
					@p_CODE = 'autonumer',
					@p_ID = @v_OT40_ID,
					@p_ORG = @v_OT40_ORG,
					@p_RSTATUS = 0,
					@p_STATUS = @v_OT40_STATUS,
					@p_STATUS_old = NULL,
					@p_TYPE = NULL,
					@p_KROK = 1,
					@p_BUKRS = 'PPSA',
					@p_PL_DOC_NUM = @v_PL_DOC_NUM, 
					@p_PL_DOC_YEAR = @v_PL_DOC_YEAR,
					@p_IF_EQUNR = NULL,
					@p_IF_SENTDATE = NULL,
					@p_IF_STATUS = NULL,
					@p_SAPUSER = '',
					@p_IMIE_NAZWISKO = @v_IMIE_NAZWISKO,
					@p_ZMT_ROWID = NULL, 
					@p_UserID  = @p_UserID;
			
				select @v_OT40ID = OT40_ROWID from dbo.ZWFOT40v (nolock) where OT_ID = @v_OT40_ID	
				select @v_COUNT_LTS = @v_COUNT_LTS + 1
			end
			else
			begin
				select top 1 @v_OT40ID = OT40_ROWID from SAPO_ZWFOT40LN (nolock) L join dbo.ZWFOT40v (nolock) on OT40_ROWID = L.OT40LN_OT40ID 
				where 
					OT40_PL_DOC_NUM = @v_PL_DOC_NUM
					and OT40_PL_DOC_YEAR = @v_PL_DOC_YEAR
					and OT_STATUS not in ('OT40_50','OT40_60','OT40_70')
			end	
			 			
			select @v_OT40LN_ID = NEWID()
			 
			--print 'LTS LN'	
			exec [dbo].[ZWFOT40LN_Update_Tran] 
				@p_FormID  = 'OT40_LN',
				@p_ROWID = NULL,
				@p_OT40ID = @v_OT40ID,
				@p_CODE = 'autonumer',
				@p_ID = @v_OT40LN_ID,
				@p_ORG = @v_OT40_ORG,
				@p_RSTATUS = 0,
				@p_STATUS = NULL,
				@p_STATUS_old = NULL,
				@p_TYPE = NULL,
				@p_ANLN1_POSKI = @v_PL_DOC_ANLN1_POSKI,
				@p_ANLN2 = @v_PL_DOC_ANLN2,
				@p_PROC = @v_PL_PROC,
				@p_OPIS = '',
				@p_ZMT_ROWID = NULL, 
				@p_OTLID = @v_PL_OTLID,
				@p_UserID  = @p_UserID;
		end try
		begin catch
			close c_PLLN
			deallocate c_PLLN	
			set @v_errorcode = '001' -- blad dodawania instrukcji multi
			goto errorlabel
		end catch
		else
			select @v_errortext = 'Dla wybranej pozycji jest już wystawiony LTS. '


		fetch next from c_PLLN into @c_OT42LNID

	end


	close c_PLLN
	deallocate c_PLLN
  
	select @v_errortext = isnull(@v_errortext ,'' ) + '<B> Utworzono dokumentów LTS : ' + cast(@v_COUNT_LTS as nvarchar) + '<B><BR>' 
	
	raiserror(@v_errortext,1,1)
 
	return 0
  
	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1

	errorlabel_c:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1

END 
GO