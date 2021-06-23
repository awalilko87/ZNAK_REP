SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[DOC_ADDEXIST_Update_Multi](
@p_KEY nvarchar(max),
@p_Entity nvarchar(30),
@p_PK1 nvarchar(30),
@p_PK2 nvarchar(30),
@p_PK3 nvarchar(30),
@p_UserID nvarchar(30)
)
as
begin
	declare @v_errorcode nvarchar(50)
	declare @v_errortext nvarchar(4000)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_LP int
	
	declare @c_DOC_CODE nvarchar(30)
	
	if isnull(@p_KEY,'') = ''
	begin
		set @v_errorcode = 'SYS_010'
		goto errorlabel
	end
	
	declare C_DOC cursor for select String from dbo.VS_Split3(@p_KEY,';') where String <> ''
	open C_DOC
	fetch next from C_DOC into @c_DOC_CODE
	while @@fetch_status = 0
	begin
		begin try
			exec dbo.DOC_ADDEXIST_Update_Proc
				@c_DOC_CODE,
				@p_Entity,
				@p_PK1,
				@p_PK2,
				@p_PK3,
				0,
				0,
				@p_UserID,
				null
		end try
		begin catch
			deallocate C_DOC
			set @v_errorcode = ''
			select @v_syserrorcode = error_message()
			goto errorlabel
		end catch
		
		set @v_LP = isnull(@v_LP,0)+1
		
		fetch next from C_DOC into @c_DOC_CODE
	end
	deallocate C_DOC
	
	raiserror('Dodano %i załączników',1,1,@v_LP)
	
return 0

errorlabel:
	exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
	return 1
end
GO