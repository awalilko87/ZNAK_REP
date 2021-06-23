SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SYS_DATASPYUSERRIGHTS_Update_Tran](
	@USERID nvarchar(20),
    @DS_PRIV bit = NULL,   
    @DS_PUB bit = NULL,
    @DS_GR bit = NULL,
    @DS_SITE bit = NULL,  
    @DS_DEP bit = NULL
     
)
WITH ENCRYPTION
as
begin
  declare @v_errorid int
  declare @v_errortext nvarchar(4000) 
  select @v_errorid = 0
  select @v_errortext = null

  begin transaction
    exec @v_errorid = [dbo].[SYS_DATASPYUSERRIGHTS_Update_Proc] 
							@USERID,
							@DS_PRIV,
							@DS_PUB,
							@DS_GR,
							@DS_SITE,
							@DS_DEP

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