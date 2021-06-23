SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[INWASTLN_OBJ_Update_Multi](
@p_KEY nvarchar(max),
@p_CCDID int,
@p_KL5ID int,
@p_UserID nvarchar(30),
@p_GroupID nvarchar(30),
@p_LangID nvarchar(30)
)
as
begin
	declare @v_errortext nvarchar(1000)
	
	declare @c_ASTID int
	declare @c_OBJID int
	
	begin try
		declare C_AST cursor for select SIA_ASTID, SIA_OBJID 
								from dbo.INWASTLN_ASTOBJ_LS_Get(@p_CCDID, @p_KL5ID, @p_UserID) 
								where SIA_ASTID in (select String from dbo.VS_Split3(@p_KEY, ';') where String <> '')
		open C_AST
		fetch next from C_AST into @c_ASTID, @c_OBJID
		while @@fetch_status = 0
		begin
			exec dbo.INWASTLN_OBJ_Update_Proc
				@p_ASTID = @c_ASTID,
				@p_OBJID = @c_OBJID,
				@p_TYPE = 0,
				@p_TYPE2 = 0,
				@p_UserID = @p_UserID,
				@p_GroupID = @p_GroupID,
				@p_LangID = @p_LangID

			fetch next from C_AST into @c_ASTID, @c_OBJID
		end
		deallocate C_AST
	end try
	begin catch
		deallocate C_AST
		set @v_errortext = error_message()
		goto errorlabel
	end catch
	
	return 0
	
errorlabel:
	raiserror(@v_errortext, 16, 1)
	return 1
end
GO