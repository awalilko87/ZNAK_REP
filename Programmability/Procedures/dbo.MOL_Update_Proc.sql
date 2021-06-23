SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[MOL_Update_Proc]
(
    @p_MOVID int,
	@p_TO_STNID int,
    @p_OBJID int,
	@p_OBJ nvarchar(30),
    @p_COM01 ntext,
    @p_COM02 ntext,
    @p_DTX01 datetime,
    @p_DTX02 datetime,
    @p_DTX03 datetime,
    @p_DTX04 datetime,
    @p_DTX05 datetime,
    @p_NTX01 numeric(24,6),
    @p_NTX02 numeric(24,6),
    @p_NTX03 numeric(24,6),
    @p_NTX04 numeric(24,6),
    @p_NTX05 numeric(24,6),
    @p_ROWID int = NULL,
    @p_OLD_ROWID int = NULL,
    @p_MOL_CODE nvarchar(30) = NULL,
    @p_OLD_MOL_CODE nvarchar(30) = NULL,
    @p_CREDATE datetime,
    @p_CREUSER nvarchar(30), 
    @p_DATE datetime,
    @p_DESC nvarchar(80),
    @p_ID nvarchar(50),
    @p_NOTE ntext,
    @p_NOTUSED int,
    @p_ORG nvarchar(30), 
    @p_RSTATUS int,
    @p_STATUS nvarchar(30), 
    @p_TYPE nvarchar(30), 
    @p_TYPE2 nvarchar(30),
    @p_TYPE3 nvarchar(30),
    @p_UPDDATE datetime,
    @p_UPDUSER nvarchar(30), 
    @p_TXT01 nvarchar(30),
    @p_TXT02 nvarchar(30),
    @p_TXT03 nvarchar(30),
    @p_TXT04 nvarchar(30),
    @p_TXT05 nvarchar(30),
    @p_TXT06 nvarchar(80),
    @p_TXT07 nvarchar(80),
    @p_TXT08 nvarchar(255),
    @p_TXT09 nvarchar(255), 
    @p_UserID varchar(20), 
    @p_GroupID varchar(10), 
    @p_LangID varchar(10),
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
	declare @v_OBJID int 
	declare @v_MOV_CODE nvarchar(30)
	declare @v_OLDQTY numeric(30,6)
	
	select top 1 @v_MOV_CODE = MOV_CODE from dbo.MOVEMENT(nolock) where MOV_ROWID = @p_MOVID
	select top 1 @v_OBJID = OBJ_ROWID from dbo.OBJ(nolock) where OBJ_CODE = @p_OBJ
	--select @v_OLDQTY = QTY from dbo.ASSSTOCKv(nolock) where MAG = @MOL_MAG and PLACE = @MOL_PLACE and ASSORTID = @v_ASSID
	 
	if ISNULL(@p_TO_STNID,0) = 0
		select @p_STATUS = 'MOL_001'
	else 
		select @p_STATUS = 'MOL_002'
		
	if exists (select 1 from dbo.MOVEMENT (nolock)join dbo.MOVEMENTLN (nolock) on MOV_ROWID = MOL_MOVID 
		where 
			MOL_OBJID = @v_OBJID and  
			MOV_STATUS in ('MOV_002','MOV_001') and
			MOL_ID <> @p_ID --istnieje taki obiej
		)
	begin 
		select @v_errorcode = 'SYS_005'
		goto errorlabel
	end		 
		
	if not exists (select 1 from dbo.MOVEMENTLN (nolock) where MOL_ID = @p_ID)
	begin
		
		begin try
			insert into dbo.MOVEMENTLN(
				MOL_MOVID,
				MOL_TO_STNID,
				MOL_OBJID, 
				MOL_COM01, 
				MOL_COM02,
				MOL_DTX01,
				MOL_DTX02, 
				MOL_DTX03, 
				MOL_DTX04, 
				MOL_DTX05, 
				MOL_NTX01, 
				MOL_NTX02, 
				MOL_NTX03, 
				MOL_NTX04, 
				MOL_NTX05,  
				MOL_CODE, 
				MOL_CREDATE, 
				MOL_CREUSER,  
				MOL_DATE, 
				MOL_DESC, 
				MOL_ID, 
				MOL_NOTE, 
				MOL_NOTUSED, 
				MOL_ORG, 
				MOL_RSTATUS, 
				MOL_STATUS,  
				MOL_TYPE,  
				MOL_TYPE2, 
				MOL_TYPE3, 
				MOL_TXT01,
				MOL_TXT02, 
				MOL_TXT03, 
				MOL_TXT04, 
				MOL_TXT05, 
				MOL_TXT06, 
				MOL_TXT07, 
				MOL_TXT08, 
				MOL_TXT09)
			select
				@p_MOVID, 
				@p_TO_STNID, 
				@v_OBJID, 
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
				@v_MOV_CODE, 
				@p_CREDATE, 
				@p_CREUSER,  
				@p_DATE, 
				@p_DESC, 
				@p_ID, 
				@p_NOTE, 
				@p_NOTUSED, 
				@p_ORG, 
				@p_RSTATUS, 
				@p_STATUS,
				@p_TYPE,  
				@p_TYPE2, 
				@p_TYPE3, 
				@p_TXT01, 
				@p_TXT02, 
				@p_TXT03, 
				@p_TXT04, 
				@p_TXT05, 
				@p_TXT06, 
				@p_TXT07, 
				@p_TXT08, 
				@p_TXT09 
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
			update dbo.MOVEMENTLN set
				MOL_TO_STNID = @p_TO_STNID,
				MOL_OBJID = @v_OBJID,
				MOL_COM01 = @p_COM01, 
				MOL_COM02 = @p_COM02, 
				MOL_DTX01 = @p_DTX01, 
				MOL_DTX02 = @p_DTX02, 
				MOL_DTX03 = @p_DTX03, 
				MOL_DTX04 = @p_DTX04, 
				MOL_DTX05 = @p_DTX05, 
				MOL_NTX01 = @p_NTX01, 
				MOL_NTX02 = @p_NTX02, 
				MOL_NTX03 = @p_NTX03, 
				MOL_NTX04 = @p_NTX04, 
				MOL_NTX05 = @p_NTX05,  
				MOL_TXT01 = @p_TXT01, 
				MOL_TXT02 = @p_TXT02, 
				MOL_TXT03 = @p_TXT03, 
				MOL_TXT04 = @p_TXT04,
				MOL_TXT05 = @p_TXT05,
				MOL_TXT06 = @p_TXT06, 
				MOL_TXT07 = @p_TXT07, 
				MOL_TXT08 = @p_TXT08, 
				MOL_TXT09 = @p_TXT09,
				MOL_CODE = @v_MOV_CODE,  
				MOL_DATE = @p_DATE, 
				MOL_DESC = @p_DESC,  
				MOL_NOTE = @p_NOTE, 
				MOL_NOTUSED = @p_NOTUSED, 
				MOL_ORG = @p_ORG, 
				MOL_RSTATUS = @p_RSTATUS, 
				MOL_STATUS = @p_STATUS, 
				MOL_TYPE = @p_TYPE, 
				MOL_TYPE2 = @p_TYPE2, 
				MOL_TYPE3 = @p_TYPE3, 
				MOL_UPDDATE = getdate(), 
				MOL_UPDUSER = @p_UserID,  
				MOL_PRICE = 0
			where MOL_ID = @p_ID
		end try
		begin catch
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'ERR_UPD'
			goto errorlabel
		end catch
	end 
 
	--select * from sta where sta_entity like 'MOL' 
	--select * from sta where sta_entity like 'OBJ' 
	if @p_STATUS = 'MOL_001'
		update OBJ set OBJ_STATUS = 'OBJ_002' where OBJ_ROWID in (select MOL_OBJID from dbo.MOVEMENTLN (nolock) where MOL_ID = @p_ID)
	else if @p_STATUS = 'MOL_002'
		update OBJ set OBJ_STATUS = 'OBJ_005' where OBJ_ROWID in (select MOL_OBJID from dbo.MOVEMENTLN (nolock) where MOL_ID = @p_ID)
	 
	return 0
	
errorlabel:
	exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
	select @p_apperrortext = @v_errortext
	return 1
end

GO