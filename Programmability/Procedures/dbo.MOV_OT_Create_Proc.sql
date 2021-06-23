SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[MOV_OT_Create_Proc]
(
	@p_FormID nvarchar(50),
	@p_ROWID int,
	 
	@p_UserID nvarchar(30), 
	@p_apperrortext nvarchar(4000) = null output
)
as
begin  
	 
--declare @p_FormID nvarchar(50),
--	@p_ROWID int,
--	@p_UserID nvarchar(30), 
--	@p_apperrortext nvarchar(4000) 

--select @p_FormID = 'MOV_RC', @p_ROWID = 5, @p_UserID = 'SA';
	
	
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
		@c_MOL_ROWID int,
		@c_MOV_ROWID int,
		@c_AST_CODE nvarchar(30),
		@c_AST_SUBCODE nvarchar(30),
		@c_FROM_STNID int,
		@c_FROM_KL5ID int,
		@c_TO_STNID int,
		@c_TO_KL5ID int, 
		@v_COUNT_MT1 int,
		@v_COUNT_MT2 int,
		@v_COUNT_MT3 int,
		@v_COUNT_PL int,
		@v_COUNT_LTW int,
		
		--zmienne do kontrolek
		@v_FROM_CCD nvarchar(30),
		@v_FROM_KL5 nvarchar(30),
		@v_TO_CCD nvarchar(30),
		@v_TO_KL5 nvarchar(30),
		
		--zmienne nagłówka MT1
		@v_OT31_ID nvarchar(50), 
		@v_OT31_ORG nvarchar(30),
		@v_OT31_STATUS  nvarchar(30), 
		@v_OT31_IMIE_NAZWISKO nvarchar(30), 
		@v_OT31ID int,
		--zmienne linii MT1
		@v_OT31LN_ID nvarchar(50),
		@v_DT_WYDANIA datetime,
		
		--zmienne nagłówka MT3
		@v_OT33_ID nvarchar(50), 
		@v_OT33_ORG nvarchar(30),
		@v_OT33_STATUS  nvarchar(30),
		@v_OT33_MTOPER  nvarchar(1),
		@v_OT33_IMIE_NAZWISKO nvarchar(30), 
		@v_OT33ID int,
		--zmienne linii MT3
		@v_OT33LN_ID nvarchar(50) 
				
	select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID
	select @v_STATUS = MOV_STATUS from dbo.MOVEMENT (nolock) where MOV_ROWID = @p_ROWID
	select @v_Rstatus = isnull(STA_RFLAG,0) from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @v_STATUS
	select @v_COUNT_MT1 = 0, @v_COUNT_MT2 = 0, @v_COUNT_MT3 = 0, @v_COUNT_PL = 0, @v_COUNT_LTW = 0
		
	if exists 	
		(select 1 from MOVEMENTLN  
			join dbo.OBJ (nolock) on OBJ_ROWID = MOL_OBJID
			left join dbo.MOVEMENTCHECK (nolock) on MOC_MOVID = MOL_MOVID and MOC_OBGID = OBJ_GROUPID 
		where 
			MOL_STATUS = 'MOL_002' and --do przeniesienia
			MOL_MOVID = @p_ROWID and --w tym formularzu
			MOC_OBGID is null ) --nie ma zatwierdzonej grupy w MOVEMENTCHECK	 
		and @v_STATUS = 'MOV_003'
		
	begin
		select @v_errorcode = 'MOV_001' --select * from vs_langmsgs where objectid = 'MOV_001'
		goto errorlabel
	end  

	declare @t_ASSET_BLOCKED table (ANLN1_ANLN2 nvarchar(30))
	 
	insert into @t_ASSET_BLOCKED (ANLN1_ANLN2) select ANLN1_ANLN2 from dbo.GetBlockedAssets ()
	 
	if exists (select * from [dbo].[MOVEMENT] (nolock) where MOV_ROWID = @p_ROWID)
	begin
	 
		declare c_MOLLN cursor for
		select
			MOL_ROWID,
			MOL_MOVID,
			AST_CODE, 
			AST_SUBCODE, 
			FROM_STNID = OSA_STNID,
			FROM_KL5ID = OSA_KL5ID,
			TO_STNID = MOL_TO_STNID, 
			TO_KL5ID = TO_STN.STN_KL5ID
			
		from dbo.MOVEMENTLN (nolock)  
			join dbo.OBJASSET (nolock) on MOL_OBJID = OBA_OBJID 
			join dbo.ASSET (nolock) a on AST_ROWID = OBA_ASTID 
			join dbo.OBJSTATION (nolock) on OSA_OBJID = OBA_OBJID
			join dbo.STATION (nolock) TO_STN on TO_STN.STN_ROWID = MOL_TO_STNID
		where MOL_MOVID = @p_ROWID  
			and AST_CODE + AST_SUBCODE not in (select isnull(ANLN1_ANLN2,'') from @t_ASSET_BLOCKED)
		order by a.AST_CODE, a.AST_SUBCODE

		open c_MOLLN

		fetch next from c_MOLLN
		into @c_MOL_ROWID, @c_MOV_ROWID, @c_AST_CODE, @c_AST_SUBCODE, @c_FROM_STNID, @c_FROM_KL5ID, @c_TO_STNID, @c_TO_KL5ID

		begin try
						 
			while @@FETCH_STATUS = 0
			begin
				
				select @v_FROM_CCD = STN_CCD from STATIONv where STN_ROWID = @c_FROM_STNID
				select @v_FROM_KL5 = KL5_CODE from KLASYFIKATOR5v where KL5_ROWID = @c_FROM_KL5ID
				select @v_TO_CCD = STN_CCD from STATIONv where STN_ROWID = @c_TO_STNID
				select @v_TO_KL5 = KL5_CODE from KLASYFIKATOR5v where KL5_ROWID = @c_TO_KL5ID
				
				if 
					not exists (select 1 from dbo.ASSET (nolock) where AST_CODE = @c_AST_CODE and AST_SUBCODE <> isnull(@c_AST_SUBCODE,'')) --jest tylko składnik główny
					or
					not exists (select 1 from dbo.ASSET (nolock) where AST_CODE = @c_AST_CODE and AST_ROWID not in (select MOL_OBJID from MOVEMENTLN (nolock) join OBJASSET (nolock) on OBA_OBJID = MOL_OBJID where MOL_MOVID = @c_MOV_ROWID))--wszystkie podskładniki tego składnika są wysyłane w tym FR (można to zrobić MT1)
				-----------------------------------------------------------------------------------
				----------------------------------------MT1----------------------------------------
				-----------------------------------------------------------------------------------
				begin
			 
					select @v_COUNT_MT1 = @v_COUNT_MT1 + 1
					select @v_OT31_ID = NEWID()
					select @v_OT31_ORG = dbo.GetOrgDef('OT31_RC',@p_UseriD)
					select @v_OT31_STATUS = dbo.[GetStatusDef]('OT31_RC',NULL,@p_UseriD)
					select @v_OT31_IMIE_NAZWISKO = SAPLogin from SyUsers (nolock) where UserID = @p_UseriD
				
					if not exists (
						select * from SAPO_ZWFOT31LN (nolock) L join dbo.ZWFOT31v (nolock) on OT31_ROWID = L.OT31LN_OT31ID 
						where 
							L.OT31LN_MPK_WYDANIA = @v_FROM_CCD and
							L.OT31LN_GDLGRP = @v_FROM_KL5 and 
							L.OT31LN_MPK_PRZYJECIA = @v_TO_CCD and  
							L.OT31LN_UZYTKOWNIK = @v_TO_KL5 and 
							OT_STATUS not in ('OT31_50','OT31_60'))
					begin
						--print 'MT1 NAG'
						exec [dbo].[ZWFOT31_Update_Proc] 
							@p_FormID  = 'OT31_RC' ,
							@p_ROWID = NULL,
							@p_CODE = 'autonumer',
							@p_ID = @v_OT31_ID,
							@p_ORG = @v_OT31_ORG,
							@p_RSTATUS = 0,
							@p_STATUS = @v_OT31_STATUS,
							@p_STATUS_old = NULL,
							@p_TYPE = NULL,
							@p_BUKRS = 'PPSA',
							@p_CCD_DEFAULT = @v_FROM_CCD,
							@p_IF_EQUNR = NULL,
							@p_IF_SENTDATE = NULL,
							@p_IF_STATUS = NULL,
							@p_IMIE_NAZWISKO = @v_OT31_IMIE_NAZWISKO, 
							@p_KROK = 1, 
							@p_SAPUSER = '',
							@p_ZMT_ROWID = NULL, 
							@p_UserID  = @p_UserID;

						select @v_OT31ID = OT31_ROWID from dbo.ZWFOT31v (nolock) where OT_ID = @v_OT31_ID
					
					end					
					else
					begin
					 
						select @v_OT31ID = OT31_ROWID from SAPO_ZWFOT31LN (nolock) L join dbo.ZWFOT31v (nolock) on OT31_ROWID = L.OT31LN_OT31ID 
						where 
							L.OT31LN_MPK_WYDANIA = @v_FROM_CCD and
							L.OT31LN_GDLGRP = @v_FROM_KL5 and 
							L.OT31LN_MPK_PRZYJECIA = @v_TO_CCD and  
							L.OT31LN_UZYTKOWNIK = @v_TO_KL5 and 
							OT_STATUS not in ('OT31_50','OT31_60')
							
					end
													 
					select @v_OT31LN_ID = NEWID()
					select @v_DT_WYDANIA = GETDATE()
						
					if not exists (select * from ZWFOT31LNv where OT31LN_OT31ID = @v_OT31ID and OT31LN_ANLN1_POSKI = @c_AST_CODE)
					begin
						--print 'MT1 LN'			
						exec [dbo].[ZWFOT31LN_Update_Proc] 
							@p_FormID  = 'OT31_LN' ,
							@p_ROWID = NULL,
							@p_OT31ID = @v_OT31ID,
							@p_CODE = 'autonumer',
							@p_ID = @v_OT31LN_ID,
							@p_ORG = @v_OT31_ORG,
							@p_RSTATUS = 0,
							@p_STATUS = NULL,
							@p_STATUS_old = NULL,
							@p_TYPE = NULL,
							@p_LP = NULL,
							@p_BUKRS = 'PPSA',
							@p_ANLN1_POSKI = @c_AST_CODE,
							@p_UZASADNIENIE = 'Przeniesiony na formularzu ruchu ZMT',
							@p_DT_WYDANIA = @v_DT_WYDANIA,
							@p_MPK_WYDANIA_POSKI = @v_FROM_CCD,
							@p_GDLGRP_POSKI = @v_FROM_KL5,
							@p_DT_PRZYJECIA = @v_DT_WYDANIA,
							@p_MPK_PRZYJECIA_POSKI = @v_TO_CCD,
							@p_UZYTKOWNIK_POSKI = @v_TO_KL5,
							@p_ZMT_ROWID = NULL,
							@p_PRACOWNIK = '',
							@p_UserID  = @p_UserID;
					end
					
					update dbo.MOVEMENTLN set MOL_OT31ID = @v_OT31ID where MOL_ROWID = @c_MOL_ROWID
	
				end
				else
				-----------------------------------------------------------------------------------
				----------------------------------------MT3----------------------------------------
				-----------------------------------------------------------------------------------
				begin	

					select @v_COUNT_MT3 = @v_COUNT_MT3 + 1
					select @v_OT33_ID = NEWID()
					select @v_OT33_ORG = dbo.GetOrgDef('OT33_RC',@p_UseriD)
					select @v_OT33_STATUS = dbo.[GetStatusDef]('OT33_RC',NULL,@p_UseriD)
					select @v_OT33_MTOPER = case when @c_AST_SUBCODE = '0000' then 3 else 5 end
					--select OPER, OPER_DESC from [dbo].[GetMT3Type] ()
					select @v_OT33_IMIE_NAZWISKO = SAPLogin from SyUsers (nolock) where UserID = @p_UseriD
					
					--print 'MT3 NAG'
					exec [dbo].[ZWFOT33_Update_Proc] 
						@p_FormID  = 'OT33_RC',
						@p_ROWID = NULL,
						@p_CODE = 'autonumer',
						@p_ID = @v_OT33_ID,
						@p_ORG = @v_OT33_ORG,
						@p_RSTATUS = 0,
						@p_STATUS = @v_OT33_STATUS,
						@p_STATUS_old = NULL,
						@p_TYPE = NULL,
						@p_BUKRS = 'PPSA',
						@p_MTOPER = @v_OT33_MTOPER,
						@p_CZY_BEZ_ZM = 'N',
						@p_CZY_ROZ_OKR = 'N',
						@p_IF_EQUNR = NULL,
						@p_IF_SENTDATE = NULL,
						@p_IF_STATUS = NULL,
						@p_IMIE_NAZWISKO = @v_OT33_IMIE_NAZWISKO, 
						@p_KROK = 1, 
						@p_SAPUSER = '',
						@p_ZMT_ROWID = NULL, 
						@p_UserID  = @p_UseriD;

					select @v_OT33ID = OT33_ROWID from dbo.ZWFOT33v (nolock) where OT_ID = @v_OT33_ID
					select @v_OT33LN_ID = NEWID()
					select @v_DT_WYDANIA = GETDATE()
					
					--print 'MT3 LN'
					exec [dbo].[ZWFOT33LN_Update_Proc] 
						@p_FormID  = 'OT33_LN' ,
						@p_ROWID = NULL,
						@p_OT33ID = @v_OT33ID,
						@p_CODE = NULL,
						@p_ID = @v_OT33LN_ID,
						@p_ORG = @v_OT33_ORG,
						@p_RSTATUS = 0,
						@p_STATUS = NULL,
						@p_STATUS_old = NULL,
						@p_TYPE = NULL,
						@p_LP = NULL,
						@p_BUKRS = 'PPSA',
						@p_ANLN1_POSKI = @c_AST_CODE,
						@p_DT_WYDANIA = @v_DT_WYDANIA,
						@p_MPK_WYDANIA_POSKI = @v_FROM_CCD,
						@p_GDLGRP_POSKI = @v_FROM_KL5,
						@p_UZASADNIENIE = 'Przeniesiony na formularzu ruchu ZMT',
						@p_TXT50 = '',
						@p_ZMT_ROWID = NULL, 
						@p_UserID  = @p_UserID;
						 
					--select * from ZWFOT33DONv where 
					--	OT33DON_OT33ID = @v_OT33ID and
					--	OT33DON_ANLN1_POSKI = @c_AST_CODE and 
					--	OT33DON_ANLN2 = @c_AST_SUBCODE
						
					--print 'MT3 DON'
					exec [dbo].[ZWFOT33DON_Update_Proc] 
						@p_FormID  = 'OT33_DON',
						@p_ROWID = NULL,
						@p_OT33ID = @v_OT33ID,
						@p_CODE = NULL,
						@p_ID = NULL,
						@p_ORG = @v_OT33_ORG,
						@p_RSTATUS = 0,
						@p_STATUS = NULL,
						@p_STATUS_old = NULL,
						@p_TYPE = NULL,
						@p_TXT50 = 'TXT50',
						@p_WARST = 100,
						@p_NDJARPER = 0,
						@p_MTOPER = @v_OT33_MTOPER,
						@p_ANLN1_POSKI = @c_AST_CODE,
						@p_ANLN2 = @c_AST_SUBCODE,
						@p_ANLN1_DO_POSKI = NULL,
						@p_ANLN2_DO = NULL,
						@p_ANLKL_DO_POSKI = '',
						@p_KOSTL_DO_POSKI = @v_TO_CCD,
						@p_UZYTK_DO_POSKI = @v_TO_KL5,
						@p_PRAC_DO = '',
						@p_PRCNT_DO = 100,
						@p_WARST_DO = 0,
						@p_TXT50_DO = '',
						@p_NDPER_DO = 0,
						@p_CHAR_DO = '',
						@p_BELNR = '',
						@p_ZMT_ROWID = NULL,
						@p_STNID = NULL,   
						@p_STS = NULL,
						@p_OT33_OPERATION = NULL,
						@p_UserID  = @p_UserID;

					update dbo.MOVEMENTLN set MOL_OT33ID = @v_OT33ID where MOL_ROWID = @c_MOL_ROWID
					
				end
			  
				fetch next from c_MOLLN
				into @c_MOL_ROWID, @c_MOV_ROWID, @c_AST_CODE, @c_AST_SUBCODE, @c_FROM_STNID, @c_FROM_KL5ID, @c_TO_STNID, @c_TO_KL5ID
				 
			end

			close c_MOLLN
			deallocate c_MOLLN
	 
		end try
		begin catch
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'ERR_INS'
			goto errorlabel_c
		end catch
	end 
 
	
	select @v_errortext = '<B> Utworzono dokumentów MT1: ' + cast(@v_COUNT_MT1 as nvarchar) + '<B><BR>'
	select @v_errortext = @v_errortext + '<B> Utworzono dokumentów MT2: ' + cast(@v_COUNT_MT2 as nvarchar) + '<B><BR>'
	select @v_errortext = @v_errortext + '<B> Utworzono dokumentów MT3: ' + cast(@v_COUNT_MT3 as nvarchar) + '<B><BR>'
	--select @v_errortext = @v_errortext + '<B> Utworzono dokumentów PL: ' + cast(@v_COUNT_PL as nvarchar) + '<B><BR>'
	--select @v_errortext = @v_errortext +' <B> Utworzono dokumentów LTW: ' + cast(@v_COUNT_LTW as nvarchar) + '<B>'
	
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