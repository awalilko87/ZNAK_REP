SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SYS_DATASPYGROUPRIGTSINHERIT_Tran](
	@GroupID nvarchar(20)     
)
WITH ENCRYPTION
AS
BEGIN
  declare @v_errorid int
  declare @v_errortext nvarchar(4000) 
  select @v_errorid = 0
  select @v_errortext = null

  begin transaction
    exec @v_errorid = [dbo].[SYS_DATASPYGROUPRIGTSINHERIT_Proc] 
							@GroupID

  if @v_errorid = 0
  BEGIN
    commit transaction
    return 0
  END
  else
  BEGIN
    rollback transaction
    return 1
  END
END

GO