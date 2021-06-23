SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INWASTLN_OBJ_Update_Proc]
(
    @p_ASTID int,
    @p_OBJID int,	
    @p_TYPE int, 	
    @p_TYPE2 int, 
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
	declare @v_CCDID int
	declare @v_KL5ID int
	declare @v_STNID int
	declare @v_ASTCODE nvarchar(30)
	declare @v_ASTSUBCODE nvarchar(10)
 
	select top 1 @v_CCDID = AST_CCDID, @v_KL5ID = AST_KL5ID, @v_ASTCODE = AST_CODE, @v_ASTSUBCODE = AST_SUBCODE from dbo.ASSET (nolock) where AST_ROWID = @p_ASTID
	select top 1 @v_STNID = STN_ROWID from dbo.STATION (nolock) where STN_CCDID = @v_CCDID
 
	if 1=2 
	begin 
		select @v_errorcode = 'SYS_001'
		goto errorlabel
	end		 
	
	--usuwanie poprzednich
	if @p_TYPE2 = 2
	begin 
		delete from dbo.OBJASSET where OBA_OBJID = @p_OBJID and OBA_ASTID <> @p_ASTID
	end
	
	if @p_TYPE = 1 --powiązanie
	begin
		----------------------------------------------------------------------------------
		------------------------------Powiązanie OBJ i ASSET------------------------------
		----------------------------------------------------------------------------------
		
		if not exists (select 1 from dbo.OBJASSET (nolock) where OBA_OBJID = @p_OBJID and OBA_ASTID = @p_ASTID) 
		begin
			begin try
			 
				insert into dbo.OBJASSET (OBA_OBJID, OBA_ASTID, OBA_CREDATE, OBA_CREUSER)
				select @p_OBJID, @p_ASTID, getdate(), @p_UserID
					
				if @v_ASTSUBCODE = '0000'
				begin
					insert into dbo.OBJASSET (OBA_OBJID, OBA_ASTID, OBA_CREDATE, OBA_CREUSER)
					select @p_OBJID, AST_ROWID, getdate(), @p_UserID
					from dbo.ASSET
					where AST_CODE = @v_ASTCODE and AST_DONIESIENIE = 1 and AST_NOTUSED = 0
				end
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
				update dbo.OBJASSET set 
					OBA_UPDDATE = GETDATE(),
					OBA_UPDUSER = @p_UserID
				where OBA_OBJID = @p_OBJID
			end try
			begin catch
				select @v_syserrorcode = error_message()
				select @v_errorcode = 'ERR_UPD'
				goto errorlabel
			end catch
		end 
		
		----------------------------------------------------------------------------------
		------------------------------Powiązanie OBJ i STATION------------------------------
		----------------------------------------------------------------------------------
		if not exists (select 1 from dbo.OBJSTATION (nolock) where OSA_OBJID = @p_OBJID) 
		begin
			
			begin try
				insert into dbo.OBJSTATION (  
					OSA_OBJID, 
					OSA_STNID,
					OSA_KL5ID,
					OSA_CREDATE,
					OSA_CREUSER) 
				select
					@p_OBJID, 
					@v_STNID,
					@v_KL5ID,
					GETDATE(),
					@p_UserID
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
				update dbo.OBJSTATION set  
					OSA_KL5ID = @v_KL5ID,
					OSA_UPDDATE = GETDATE(), 
					OSA_UPDUSER = @p_UserID  
				where OSA_OBJID = @p_OBJID
			end try
			begin catch
				select @v_syserrorcode = error_message()
				select @v_errorcode = 'ERR_UPD'
				goto errorlabel
			end catch
		end 
	 end
	 --0 -- usunięcie 	 
	 else if @p_TYPE = 0
	 begin
		delete from dbo.OBJASSET where OBA_OBJID = @p_OBJID and OBA_ASTID = @p_ASTID
		
		if @v_ASTSUBCODE = '0000'
		begin
			delete from dbo.OBJASSET where OBA_OBJID = @p_OBJID and OBA_ASTID in (select AST_ROWID from dbo.ASSET where AST_CODE = @v_ASTCODE and AST_DONIESIENIE = 1)
		end
	 end
	 
	return 0
	
errorlabel:
	exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
	select @p_apperrortext = @v_errortext
	return 1
end
GO