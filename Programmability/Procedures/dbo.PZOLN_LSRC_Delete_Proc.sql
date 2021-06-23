SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[PZOLN_LSRC_Delete_Proc](
@p_FormID nvarchar(50),
@p_ROWID int,
@p_KEY nvarchar(max),
@p_UserID nvarchar(30)
)
as
begin
	declare @v_errortext nvarchar(1000)

	if isnull(@p_KEY,'') = ''
	begin
		set @v_errortext = 'Nie wybrano żadnego rekordu'
		goto errorlabel
	end

	if exists (select 1 from dbo.OBJTECHPROTLN where POL_ROWID in (select String from dbo.VS_Split3(@p_KEY, ';') where String <> '') and POL_RSTATUS = 1)
	begin
		set @v_errortext = 'Nie można usunąć potwierdzonego wcześniej składnika.'
		goto errorlabel
	end

	begin try
		delete from dbo.OBJTECHPROTLN where POL_ROWID in (select String from dbo.VS_Split3(@p_KEY, ';') where String <> '')
	end try
	begin catch
		set @v_errortext = error_message()
		goto errorlabel
	end catch

	return 0

errorlabel:
	raiserror(@v_errortext, 16, 1)
	return 1
end
GO