SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[STENCIL_PSP_ADD_Proc]
(
  @p_PSP_CODE nvarchar(30),
  @p_STS_ROWID int,
  @p_UserID nvarchar(30) = NULL,
  @p_apperrortext nvarchar(4000) = null output
)
as
begin
declare @v_errortext varchar(100)
declare @v_errorcode nvarchar(50)
declare @v_syserrorcode nvarchar(4000)

	if len(@p_PSP_CODE) <> 3
	begin
		select @v_syserrorcode = null
		select @v_errorcode = 'STS_10'
		goto errorlabel
	end
   
	if not exists (select * from dbo.STENCIL_PSP (nolock) where STS_ROWID = @p_STS_ROWID and PSP_CODE = @p_PSP_CODE)
	begin
		begin try
		insert into dbo.STENCIL_PSP
		(
			STS_ROWID,
			PSP_CODE
		)
		values
		(
			@p_STS_ROWID,
			@p_PSP_CODE
		)
		end try
		begin catch
			select @v_syserrorcode = null
			select @v_errorcode = 'STS_11'
			goto errorlabel
		end catch
	return 0
	end
    
	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1

end
GO