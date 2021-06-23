SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SYS_STATUS_Update](
@p_ENTITY nvarchar(10),
@p_CODE nvarchar(30),
@p_CODE_old nvarchar(30),
@p_DESC nvarchar(80),
@p_CLASS nvarchar(30),
@p_TYPE nvarchar(30),
@p_ORG nvarchar(30),
@p_ORDER int,
@p_DEFAULT int,
@p_RFLAG int,
@p_D7CODE nvarchar(30),
@p_ICON nvarchar(255),
@p_NOTUSED int,
@p_UserID nvarchar(30)
)
as
begin
	declare @v_errortext nvarchar(1000)
	
	if @p_CODE_old is null
	begin
		begin try
			begin tran
			
			if exists (select 1 from dbo.STA(nolock) where STA_ENTITY = @p_ENTITY and STA_CODE = @p_CODE)
			begin
				raiserror('Podany kod już istnieje',16,1)
			end
			
			insert into dbo.STA(STA_ENTITY, STA_CODE, STA_DESC, STA_CLASS, STA_TYPE, STA_ORG, STA_ORDER,
								STA_DEFAULT, STA_RFLAG, STA_D7CODE, STA_ICON, STA_NOTUSED)
			values (@p_ENTITY, @p_CODE, @p_DESC, @p_CLASS, @p_TYPE, @p_ORG, @p_ORDER,
					@p_DEFAULT, @p_RFLAG, @p_D7CODE, @p_ICON, @p_NOTUSED)
					
			commit tran
		end try
		begin catch
			rollback tran
			select @v_errortext = ERROR_MESSAGE()
			goto errorlabel
		end catch
	end
	else
	begin
		begin try
			begin tran
			
			update dbo.STA set
				 STA_DESC = @p_DESC
				,STA_CLASS = @p_CLASS
				,STA_TYPE = @p_TYPE
				,STA_ORG = @p_ORG
				,STA_ORDER = @p_ORDER
				,STA_DEFAULT = @p_DEFAULT
				,STA_RFLAG = @p_RFLAG
				,STA_D7CODE = @p_D7CODE
				,STA_ICON = @p_ICON
				,STA_NOTUSED = @p_NOTUSED
			where STA_ENTITY = @p_ENTITY and STA_CODE = @p_CODE

			commit tran
		end try
		begin catch
			rollback tran
			select @v_errortext = ERROR_MESSAGE()
			goto errorlabel
		end catch
	end
	
return 0

errorlabel:
	raiserror(@v_errortext,16,1)
	return 1
end
GO