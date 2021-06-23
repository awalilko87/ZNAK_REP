SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INWASTLN_LSRC_Update_Proc]
(
    @SIA_SINID int,
    @SIA_ASTID int,
	@SIA_ASTCODE nvarchar(30),
	@SIA_ASTSUBCODE nvarchar(30),
	@SIA_BARCODE nvarchar(30),
    @SIA_OLDQTY decimal(30,6),
    @SIA_NEWQTY decimal(30,6),
    @COM01 ntext,
    @COM02 ntext,
    @DTX01 datetime,
    @DTX02 datetime,
    @DTX03 datetime,
    @DTX04 datetime,
    @DTX05 datetime,
    @NTX01 numeric(24,6),
    @NTX02 numeric(24,6),
    @NTX03 numeric(24,6),
    @NTX04 numeric(24,6),
    @NTX05 numeric(24,6),
    @ROWID int = NULL,
    @OLD_ROWID int = NULL,
    @SIA_CODE nvarchar(30) = NULL,
    @OLD_SIA_CODE nvarchar(30) = NULL,
    @SIA_CREDATE datetime,
    @SIA_CREUSER nvarchar(30), 
    @SIA_DATE datetime,
    @SIA_DESC nvarchar(80),
    @SIA_ID nvarchar(50),
    @SIA_NOTE ntext,
    @SIA_NOTUSED int,
    @SIA_ORG nvarchar(30), 
    @SIA_RSTATUS int,
    @SIA_STATUS nvarchar(30), 
    @SIA_TYPE nvarchar(30), 
    @SIA_TYPE2 nvarchar(30),
    @SIA_TYPE3 nvarchar(30),
    @SIA_UPDDATE datetime,
    @SIA_UPDUSER nvarchar(30), 
    @TXT01 nvarchar(30),
    @TXT02 nvarchar(30),
    @TXT03 nvarchar(30),
    @TXT04 nvarchar(30),
    @TXT05 nvarchar(30),
    @TXT06 nvarchar(80),
    @TXT07 nvarchar(80),
    @TXT08 nvarchar(255),
    @TXT09 nvarchar(255),
	@SIA_PRICE numeric(30,6),
    @_UserID varchar(20), 
    @_GroupID varchar(10), 
    @_LangID varchar(10),
	@p_apperrortext nvarchar(4000) = null output
)
as
begin 

	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @v_date datetime
	declare @v_Rstatus int
	declare @v_Pref nvarchar(10)
	declare @v_MultiOrg bit
	declare @v_ASTID int
	declare @v_OBJID int
	declare @v_SIN_CODE nvarchar(30)
	declare @v_SIN_STATUS nvarchar(30)
	declare @v_OLDQTY numeric(30,6)
	declare @v_BARCODE nvarchar(30)
	declare @v_OLDSTATUS nvarchar(30)

	select top 1 @v_SIN_CODE = SIN_CODE, @v_SIN_STATUS = SIN_STATUS from dbo.ST_INW(nolock) where SIN_ROWID = @SIA_SINID
	select top 1 @v_ASTID = AST_ROWID, @v_BARCODE = AST_BARCODE  from dbo.ASSET(nolock) where AST_CODE = @SIA_ASTCODE and AST_SUBCODE = @SIA_ASTSUBCODE
	--select @v_OLDQTY = QTY from dbo.ASSSTOCKv(nolock) where MAG = @SIA_MAG and PLACE = @SIA_PLACE and ASSORTID = @v_ASSID
	select @v_OLDSTATUS = SIA_STATUS from AST_INWLN (nolock) where SIA_ROWID = @ROWID

	if @v_ASTID is null
		select @v_BARCODE = OBJ_CODE, @v_OBJID = OBJ_ROWID from dbo.OBJ (nolock) where OBJ_CODE = @SIA_BARCODE

	if @SIA_NEWQTY is not null 
	set @SIA_STATUS = 'INW' 
	
	if isnull(@v_SIN_STATUS,'') <> 'SIN_003' 
		goto break_exit 
	
	if exists (select 1 from dbo.AST_INWLN (nolock)join dbo.ST_INW (nolock) on SIN_ROWID = SIA_SINID 
		where 
			SIA_ASSETID = @v_ASTID and  
			SIN_STATUS in ('SIN_002','SIN_001') and
			AST_INWLN.SIA_ID <> @SIA_ID and
			SIN_ROWID = @SIA_SINID
		)
	begin 
		select @v_errorcode = 'SYS_005'
		goto errorlabel
	end		 
		
	if not exists (select 1 from dbo.AST_INWLN (nolock) where SIA_ID = @SIA_ID)
	begin
		
		begin try
			insert into dbo.AST_INWLN(
				SIA_SINID,
				SIA_ASSETID, 
				SIA_OBJID,
				SIA_BARCODE,
				SIA_OLDQTY,
				SIA_NEWQTY,
				SIA_COM01, 
				SIA_COM02,
				SIA_DTX01,
				SIA_DTX02, 
				SIA_DTX03, 
				SIA_DTX04, 
				SIA_DTX05, 
				SIA_NTX01, 
				SIA_NTX02, 
				SIA_NTX03, 
				SIA_NTX04, 
				SIA_NTX05,  
				SIA_CODE, 
				SIA_CREDATE, 
				SIA_CREUSER,  
				SIA_DATE, 
				SIA_DESC, 
				SIA_ID, 
				SIA_NOTE, 
				SIA_NOTUSED, 
				SIA_ORG, 
				SIA_RSTATUS, 
				SIA_STATUS,  
				SIA_TYPE,  
				SIA_TYPE2, 
				SIA_TYPE3, 
				SIA_TXT01,
				SIA_TXT02, 
				SIA_TXT03, 
				SIA_TXT04, 
				SIA_TXT05, 
				SIA_TXT06, 
				SIA_TXT07, 
				SIA_TXT08, 
				SIA_TXT09,
				SIA_PRICE,
				SIA_NADWYZKA)
			select
				@SIA_SINID, 
				@v_ASTID, 
				@v_OBJID,
				@v_BARCODE,
				@v_OLDQTY,
				1,
				@COM01, 
				@COM02, 
				@DTX01, 
				@DTX02, 
				@DTX03, 
				@DTX04, 
				@DTX05, 
				@NTX01, 
				@NTX02, 
				@NTX03, 
				@NTX04, 
				@NTX05,  
				@v_SIN_CODE, 
				@SIA_CREDATE, 
				@SIA_CREUSER,  
				@SIA_DATE, 
				@SIA_DESC, 
				@SIA_ID, 
				@SIA_NOTE, 
				@SIA_NOTUSED, 
				@SIA_ORG, 
				@SIA_RSTATUS, 
				'INW',
				@SIA_TYPE,  
				@SIA_TYPE2, 
				@SIA_TYPE3, 
				@TXT01, 
				@TXT02, 
				@TXT03, 
				@TXT04, 
				@TXT05, 
				@TXT06, 
				@TXT07, 
				@TXT08, 
				@TXT09,
				0,
				1
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
			update dbo.AST_INWLN set
				SIA_ASSETID = @v_ASTID,
				SIA_BARCODE = @v_BARCODE,
				SIA_OLDQTY = @v_OLDQTY,
				SIA_NEWQTY = @SIA_NEWQTY,
				SIA_COM01 = @COM01, 
				SIA_COM02 = @COM02, 
				SIA_DTX01 = @DTX01, 
				SIA_DTX02 = @DTX02, 
				SIA_DTX03 = @DTX03, 
				SIA_DTX04 = @DTX04, 
				SIA_DTX05 = @DTX05, 
				SIA_NTX01 = @NTX01, 
				SIA_NTX02 = @NTX02, 
				SIA_NTX03 = @NTX03, 
				SIA_NTX04 = @NTX04, 
				SIA_NTX05 = @NTX05,  
				SIA_TXT01 = @TXT01, 
				SIA_TXT02 = @TXT02, 
				SIA_TXT03 = @TXT03, 
				SIA_TXT04 = @TXT04,
				SIA_TXT05 = @TXT05,
				SIA_TXT06 = @TXT06, 
				SIA_TXT07 = @TXT07, 
				SIA_TXT08 = @TXT08, 
				SIA_TXT09 = @TXT09,
				SIA_CODE = @v_SIN_CODE, 
				SIA_CREDATE = @SIA_CREDATE, 
				SIA_CREUSER = @SIA_CREUSER, 
				SIA_DATE = @SIA_DATE, 
				SIA_DESC = @SIA_DESC,  
				SIA_NOTE = @SIA_NOTE, 
				SIA_NOTUSED = @SIA_NOTUSED, 
				SIA_ORG = @SIA_ORG, 
				SIA_RSTATUS = @SIA_RSTATUS, 
				SIA_STATUS = @SIA_STATUS, 
				SIA_TYPE = @SIA_TYPE, 
				SIA_TYPE2 = @SIA_TYPE2, 
				SIA_TYPE3 = @SIA_TYPE3, 
				SIA_UPDDATE = getdate(), 
				SIA_UPDUSER = @_UserID,  
				SIA_PRICE = 0,				
				SIA_CONFIRMUSER = case when @v_OLDSTATUS = 'NINW' and @SIA_STATUS = 'INW' then @_UserID else SIA_CONFIRMUSER end,
				SIA_CONFIRMDATE = case when @v_OLDSTATUS = 'NINW' and @SIA_STATUS = 'INW' then getdate() else SIA_CONFIRMDATE end

			where SIA_ID = @SIA_ID
		end try
		begin catch
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'ERR_UPD'
			goto errorlabel
		end catch
	end 

break_exit:

	return 0
	
errorlabel:
	exec err_proc @v_errorcode, @v_syserrorcode, @_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
	select @p_apperrortext = @v_errortext
	return 1
end
GO