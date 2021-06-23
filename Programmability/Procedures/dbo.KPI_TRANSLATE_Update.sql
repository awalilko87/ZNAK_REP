SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[KPI_TRANSLATE_Update](
@p_LangID nvarchar(10),
@p_ObjectID nvarchar(50),
@p_Caption nvarchar(80),
@p_UserID nvarchar(30)
)
as
begin
	declare @v_errortext nvarchar(100)
	
	begin try
		begin tran
		
		if not exists (select 1 from dbo.VS_LangMsgs(nolock) where LangID = @p_LangID and ControlID = ''
						and ObjectType = 'KPI' and ObjectID = @p_ObjectID)
		begin
			insert into dbo.VS_LangMsgs (LangID, ControlID, ObjectType, ObjectID, Caption)
			values (@p_LangID, '', 'KPI', @p_ObjectID, @p_Caption)
		end
		else
		begin
			update dbo.VS_LangMsgs set
				Caption = @p_Caption
			where LangID = @p_LangID and ControlID = '' 
				and ObjectType = 'KPI' and ObjectID = @p_ObjectID
		end
		commit tran
	end try
	begin catch
		rollback tran
		select @v_errortext = ERROR_MESSAGE()
		goto errorlabel
	end catch

return 0

errorlabel:
	raiserror(@v_errortext,16,1)
	return 1
end

GO