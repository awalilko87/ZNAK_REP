SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[SYS_PRVORG_Update_Proc](
@p_GROUP nvarchar(30),
@p_ORG nvarchar(30),
@p_DEFAULT int,
@p_UserID nvarchar(30)
)
as
begin

	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)

	if not exists (select * from dbo.PRVORG(nolock) where POR_GROUP = @p_GROUP and POR_ORG = @p_ORG)
	begin
		begin try
			if @p_DEFAULT = 1
			begin
				update dbo.PRVORG set
					POR_DEFAULT = 0
				where POR_GROUP = @p_GROUP
			end
			insert into dbo.PRVORG(POR_GROUP,POR_ORG,POR_DEFAULT)
			values(@p_GROUP,@p_ORG,@p_DEFAULT)
		end try
		begin catch
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'ERR_INS'
			goto errorlabel
		end catch
	end
	else
	begin
		begin try
			if @p_DEFAULT = 1
			begin
				update dbo.PRVORG set
					POR_DEFAULT = 0
				where POR_GROUP = @p_GROUP and POR_ORG <> @p_ORG

				update dbo.PRVORG set
					POR_DEFAULT = 1
				where POR_GROUP = @p_GROUP and POR_ORG = @p_ORG			
			end
		end try
		begin catch
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'ERR_UPD'
			goto errorlabel
		end catch
	end
return 0

errorlabel:
	exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
	return 1
end
GO