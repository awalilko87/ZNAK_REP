SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
 
CREATE procedure [dbo].[OTL_OBJ_ADD_NEW_DELETE_Proc](
	@p_PAR nvarchar(max),
	@p_OTID int,
	@p_UserID nvarchar(30)
)
as
begin
	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @c_OBJID int
	declare @v_OT_TYPE nvarchar(50)
	declare @v_OT_VALUE decimal(30,6)
	declare @v_OBJ_CODE nvarchar(30)
	declare @v_OT12LNID int
	declare @v_OT21LNID int
	 
	select @v_OT_TYPE = OT_TYPE from ZWFOT (nolock) where OT_ROWID = @p_OTID
	
	declare c_OBJ cursor for select String from dbo.VS_Split2(@p_PAR,';') where String <> ''
	open c_OBJ
	fetch next from c_OBJ into @c_OBJID
	while @@FETCH_STATUS = 0
	begin
		begin try
		  
			select @v_OBJ_CODE = OBJ_CODE from dbo.OBJ where OBJ_ROWID = @c_OBJID 
			update OBJ set OBJ_OTID = NULL where OBJ_ROWID = @c_OBJID 
 			
			if @v_OT_TYPE = 'SAPO_ZWFOT11'
			begin

				select @v_OT_VALUE = SUM(isnull(OBJ_VALUE,0)) from OBJ (nolock) where isnull(OBJ_OTID,0) = isnull(@p_OTID,0)
				update SAPO_ZWFOT11 set OT11_WART_NAB_PLN = @v_OT_VALUE where OT11_ZMT_ROWID = @p_OTID
				 
			end
				
			if @v_OT_TYPE = 'SAPO_ZWFOT12'
			begin
			
				select @v_OT12LNID = OT12LN_ROWID from ZWFOT12LNv where OT12LN_ZMT_OBJ_CODE = @v_OBJ_CODE
				
				if @v_OT12LNID is not null
				begin
					exec [dbo].[ZWFOT12LN_Delete_Proc] 
						@p_FormID  = 'OT12_LN' ,
						@p_ROWID = @v_OT12LNID,
						@p_UserID  = @p_UserID;
				end

				--Przy usuwaniu ostatniej pozycji dokumentu, czyści OT_INOID
				if (select count(*) from ZWFOT12LNv where OTL_OTID = @p_OTID) = 0 
				begin
					update ZWFOT set OT_INOID = NULL where OT_ROWID = @p_OTID
				end

			end
			
	
			if @v_OT_TYPE = 'SAPO_ZWFOT21'
			begin

				select @v_OT21LNID = OT21LN_ROWID from ZWFOT21LNv where OT21LN_ZMT_OBJ_CODE = @v_OBJ_CODE
				
				if @v_OT21LNID is not null
				begin
					exec [dbo].[ZWFOT21LN_Delete_Proc] 
						@p_FormID  = 'OT21_LN' ,
						@p_ROWID = @v_OT21LNID,
						@p_UserID  = @p_UserID;
				end
				
				--Przy usuwaniu ostatniej pozycji dokumentu, czyści OT_INOID
				if (select count(*) from ZWFOT21LNv where OTL_OTID = @p_OTID) = 0 
				begin
					update ZWFOT set OT_INOID = NULL where OT_ROWID = @p_OTID
				end

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