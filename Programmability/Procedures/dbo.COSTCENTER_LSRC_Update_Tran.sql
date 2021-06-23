SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[COSTCENTER_LSRC_Update_Tran]
(
	@CCT_CODE nvarchar(30) = NULL OUT,
	@OLD_CCT_CODE nvarchar(30) = NULL OUT,
	@CCT_DESC nvarchar(80) = NULL,
	@OLD_CCT_DESC nvarchar(80) = NULL,
	@CCT_NOTUSED int = NULL,
	@OLD_CCT_NOTUSED int = NULL,
	@CCT_ORG nvarchar(30) = NULL OUT,
	@OLD_CCT_ORG nvarchar(30) = NULL OUT,
	@CCT_ROWID int = NULL,
	@OLD_CCT_ROWID int = NULL, 

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
    exec @v_errorid = [dbo].[COSTCENTER_LSRC_Update_Proc] @CCT_CODE, @OLD_CCT_CODE, @CCT_DESC, @OLD_CCT_DESC, @CCT_NOTUSED, @OLD_CCT_NOTUSED, @CCT_ORG, @OLD_CCT_ORG, @CCT_ROWID, @OLD_CCT_ROWID, @p_UserID, @p_apperrortext output
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