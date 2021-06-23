SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[SYSUSERS_PKN_Delete](
@p_UserID nvarchar(30)
)
as
begin
	declare @v_errortext nvarchar(1000)

	if exists (select 1 from dbo.ZWFOT where OT_CREUSER = @p_UserID or OT_UPDUSER = @p_UserID)
		or exists (select 1 from dbo.OBJTECHPROT where POT_CREUSER = @p_UserID or POT_UPDUSER = @p_UserID)
		or exists (select 1 from dbo.SP_REQUEST where SRQ_CREUSER = @p_UserID or SRQ_UPDUSER = @p_UserID)
		or exists (select 1 from dbo.OBJTECHPROTCHECK_GU where POC_CHECKUSER = @p_UserID or POC_UPDUSER = @p_UserID)
	begin
		set @v_errortext = 'Nie można usunąć użytkownika.'
		goto errorlabel
	end

	begin try
		begin tran

		delete from SYUsers where UserID = @p_UserID

		commit tran
	end try
	begin catch
		rollback tran
		set @v_errortext = 'Błąd usuwania użytkownika: '+error_message()
		goto errorlabel
	end catch

	return 0

errorlabel:
	raiserror(@v_errortext, 16, 1)
	return 1
end
GO