SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[STS_PROPERTIES_Delete_Proc]
(
	@p_Key nvarchar(max) = NULL,
	@p_STSID int, 
	@p_UserID nvarchar(30) = NULL, -- uzytkownik
	@p_apperrortext nvarchar(4000) = null output
)
as 
begin
	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
  
	declare @cr_ROWID nvarchar(30);

	declare c_instr cursor for 
	select string from dbo.VS_Split2(@p_KEY,';')
		where string != '' and string != '0'
	
    open c_instr
	fetch next from c_instr into @cr_ROWID
	while @@fetch_status = 0
	
	begin try
		delete from ADDSTSPROPERTIES where ASP_ROWID = @cr_ROWID and ASP_STSID = @p_STSID

	fetch next from c_instr into @cr_ROWID
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