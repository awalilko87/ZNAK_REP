SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[POT_Delete_Proc]
(
	@p_FormID nvarchar(50),
	@p_ID nvarchar(50),
	@p_ROWID int,
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
	declare @v_STNID int
	
	if exists (select * from [dbo].[OBJTECHPROTLN] (nolock) where POL_POTID = @p_ROWID and coalesce(POL_OT33ID, POL_OT31ID, POL_OT42ID, POL_OT41ID, POL_OT32ID) is not null)
	begin 
		select @v_errorcode = 'POT_003'
		goto errorlabel
	end		

	if exists (select * from [dbo].[OBJTECHPROT] (nolock) where POT_ID = @p_ID)
	begin
		 
		begin try
			
			delete from [dbo].[OBJTECHPROTLN] where POL_POTID = @p_ROWID
			delete from [dbo].[OBJTECHPROTCHECK] where POC_POTID = @p_ROWID
			delete from [dbo].[OBJTECHPROT] where POT_ID = @p_ID

		end try
		begin catch
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'ERR_INS'
			goto errorlabel
		end catch
	end 
	 ------------------------------------------------------------------
		
  return 0
  
  errorlabel:
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
    select @p_apperrortext = @v_errortext
    return 1
END
GO