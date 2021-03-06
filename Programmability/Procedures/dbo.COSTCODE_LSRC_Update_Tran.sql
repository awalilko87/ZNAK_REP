SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create procedure [dbo].[COSTCODE_LSRC_Update_Tran]
(
	@CCD_CODE nvarchar(30) = NULL OUT,
	@OLD_CCD_CODE nvarchar(30) = NULL OUT,
	@CCD_DESC nvarchar(80) = NULL,
	@OLD_CCD_DESC nvarchar(80) = NULL,
	@CCD_NOTUSED int = NULL,
	@OLD_CCD_NOTUSED int = NULL,
	@CCD_ORG nvarchar(30) = NULL OUT,
	@OLD_CCD_ORG nvarchar(30) = NULL OUT,
	@CCD_ROWID int = NULL,
	@OLD_CCD_ROWID int = NULL, 

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
    exec @v_errorid = [dbo].[COSTCODE_LSRC_Update_Proc] @CCD_CODE, @OLD_CCD_CODE, @CCD_DESC, @OLD_CCD_DESC, @CCD_NOTUSED, @OLD_CCD_NOTUSED, @CCD_ORG, @OLD_CCD_ORG, @CCD_ROWID, @OLD_CCD_ROWID, @p_UserID, @p_apperrortext output
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