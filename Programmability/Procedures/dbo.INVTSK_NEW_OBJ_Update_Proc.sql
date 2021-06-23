SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[INVTSK_NEW_OBJ_Update_Proc]
(
	@p_INOID int,
	@p_PSP nvarchar(30),
	@p_STS nvarchar(30),
	@p_STN nvarchar(30),
	@p_VALUE decimal(30,6),
	
	@p_OBJ nvarchar(30),

	@p_UserID nvarchar(30) = NULL, -- uzytkownik
	@p_apperrortext nvarchar(4000) = null output
)
as
begin
		 
	declare @v_errorcode nvarchar(50)
		, @v_syserrorcode nvarchar(4000)
		, @v_errortext nvarchar(4000)
		, @v_date datetime
		--, @v_PSPID int
		, @v_STSID int
		, @v_SETTYPE NVARCHAR(30)
		, @v_STNID int
		, @v_KL5ID int
		, @v_OBJID int
		, @v_OBJ_STNID int
		--, @v_EXSTSID int
		--, @v_STS_CODE nvarchar(30)
		--, @v_OBJ_COUNT int
		, @c_OBJID int
		
	set @v_date = getdate()
	
	--select @v_PSPID = PSP_ROWID from PSP (nolock) where PSP_CODE = @p_PSP
	--select @v_STSID = STS_ROWID from STENCIL (nolock) where STS_CODE = @p_STS
	select @v_STNID = STN_ROWID, @v_KL5ID = STN_KL5ID from STATION (nolock) where STN_CODE = @p_STN and STN_TYPE = 'STACJA'
	select @v_OBJID = OBJ_ROWID from OBJ (nolock) where OBJ_CODE = @p_OBJ
	select @v_OBJ_STNID = OSA_STNID from [dbo].[OBJSTATION] (nolock) where OSA_OBJID = @v_OBJID
	
	if @p_OBJ is null
		select @v_STSID = STS_ROWID, @v_SETTYPE = STS_SETTYPE from STENCIL (nolock) where STS_CODE = @p_STS
	else
		select @v_SETTYPE = STS_SETTYPE, @v_STSID = OBJ_STSID, @v_OBJID = OBJ_ROWID from OBJ (nolock) join STENCIL (nolock) on STS_ROWID = OBJ_STSID where OBJ_CODE = @p_OBJ
		

	/*if (select ISNULL(OBJ_OTID,0) from OBJ (nolock) where OBJ_ROWID = @v_OBJID) <> 0 
	begin  
		select @v_errorcode = 'ITS_004'
		--select * From vs_langmsgs where objectid = 'ITS_004'
		goto errorlabel
	 end */-- wyłączono w ramach PKNTA-1922
	
	if @v_SETTYPE in ('KOM','ZES') and not exists (select * from STENCILLN (nolock) where STL_PARENTID = @v_STSID)
	begin
		select @v_errorcode = 'STS_006'--Błędna konfiguracja szablonu. Wybrany zestaw/komplet nie ma żadnego elementu.
		goto errorlabel --select * From vs_langmsgs where objectid = 'STS_006'
	end

	--wystawiony składnik (przynajmniej jeden)
	--select top 1 
	--	@v_OBJ_COUNT = COUNT(*),
	--	@v_EXSTSID = OBJ_STSID
	--from [INVTSK_NEW_OBJ] (nolock)
	--	join STENCIL (nolock) on STS_ROWID = INO_STSID
	--	join SETTYPE (nolock) on STT_CODE = STS_SETTYPE
	--	left join OBJ (nolock) on OBJ_INOID = INO_ROWID
	--where 
	--	INO_ROWID = @p_INOID --main = 1
	--	--and INO_STSID = @v_STSID
	--group by 
	--	OBJ_STSID
 
	--if exists (select 1 from ZWFOT (nolock) where OT_OBJID = @v_PSPID and OT_TYPE in ('SAPO_ZWFOT11','SAPO_ZWFOT12','SAPO_ZWFOT11'))
	--begin 
	--	select @v_errorcode = 'ITS_001'--Dla tego elementu PSP został już wygenerowany dokument księgowy.
	--	--select * From vs_langmsgs where objectid = 'ITS_001'
	--	goto errorlabel
	--end
	
	--if ISNULL(@v_OBJ_COUNT,0) > 0  and isnull(@v_EXSTSID,0) <> isnull(@v_STSID,0) and isnull(@v_OBJ_COUNT,0) >= @p_QTY
	--begin 
	--	select @v_errorcode = 'ITS_002'
	--	--select * From vs_langmsgs where objectid = 'ITS_001'
	--	goto errorlabel
	--end
	--else if ISNULL(@v_OBJ_COUNT,0) > 0 and isnull(@v_EXSTSID,0) = isnull(@v_STSID,0) and isnull(@v_OBJ_COUNT,0) >= @p_QTY
	--begin  
	--	select @v_errorcode = 'ITS_003'
	--	--select * From vs_langmsgs where objectid = 'ITS_003'
	--	goto errorlabel
	--end
	--else if ISNULL(@v_OBJ_COUNT,0) = 0
	--begin
	 
	--ustalenie stacji paliw (podawana w procedurze na wejściu)
	if @v_STNID is not null and @v_OBJID is not null and isnull(@v_OBJ_STNID,0) <> isnull(@v_STNID,0)
	begin
		---------------------------------------------------------------------------------
		------------------uzupełnienie OBJSTATION----------------------------------------
		---------------------------------------------------------------------------------
		declare c_OBJ_ALL cursor STATIC for
		select ZMT.OBJ_ROWID from dbo.OBJ ZMT  (nolock) where ZMT.OBJ_PARENTID = @v_OBJID
		
		open c_OBJ_ALL
		
		fetch next from c_OBJ_ALL
		into @c_OBJID
		
		while @@FETCH_STATUS = 0
		begin
			if not exists (select * from dbo.OBJSTATION (nolock) where OSA_OBJID = @c_OBJID) and @c_OBJID is not null
			begin
				insert into dbo.OBJSTATION (OSA_OBJID, OSA_STNID, OSA_KL5ID, OSA_CREDATE)
				select @c_OBJID, @v_STNID, @v_KL5ID, GETDATE()
			end
			else 
			begin
				
				delete from dbo.OBJSTATION where OSA_OBJID = @c_OBJID
				
				insert into dbo.OBJSTATION (OSA_OBJID, OSA_STNID, OSA_KL5ID, OSA_CREDATE)
				select @c_OBJID, @v_STNID, @v_KL5ID, GETDATE()
				
				--[dopóki nie ma dokuemntu księgowego, usuwamy wpis i nadajemy nowy KOD_ZMT (OBJ_CODE)]
				--update dbo.OBJSTATION
				--set OSA_STNID = @v_STNID
				--where OSA_OBJID = @c_OBJID
				 
			end
			
			fetch next from c_OBJ_ALL
			into @c_OBJID
			
		end
		
		close c_OBJ_ALL
		deallocate c_OBJ_ALL
			 
		update [dbo].[INVTSK_NEW_OBJ] set 
			INO_STNID = @v_STNID,
			INO_UPDUSER = @p_UserID,
			INO_UPDDATE = getdate()
		where INO_ROWID = @p_INOID
		
	end
	
	update [dbo].[OBJ] set OBJ_VALUE = @p_VALUE where OBJ_ROWID = @v_OBJID	
	
	return 

	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1

end
 
GO