SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[OTL_OBJ_ADD_NEW_Proc](
	@p_PAR nvarchar(max),
	@p_OTID int,
	@p_UserID nvarchar(30)
)
as
begin
	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @v_OT_TYPE nvarchar(50)
	declare @v_OT_VALUE decimal(30,6)
	
	--zmienne obiektu
	declare @c_OBJID int
		, @v_INOID int
		, @v_OBJ_DESC nvarchar(80)
		, @v_OBJ_VALUE decimal(30,6)
	
	--zmienne dla OT12
	declare @v_OT12_ID nvarchar(50)
		, @v_OT12ID int
		, @v_OT12_ORG  nvarchar(30)
		, @v_OT12_STATUS nvarchar(30)
	
	--zmienne dla OT21
	declare @v_OT21_ID nvarchar(50)
		, @v_OT21ID int
		, @v_OT21_ORG  nvarchar(30)
		, @v_OT21_STATUS nvarchar(30)
		
	select @v_OT_TYPE = OT_TYPE from ZWFOT (nolock) where OT_ROWID = @p_OTID
	
	declare c_OBJ cursor for select String from dbo.VS_Split2(@p_PAR,';') where String <> ''
	open c_OBJ
	fetch next from c_OBJ into @c_OBJID
	while @@FETCH_STATUS = 0
	begin
		begin try
			 
			if @v_OT_TYPE = 'SAPO_ZWFOT11'
			begin
			
				update OBJ set OBJ_OTID = @p_OTID, @v_INOID = OBJ_INOID where OBJ_ROWID = @c_OBJID 
		 		select @v_OT_VALUE = SUM(isnull(OBJ_VALUE,0)) from OBJ (nolock) where isnull(OBJ_OTID,0) = isnull(@p_OTID,0)

				update SAPO_ZWFOT11 set OT11_WART_NAB_PLN = @v_OT_VALUE where OT11_ZMT_ROWID = @p_OTID
				update ZWFOT set OT_INOID = @v_INOID where OT_ROWID = @p_OTID

			end
				
			if @v_OT_TYPE = 'SAPO_ZWFOT12'
			begin
				
				select @v_OT12_ID = NEWID()
				select @v_OT12_ORG = dbo.GetOrgDef('OT12_LN',@p_UseriD)
				select @v_OT12_STATUS = dbo.[GetStatusDef]('OT12_LN',NULL,@p_UseriD)
				select @v_OT12ID = OT12_ROWID from ZWFOT12v (nolock) where OT12_ZMT_ROWID = @p_OTID
				select @v_OBJ_DESC = OBJ_DESC, @v_OBJ_VALUE = isnull(OBJ_VALUE,0), @v_INOID = OBJ_INOID  from OBJ (nolock) where OBJ_ROWID = @c_OBJID
				 
				exec [dbo].[ZWFOT12LN_Update_Proc] 
					@p_FormID  = 'OT12_LN',
					@p_ROWID = NULL,
					@p_OT12ID = @v_OT12ID,
					@p_OBJID = @c_OBJID,
					@p_CODE = '',
					@p_ID = @v_OT12_ID,
					@p_ORG = 'PKN',
					@p_RSTATUS = 0,
					@p_STATUS = @v_OT12_STATUS,
					@p_STATUS_old = NULL,
					@p_TYPE = NULL,
					@p_CHAR_SKLAD = NULL,
					@p_ANLN1_POSKI = NULL,
					@p_ANLN2 = NULL,
					@p_WART_ELEME = @v_OBJ_VALUE,
					@p_INVNR_NAZWA = @v_OBJ_DESC,
					@p_UserID  = @p_UserID;
 
				update OBJ set OBJ_OTID = @p_OTID where OBJ_ROWID = @c_OBJID
				
				-- dodatkowe łączenie lini dokumentu
				declare @v_OTLID int
				select @v_OTLID = IDENT_CURRENT('ZWFOTLN')
				update OBJ set OBJ_OTLID = @v_OTLID where OBJ_ROWID = @c_OBJID
				
				if (select OT_INOID from ZWFOT (nolock) where OT_ROWID = @p_OTID) is null
					update ZWFOT set OT_INOID = @v_INOID where OT_ROWID = @p_OTID
				
			end
			
			if @v_OT_TYPE = 'SAPO_ZWFOT21'
			begin
			
				select @v_OT21_ID = NEWID()
				select @v_OT21_ORG = dbo.GetOrgDef('OT21_LN',@p_UseriD)
				select @v_OT21_STATUS = dbo.[GetStatusDef]('OT21_LN',NULL,@p_UseriD)
				select @v_OT21ID = OT21_ROWID from ZWFOT21v (nolock) where OT21_ZMT_ROWID = @p_OTID
				select @v_OBJ_DESC = OBJ_DESC, @v_OBJ_VALUE = isnull(OBJ_VALUE,0), @v_INOID = OBJ_INOID from OBJ (nolock) where OBJ_ROWID = @c_OBJID
				 
				exec [dbo].[ZWFOT21LN_Update_Proc] 
					@p_FormID  = 'OT21_LN',
					@p_ROWID = NULL,
					@p_OT21ID = @v_OT21ID,
					@p_OBJID = @c_OBJID,
					@p_CODE = '',
					@p_ID = @v_OT21_ID,
					@p_ORG = 'PKN',
					@p_RSTATUS = 0,
					@p_STATUS = @v_OT21_STATUS,
					@p_STATUS_old = NULL,
					@p_TYPE = NULL,
					@p_ANLN1_POSKI = NULL,
					@p_ANLN2 = NULL,
					@p_WART_NAB_PLN = @v_OBJ_VALUE,
					@p_DOSTAWCA = NULL,
					@p_NR_DOW_DOSTAWY = NULL,
					@p_DT_DOSTAWY = NULL,
					@p_GRUPA = NULL,
					@p_ILOSC = 1,
					@p_NZWYP = @v_OBJ_DESC,
					@p_MUZYTK = NULL,
					@p_UserID  = @p_UserID;
					
				update OBJ set OBJ_OTID = @p_OTID where OBJ_ROWID = @c_OBJID 
				
				
				if (select OT_INOID from ZWFOT (nolock) where OT_ROWID = @p_OTID) is null
					update ZWFOT set OT_INOID = @v_INOID where OT_ROWID = @p_OTID

			end
			
		end try
		begin catch
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'REQ_004'
			goto errorlabel2
		end catch
 
		fetch next from c_OBJ into @c_OBJID
	end
	
	close c_OBJ
	deallocate c_OBJ

	return 0

	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		return 1

	errorlabel2:
		close c_OBJ
		deallocate c_OBJ
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		return 1
end
GO