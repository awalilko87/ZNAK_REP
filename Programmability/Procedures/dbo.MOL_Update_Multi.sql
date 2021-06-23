SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[MOL_Update_Multi](  
	@p_TYP int = NULL,   
	@p_STNID int = NULL,  
	@p_Key nvarchar(max) = NULL,  
	@p_UserID varchar(30),
    @p_apperrortext nvarchar(4000) = null output
)  
AS
BEGIN

	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)

	declare @cr_MOL_ID nvarchar(50);
		 	
    declare c_MOLID cursor for 
	select string from dbo.VS_Split2(@p_KEY,';')
		where   string != '' and string != '0'
	
    open c_MOLID
	
	fetch next from c_MOLID into @cr_MOL_ID
	
	while @@fetch_status = 0
	begin try 
	   
		if exists (select * from dbo.MOVEMENTLN (nolock) where MOL_ID = @cr_MOL_ID)
		begin
			update dbo.MOVEMENTLN set
				MOL_STATUS = 'MOL_002',
				MOL_TO_STNID = @p_STNID,
				MOL_UPDUSER = @p_UserID,
				MOL_UPDDATE = GETDATE()
			where MOL_ID = @cr_MOL_ID

			--select * from sta where sta_entity like 'OBJ_005' --Przenoszony
			update OBJ set OBJ_STATUS = 'OBJ_005' where OBJ_ROWID in (select MOL_OBJID from dbo.MOVEMENTLN (nolock) where MOL_ID = @cr_MOL_ID)

		end
		 
		fetch next from c_MOLID into @cr_MOL_ID
		
	end try
	begin catch
		close c_MOLID
		deallocate c_MOLID	
		set @v_errorcode = 'INVTSK_MULTI_001' -- blad dodawania instrukcji multi
		goto errorlabel
	end catch

	close c_MOLID
	deallocate c_MOLID

	RETURN 0
   	  
 	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1
END
GO