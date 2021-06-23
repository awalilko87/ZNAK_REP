SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

       
CREATE procedure [dbo].[VS_MenuModule_Copy_Tran]        
(        
  @ModuleCode nvarchar(20),        
  @NewModuleCode nvarchar(20), 
  @NewModuleCaption nvarchar(20)
      
)
WITH ENCRYPTION           
as     
begin        
  declare @v_errorid int 
      
  begin transaction       
    exec @v_errorid = [dbo].[VS_MenuModule_Copy_Proc]      
     @ModuleCode,        
     @NewModuleCode, 
     @NewModuleCaption
             
   
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