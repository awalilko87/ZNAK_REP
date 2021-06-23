SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[MOV_Update_Proc]
(
	@p_FormID nvarchar(50),
	@p_ID nvarchar(50),
	@p_ROWID int,
	@p_STNID int, 
	@p_CODE nvarchar(30),
	@p_ORG nvarchar(30),
	@p_DESC nvarchar(80),
	@p_NOTE ntext,
	@p_DATE datetime,
	@p_STATUS nvarchar(30),
	@p_STATUS_old nvarchar(30),
	@p_TYPE nvarchar(30),
	@p_TYPE2 nvarchar(30),
	@p_TYPE3 nvarchar(30),
	@p_NOTUSED int,
	@p_TXT01 nvarchar(30),
	@p_TXT02 nvarchar(30),
	@p_TXT03 nvarchar(30),
	@p_TXT04 nvarchar(30),
	@p_TXT05 nvarchar(30),
	@p_TXT06 nvarchar(80),
	@p_TXT07 nvarchar(80),
	@p_TXT08 nvarchar(255),
	@p_TXT09 nvarchar(255),
	@p_NTX01 numeric(24,6),
	@p_NTX02 numeric(24,6),
	@p_NTX03 numeric(24,6),
	@p_NTX04 numeric(24,6),
	@p_NTX05 numeric(24,6),
	@p_COM01 ntext,
	@p_COM02 ntext,
	@p_DTX01 datetime,
	@p_DTX02 datetime,
	@p_DTX03 datetime,
	@p_DTX04 datetime,
	@p_DTX05 datetime,
	@p_UserID nvarchar(30), 
	@p_apperrortext nvarchar(4000) output
)
as
begin  
	 
	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @v_errorid int
	declare @v_date datetime
	declare @v_Rstatus int
	declare @v_Pref nvarchar(10)
	declare @v_MultiOrg bit
	declare @v_EXPOT nvarchar(30)
	declare @v_EXMOV nvarchar(30)
	  
	select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID
	select @v_Rstatus = isnull(STA_RFLAG,0) from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS
  
	if exists 	
		(select 1 from MOVEMENTLN  (nolock)
			join dbo.OBJ (nolock) on OBJ_ROWID = MOL_OBJID
			left join dbo.MOVEMENTCHECK (nolock) on MOC_MOVID = MOL_MOVID and MOC_OBGID = OBJ_GROUPID 
		where 
			MOL_STATUS = 'MOL_002' and --do przeniesienia
			MOL_MOVID = @p_ROWID and --w tym formularzu
			MOC_OBGID is null ) --nie ma zatwierdzonej grupy w MOVEMENTCHECK	 
		and @p_STATUS = 'MOV_003'
		
	begin
		select @v_errorcode = 'MOV_001' --select * from vs_langmsgs where objectid = 'MOV_001'
		goto errorlabel
	end  

	if not exists (select * from [dbo].[MOVEMENT] (nolock) where MOV_ID = @p_ID)
	begin
		declare @v_prefix nvarchar(100)
		--select @v_prefix = convert(nvarchar,year(getdate()))+'/'+left(@p_ORG,1)+'/'
		--select @v_prefix = left(@p_ORG,1)+'_'+convert(nvarchar,year(getdate()))+'_'  --nazwa w formacie C_2012_00011
		select @v_prefix = 'MOV_'+convert(nvarchar,year(getdate()))  --nazwa w formacie INW201200003
		exec dbo.VS_GetNumber @Type = 'MOV', @Pref = @v_prefix, @Suff = '', @Number = @p_CODE output

		begin try
			insert into [dbo].[MOVEMENT](
				MOV_CODE,
				MOV_ORG, 
				MOV_DESC,
				MOV_STATUS, 
				MOV_TYPE,  
				MOV_TYPE2,  
				MOV_TYPE3, 
				MOV_CREDATE, 
				MOV_CREUSER,  
				MOV_DATE,   
				MOV_NOTE, 
				MOV_NOTUSED, 
				MOV_ID,
				MOV_STNID,
				MOV_COM01, 
				MOV_COM02, 
				MOV_DTX01, 
				MOV_DTX02, 
				MOV_DTX03, 
				MOV_DTX04, 
				MOV_DTX05, 
				MOV_NTX01, 
				MOV_NTX02, 
				MOV_NTX03, 
				MOV_NTX04, 
				MOV_NTX05,  
				MOV_TXT01, 
				MOV_TXT02, 
				MOV_TXT03, 
				MOV_TXT04, 
				MOV_TXT05, 
				MOV_TXT06, 
				MOV_TXT07, 
				MOV_TXT08, 
				MOV_TXT09)
			values (
				@p_CODE, 
				@p_ORG, 
				@p_DESC,
				@p_STATUS,   
				@p_TYPE,  
				@p_TYPE2,   
				@p_TYPE3, 
				getdate(),
				@p_UserID,  
				@p_DATE,  
				@p_NOTE, 
				@p_NOTUSED,
				@p_ID,
				@p_STNID,
				@p_COM01, 
				@p_COM02, 
				@p_DTX01, 
				@p_DTX02, 
				@p_DTX03, 
				@p_DTX04,
				@p_DTX05, 
				@p_NTX01, 
				@p_NTX02, 
				@p_NTX03, 
				@p_NTX04, 
				@p_NTX05,   
				@p_TXT01, 
				@p_TXT02, 
				@p_TXT03, 
				@p_TXT04, 
				@p_TXT05, 
				@p_TXT06, 
				@p_TXT07, 
				@p_TXT08, 
				@p_TXT09
			)
			select @p_ROWID = IDENT_CURRENT('[dbo].[MOVEMENT]')
		end try
		begin catch
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'ERR_INS'
			goto errorlabel
		end catch
	end 
	else 
	begin 
		begin try
			update [dbo].[MOVEMENT] set
				MOV_COM01 = @p_COM01, 
				MOV_COM02 = @p_COM02, 
				MOV_DTX01 = @p_DTX01, 
				MOV_DTX02 = @p_DTX02, 
				MOV_DTX03 = @p_DTX03,
				MOV_DTX04 = @p_DTX04, 
				MOV_DTX05 = @p_DTX05, 
				MOV_NTX01 = @p_NTX01, 
				MOV_NTX02 = @p_NTX02, 
				MOV_NTX03 = @p_NTX03, 
				MOV_NTX04 = @p_NTX04, 
				MOV_NTX05 = @p_NTX05,  
				MOV_CODE = @p_CODE,  
				MOV_DATE = @p_DATE, 
				MOV_DESC = @p_DESC, 
				MOV_NOTE = @p_NOTE, 
				MOV_NOTUSED = @p_NOTUSED, 
				MOV_ORG = @p_ORG, 
				MOV_STATUS = @p_STATUS,   
				MOV_RSTATUS = @v_Rstatus,
				MOV_TYPE = @p_TYPE,  
				MOV_TYPE2 = @p_TYPE2,   
				MOV_TYPE3 = @p_TYPE3,   
				MOV_UPDDATE = getdate(), 
				MOV_UPDUSER = @p_UserID,  
				MOV_TXT01 = @p_TXT01, 
				MOV_TXT02 = @p_TXT02, 
				MOV_TXT03 = @p_TXT03, 
				MOV_TXT04 = @p_TXT04, 
				MOV_TXT05 = @p_TXT05, 
				MOV_TXT06 = @p_TXT06, 
				MOV_TXT07 = @p_TXT07, 
				MOV_TXT08 = @p_TXT08, 
				MOV_TXT09 = @p_TXT09,
				MOV_STNID = @p_STNID 
			where MOV_ROWID = @p_ROWID
			 
			
			
		end try
		begin catch
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'ERR_UPD'
			goto errorlabel
		end catch
	end 
	
	if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'') 
	begin
		exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = @p_STATUS_old, @p_UserID = @p_UserID
	end
 
	------------------------------------------------------------------------------------------------
	-------------------KURSOR do uzupełnienia pozycji składników do przeniesienia-------------------
	------------------------------------------------------------------------------------------------
	--tylko podczas zapisu formularza w statusie utworzony!
	if @p_STATUS = 'MOV_001'
	begin
		
		delete from dbo.MOVEMENTLN where MOL_MOVID = @p_ROWID
		
		declare @c_OBJID int
		
		declare c_cursor cursor static for
		select OBJ_ROWID from dbo.OBJ (nolock)	
			join dbo.OBJSTATION (nolock) on OSA_OBJID = OBJ_ROWID
		where OSA_STNID = isnull(@p_STNID,0)
		
		open c_cursor 
		
		fetch next from c_cursor 
		into @c_OBJID 
		 
		while @@FETCH_STATUS = 0
		begin
			if not exists (select * from dbo.MOVEMENTLN (nolock) where MOL_OBJID = @c_OBJID and MOL_MOVID = @p_ROWID)
			begin
				
				--Sprawdza czy są na innych protokołach lub formularzach przeniesienia
				select 
					@v_EXPOT = POT_CODE
				from 
					[dbo].[OBJTECHPROTLN] (nolock) 
					join [dbo].[OBJTECHPROT] (nolock) on POT_ROWID = POL_POTID 
				where 
					POL_OBJID = @c_OBJID 
					and POT_STATUS in ('POT_001','POT_002') 
					and @c_OBJID = POL_OBJID 
					
				--Sprawdza czy są na innych protokołach
				select 
					@v_EXMOV = MOV_CODE
				from 
					[dbo].[MOVEMENTLN] (nolock) 
					join [dbo].[MOVEMENT] (nolock) on MOV_ROWID = MOL_MOVID 
				where 
					MOV_ROWID <> isnull(@p_ROWID,0)
					and	MOL_OBJID = @c_OBJID 
					and MOL_STATUS in ('MOV_001','MOV_002') 
					and @c_OBJID = MOL_OBJID 
				
				if @v_EXPOT is null and @v_EXMOV is null
				begin
				
					insert into dbo.MOVEMENTLN				
					(
						MOL_MOVID, MOL_OBJID, MOL_CODE, 
						MOL_CREDATE, MOL_CREUSER,  MOL_DATE, MOL_DESC, MOL_ID, 
						MOL_NOTE, MOL_NOTUSED, MOL_ORG, MOL_RSTATUS, MOL_STATUS, MOL_TYPE
					)
					select
						@p_ROWID, @c_OBJID, '', 
						GETDATE(), @p_UserID, @p_DATE, '' , NEWID(), 
						'', 0, @p_ORG, 0, 'MOL_004', @p_TYPE 
					
					--select * from sta where sta_code like 'OBJ_005'	--Przenoszony
					update dbo.OBJ set OBJ_STATUS = 'OBJ_005'	where OBJ_ROWID = @c_OBJID
					
				end
				else
				begin
					insert into dbo.MOVEMENTLN				
					(
						MOL_MOVID, MOL_OBJID, MOL_CODE, 
						MOL_CREDATE, MOL_CREUSER,  MOL_DATE, MOL_DESC, MOL_ID, 
						MOL_NOTE, MOL_NOTUSED, MOL_ORG, MOL_RSTATUS, MOL_STATUS, MOL_TYPE
					)
					select
						@p_ROWID, @c_OBJID, '', 
						GETDATE(), @p_UserID, @p_DATE, isnull('Likwidacja w protokole nr: ' + @v_EXPOT,'Likwidacja w formularzu nr: ' + @v_EXMOV) , NEWID(), 
						'', 0, @p_ORG, 0, 'MOL_007', @p_TYPE 
				end
				
				select @v_EXPOT = NULL, @v_EXMOV= NULL
			end
				  
			fetch next from c_cursor 
			into @c_OBJID 
		end
		
		close c_cursor 
		deallocate c_cursor 
		
	end
	
	------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------
		
  return 0
  
  errorlabel:
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
    select @p_apperrortext = @v_errortext
    return 1
END


GO