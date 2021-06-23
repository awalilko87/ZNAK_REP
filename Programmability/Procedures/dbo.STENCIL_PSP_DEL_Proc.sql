SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
creaTE procedure [dbo].[STENCIL_PSP_DEL_Proc]
(
  @p_Key nvarchar(max) = NULL,
  @p_STS_ROWID int,
  @p_UserID nvarchar(30) = NULL,
  @p_apperrortext nvarchar(4000) = null output
)
as
begin
declare @v_errortext varchar(100)
declare @v_errorcode nvarchar(50)
declare @v_syserrorcode nvarchar(4000)

declare @cr_PSP_CODE nvarchar(30);

	declare c_instr cursor for 
	select string from dbo.VS_Split2(@p_KEY,';')
		where string != '' and string != '0'
	
    open c_instr
	fetch next from c_instr into @cr_PSP_CODE
	while @@fetch_status = 0
	
	begin try 
		delete from dbo.STENCIL_PSP where STS_ROWID = @p_STS_ROWID and PSP_CODE = @cr_PSP_CODE

	fetch next from c_instr into @cr_PSP_CODE
	end try

	begin catch
		close c_instr
		deallocate c_instr	
		set @v_errorcode = NULL
		goto errorlabel
	end catch

	close c_instr
	deallocate c_instr

	RETURN 0

	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1

end
GO