SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INVTSK_ADD_OBJ_XLS_IMPORT_Multi] 
( 
	@p_PSP nvarchar(30),
	@p_STNID int,
	@p_key nvarchar(max),
	@p_UserID nvarchar(30)
)
 as 
 begin 
 
	declare  
		@v_PARENTID int,
		@v_STSID int,
		@v_STNID int,
		@v_PSPID int,
		@v_OBJID int,
		@v_ASTID int,
		@v_STS nvarchar(255), --STS_CODE 
		@v_STS_PARENT nvarchar(255), --STS_CODE_PARENT
		@v_VALUE nvarchar(255), --VALUE
		@v_QTY nvarchar(255), --QTY
		@v_COUNT int = 0, --QTY
		@v_INOID int = 0 ,
		@c_ROWID int,
		@v_ITSID int,
		@v_errorcode nvarchar(50),
		@v_errortext nvarchar(4000),
		@v_syserrorcode nvarchar(4000),
		@p_apperrortext nvarchar(max);
	 
		  
	if isnull(@p_KEY,'') = ''
	begin
		set @v_errorcode = 'SYS_010'
		goto errorlabel
	end

	declare c_XLS cursor for
	select String from dbo.VS_Split3(@p_KEY,';') where String <> ''
	 
	open c_XLS 

	fetch next from c_XLS 
	into @c_ROWID
	
	while @@FETCH_STATUS = 0 
	begin
	
		select 
			@v_STS_PARENT = c01,
			@v_STS = c03, 
			@v_VALUE = replace(replace(c07,',','.'),' ',''),
			@v_QTY = replace(replace(c08,',','.'),' ','') 
		from INVTSK_ADD_OBJ_EXCEL (nolock)
		where 
			isnumeric (c07) = 1 and 
			isnumeric (c08) = 1 and 
			ROWID = @c_ROWID and 
			c01 in (select KOM_CODE from STENCIL_KOMv) and
			c03 in (select EKOM_CODE from STENCIL_KOMv)

		if @v_STS is not null
		begin

			select @v_STSID = STS_ROWID from dbo.STENCIL (nolock) where STS_CODE = @v_STS
			select @v_STNID = STN_ROWID from dbo.STATION (nolock) 
				join COSTCODE (nolock) on CCD_ROWID = STN_CCDID
			where STN_ROWID = @p_STNID
			select @v_PSPID = PSP_ROWID, @v_ITSID = PSP_ITSID from PSP (nolock) where PSP_CODE = @p_PSP
		
			if isnull(@v_INOID,0) = 0 
			begin

				insert into INVTSK_NEW_OBJ (
					INO_ITSID, INO_STSID, INO_PSPID, INO_STNID, INO_CODE, INO_ORG,	INO_DESC, INO_DATE,
					INO_STATUS,	INO_TYPE, INO_TYPE2, INO_TYPE3,	INO_RSTATUS, INO_CREUSER, INO_CREDATE,
					INO_UPDUSER, INO_UPDDATE, INO_NOTUSED, INO_ID, INO_QTY)
  
				select 
					@v_ITSID, @v_STSID, @v_PSPID, @v_STNID, NULL, 'PKN',	'', getdate(),
					NULL,	NULL, NULL, NULL,	0, @p_UserID,  getdate(),
					NULL, NULL, 0, newid(), @v_QTY 
		 
				select @v_INOID = ident_current ('dbo.INVTSK_NEW_OBJ')

			end

			--while isnull(@v_QTY,0) > 0 
			--begin

				--if @v_STSID is not null and @v_STNID is not null 
				--begin
		  
				--	exec [dbo].[GenStsObj]
				--		@p_STSID = @v_STSID,
				--		@p_PSPID = @v_PSPID,
				--		@p_ANOID = NULL,
				--		@p_PARENTID = NULL,
				--		@p_STNID = @v_STNID,
				--		@p_UserID = 'SA',
				--		@p_OBJID = @v_OBJID output,
				--		@p_apperrortext = @v_apperrortext output
				
				--	select @v_COUNT = isnull(@v_COUNT,0) + 1
				 
				--	update OBJ set 
				--		OBJ_VALUE = cast (@v_VALUE as decimal(30,2)),
				--		OBJ_INOID = @v_INOID			 
				--	where 
				--		OBJ_ROWID = @v_OBJID
			   
				
					exec [dbo].[INVTSK_ADD_OBJ_LINES_Proc] 	
						'INVTSK_ADD_OBJ_XLS_IMPORT',
						@v_INOID,
						@v_QTY,
						@p_PSP, 
						@v_STS, 
						@v_STS_PARENT, 
						@v_VALUE,

						@p_UserID,
						@p_apperrortext output

				--end

				--select @v_QTY = @v_QTY - 1 

			--end
		
		end
			
		fetch next from c_XLS
		into @c_ROWID

	end

	close c_XLS 
	deallocate c_XLS 

	raiserror('Dodano %i składników',1,1,@v_COUNT)
	
return 0

errorlabel:
	exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
	return 1
		 
 end
GO