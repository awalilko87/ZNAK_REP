SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create procedure [dbo].[SYS_PRVORG_Update_Tran](
@p_GROUP nvarchar(30),
@p_ORG nvarchar(30),
@p_DEFAULT int,
@p_UserID nvarchar(30)
)
as
begin
  declare @v_errorid int
  declare @v_errortext nvarchar(4000) 
  select @v_errorid = 0
  select @v_errortext = null

  begin transaction
    exec @v_errorid = [dbo].[SYS_PRVORG_Update_Proc] 
		@p_GROUP,
		@p_ORG,
		@p_DEFAULT,
		@p_UserID

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