SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[POT_Check_Update_Tran]
(
	@p_TYP int,
    @p_POTID int,
	@p_POC_GROUPID int,
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
    exec @v_errorid = [dbo].[POT_CHECK_Update_Proc]
    @p_TYP,
    @p_POTID,
	@p_POC_GROUPID,
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