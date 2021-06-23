SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[MOV_Check_Update_Proc]
(
	@p_TYP int,
    @p_MOVID int,
	@p_OBGID int,
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
	 	
	if @p_OBGID is null
	begin 
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end		 
		
	if not exists (select 1 from dbo.MOVEMENTCHECK (nolock) where MOC_MOVID = @p_MOVID and MOC_OBGID = @p_OBGID)
	begin
		
		begin try
 
			insert into dbo.MOVEMENTCHECK
			(
				MOC_MOVID,
				MOC_OBGID,
				MOC_CHECKUSER,
				MOC_CHECKDATE,
				MOC_UPDUSER,
				MOC_UPDDATE
			)
			select
				@p_MOVID,
				@p_OBGID,
				@p_UserID,
				getdate(),
				@p_UserID,
				getdate()
						 
		end try
		begin catch
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'ERR_INS'
			goto errorlabel
		end catch
	end 
	--else 
	--begin 
	--	begin try
		
	--		update dbo.MOVEMENTCHECK

	--			MOC_CHECKUSER = @p_UserID
	--			MOC_CHECKDATE = getdate()
	--			MOC_UPDUSER = @p_UserID,
	--			MOC_UPDDATE = getdate()
	--		where MOC_MOVID = @p_MOVID and MOC_OBGID = @p_OBGID
			 
	--	end try
	--	begin catch
	--		select @v_syserrorcode = error_message()
	--		select @v_errorcode = 'ERR_UPD'
	--		goto errorlabel
	--	end catch
	--end 
	
	return 0
	
errorlabel:
	exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
	select @p_apperrortext = @v_errortext
	return 1
end

GO