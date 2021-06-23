SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create procedure [dbo].[OBG_Delete_Proc] 
(
  @p_FormID nvarchar(50),
  @p_ID nvarchar(50),

  @p_UserID nvarchar(30), -- uzytkownik
  @p_apperrortext nvarchar(4000) output
)
as
begin
  declare @v_errorcode nvarchar(50)
  declare @v_syserrorcode nvarchar(4000)
  declare @v_errortext nvarchar(4000)
  declare @v_date datetime
 
 --delete
  BEGIN TRY
    delete from dbo.OBJGROUP where OBG_ID = @p_ID
	
  END TRY
  BEGIN CATCH
    select @v_syserrorcode = error_message()
    select @v_errorcode = 'OBG_003' -- blad kasowania
    goto errorlabel
  END CATCH;

  return 0
  errorlabel:
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
    select @p_apperrortext = @v_errortext
    return 1
end
GO