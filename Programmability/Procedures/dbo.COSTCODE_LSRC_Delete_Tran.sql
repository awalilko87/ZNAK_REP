SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create procedure [dbo].[COSTCODE_LSRC_Delete_Tran]
(
	@CCD_ROWID int = NULL,
	
	@p_UserID nvarchar(30) = NULL, -- uzytkownik
	@p_apperrortext nvarchar(4000) = null output
)
as
begin
  declare @v_errorid int
  declare @v_errortext nvarchar(4000) 
  select @v_errorid = 0
  select @v_errortext = null

  begin transaction
    exec @v_errorid = [dbo].[COSTCODE_LSRC_Delete_Proc] @CCD_ROWID, @p_UserID, @p_apperrortext output
  if @v_errorid = 0
  begin
    commit transaction
    return 0
  end
  else
  begin
    rollback transaction
    return 1
  end
end

GO