SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[SP_REQUEST_Update_Tran]    
(    
 @p_FORMID nvarchar(50),    
 @p_ID nvarchar(50),    
    @p_OBJID int,    
 @p_STNID int,     
 @p_TYPE nvarchar(30),    
 @p_REPLACEMENT nvarchar(100),    
 @p_STATUS nvarchar(20),    
 @p_REASON nvarchar(2000),  
 @p_NR_ZAW_PM int,    
    @p_UserID varchar(30),     
    @p_GroupID nvarchar(30),     
 @p_apperrortext nvarchar(4000) = null output    
)    
as    
begin    
  declare @v_errorid int    
  declare @v_errortext nvarchar(4000)     
  select @v_errorid = 0    
  select @v_errortext = null    
    
  begin transaction    
    exec @v_errorid = [dbo].[SP_REQUEST_Update_Proc]    
  @p_FORMID,    
  @p_ID,    
  @p_OBJID,    
  @p_STNID,     
  @p_TYPE,    
  @p_REPLACEMENT,    
  @p_STATUS,    
  @p_REASON,  
  @p_NR_ZAW_PM,    
  @p_UserID,     
  @p_GroupID,    
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