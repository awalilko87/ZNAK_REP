SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[INVTSK_NEW_OBJ_NEW_Update_Tran]
(
	@p_ROWID int,
	@p_PSP nvarchar(30),
	@p_STS nvarchar(30),
	@p_STNID int,
	@p_QTY int,

	@p_UserID nvarchar(30) = NULL, -- uzytkownik
	@p_apperrortext nvarchar(4000) = null output,
	@p_INOID INT = NULL output -- GK [20200618]
)
as
begin
  declare @v_errorid int
  declare @v_errortext nvarchar(4000) 
  select @v_errorid = 0
  select @v_errortext = null
   
  begin transaction
    exec @v_errorid = [dbo].[INVTSK_NEW_OBJ_NEW_Update_Proc] @p_ROWID, @p_PSP, @p_STS, @p_STNID, @p_QTY, @p_UserID, @p_apperrortext output, @p_INOID OUTPUT /* GK [20200618] */
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