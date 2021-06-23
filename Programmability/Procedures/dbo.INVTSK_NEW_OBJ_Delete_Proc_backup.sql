SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[INVTSK_NEW_OBJ_Delete_Proc_backup] 
(
  @p_Key nvarchar(max) = NULL,

  @p_UserID nvarchar(30)
)
as
begin
  declare @v_errorcode nvarchar(50)
  declare @v_syserrorcode nvarchar(4000)
  declare @v_errortext nvarchar(4000)

  declare @v_obj_ino_id int;
  declare @ot_code nvarchar(512);
  declare @cr_ROWID nvarchar(30);

--print @p_Key

  declare c_instr cursor for 
	select string from dbo.VS_Split3(@p_KEY,';')
		where string != '' and string != '0'
		and ind%3 = 1
	
    open c_instr
	fetch next from c_instr into @cr_ROWID
	while @@fetch_status = 0
	BEGIN

	  select @v_obj_ino_id = OBJ_INOID from OBJ where OBJ_ROWID = @cr_ROWID

	  -- gdy jest już podpięty dokument nie usuwaj
	  select @ot_code = OT_CODE from [INVTSK_NEW_OBJv] where INO_ROWID  = @v_obj_ino_id

		declare @count int
		select @count = count(*) from OBJ
		where OBJ_PARENTID = @cr_ROWID
 
	  if @v_obj_ino_id is not null and @ot_code is null
	  BEGIN TRY

		if @count > 1
			delete from PROPERTYVALUES
			where PRV_ENT = 'OBJ'
			and PRV_PKID IN (select OBJ_ROWID from OBJ where OBJ_PARENTID = @cr_ROWID)
		else
			delete from PROPERTYVALUES
			where PRV_ENT = 'OBJ'
			and PRV_PKID = @cr_ROWID

		if @count > 1
			delete from OBJSTATION
			where OSA_OBJID IN (select OBJ_ROWID from OBJ where OBJ_PARENTID = @cr_ROWID)
		else
			delete from dbo.OBJSTATION
			where OSA_OBJID = @cr_ROWID
			
			delete from OBJ
			where OBJ_ROWID = @cr_ROWID
		if @count > 1
			delete from OBJ
			where OBJ_ROWID IN (select OBJ_ROWID from OBJ where OBJ_PARENTID = @cr_ROWID)


			delete from [INVTSK_NEW_OBJ]
			where INO_ROWID = @v_obj_ino_id
			and INO_ROWID not in (select OBJ_INOID from OBJ	where OBJ_INOID = @v_obj_ino_id)
		
	
		fetch next from c_instr into @cr_ROWID
	  END TRY

	  BEGIN CATCH
		select @v_syserrorcode = error_message()
		select @v_errorcode = 'INO_001' -- blad kasowania
		close c_instr
		deallocate c_instr
		goto errorlabel
	  END CATCH;

	 fetch next from c_instr into @cr_ROWID

	END
	close c_instr
	deallocate c_instr

	RETURN 0

  errorlabel:
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
    select @v_errortext
    return 1
end


GO