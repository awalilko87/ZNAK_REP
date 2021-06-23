SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[DOC_ADDEXIST_Update_Tran]
  @p_FileName nvarchar(300),
  
  @p_Entity nvarchar(4),
  @p_PK1 nvarchar(30),
  @p_PK2 nvarchar(30) = null,
  @p_PK3 nvarchar(30) = null,
  @p_copyToWo int = null,
  @p_copyToPo int = null,

  @p_UserID nvarchar(30), -- uzytkownik
  @p_apperrortext nvarchar(4000) = null output
as
begin
  declare @v_errorid int
  declare @v_errortext nvarchar(4000) 
  select @v_errorid = 0
  select @v_errortext = null

  begin transaction
    exec @v_errorid = DOC_ADDEXIST_Update_Proc @p_FileName, @p_Entity, @p_PK1, @p_PK2, @p_PK3, @p_copyToWo, @p_copyToPo, @p_UserID, @p_apperrortext output
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