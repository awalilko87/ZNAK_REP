SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INWASTLN_OBJ_Update_Tran]
(
    @p_ASTID int,
    @p_OBJID int,
    @p_TYPE int,
    @p_TYPE2 int,
    @p_UserID varchar(20), 
    @p_GroupID varchar(10), 
    @p_LangID varchar(10),
	@p_apperrortext nvarchar(4000) = null output
)
as
begin
  declare @v_errorid int
  declare @v_errortext nvarchar(4000) 
  select @v_errorid = 0
  select @v_errortext = null

  begin transaction
    exec @v_errorid = [dbo].[INWASTLN_OBJ_Update_Proc]
    @p_ASTID,
    @p_OBJID,
    @p_TYPE,
    @p_TYPE2,
    @p_UserID,
    @p_GroupID,
    @p_LangID,
    @p_apperrortext output
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