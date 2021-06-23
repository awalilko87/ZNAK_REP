SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SYS_DATASPYGROUPRIGHTS_Update_Tran](
	@GroupID nvarchar(20),
    @DS_PRIV bit = NULL,   
    @DS_PUB bit = NULL,
    @DS_GR bit = NULL,
    @DS_SITE bit = NULL,  
    @DS_DEP bit = NULL     
)
WITH ENCRYPTION
AS
BEGIN
  declare @v_errorid int
  declare @v_errortext nvarchar(4000) 
  select @v_errorid = 0
  select @v_errortext = null

  begin transaction
    exec @v_errorid = [dbo].[SYS_DATASPYGROUPRIGHTS_Update_Proc] 
							@GroupID,
							@DS_PRIV,
							@DS_PUB,
							@DS_GR,
							@DS_SITE,
							@DS_DEP

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