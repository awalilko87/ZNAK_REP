SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[DOCTOGET_Update](
@p_ROWID int output,
@p_CODE nvarchar(30),
@p_STATION nvarchar(30),
@p_TAB nvarchar(50),
@p_TOGET tinyint,
@p_UserID nvarchar(30)
)
as
begin
	declare @v_errortext nvarchar(1000)
	
	begin try
		begin tran
		
		if exists (select 1 from dbo.IE2_DocToGet where TYPE = @p_TAB and CODE = @p_CODE and TOGET = 1)
		begin
			raiserror('Podany kod jest już dodany.', 16, 1)
		end
		
		if @p_ROWID is null
		begin
			insert into dbo.IE2_DocToGet(TYPE, CODE, TOGET, STATION, CREDATE)
			values (@p_TAB, @p_CODE, @p_TOGET, @p_STATION, getdate())
			
			set @p_ROWID = scope_identity()
		end
		
		commit tran
	end try
	begin catch
		rollback tran
		set @v_errortext = error_message()
		goto errorlabel
	end catch
	
	return 0
	
errorlabel:
	raiserror(@v_errortext, 16, 1)
	return 1
end
GO