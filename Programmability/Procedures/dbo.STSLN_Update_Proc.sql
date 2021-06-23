SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[STSLN_Update_Proc] 
(
  @p_FormID nvarchar(50),
  @p_PARENTID int,
  @p_CHILDID int,
  @p_REQUIRED nvarchar(3),
  @p_ONE nvarchar(3),
  @p_DEFAULT_NUMBER int,

  @p_UserID nvarchar(30) -- uzytkownik
)
as
begin
  declare @v_errorcode nvarchar(50)
  declare @v_syserrorcode nvarchar(4000)
  declare @v_errortext nvarchar(4000)

  if (@p_ONE = 'TAK' and @p_DEFAULT_NUMBER != 1)
  begin
	set @p_DEFAULT_NUMBER = 1
  end


  BEGIN TRY

    update dbo.STENCILLN
		set STL_REQUIRED = @p_REQUIRED, STL_ONE = @p_ONE, STL_DEFAULT_NUMBER = @p_DEFAULT_NUMBER
	where STL_PARENTID = @p_PARENTID
	and STL_CHILDID = @p_CHILDID
 
  END TRY
  BEGIN CATCH
    select @v_syserrorcode = error_message()
    select @v_errorcode = 'STS_003' -- blad kasowania
    goto errorlabel
  END CATCH;

  return 0
  errorlabel:
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
    return 1
end
GO