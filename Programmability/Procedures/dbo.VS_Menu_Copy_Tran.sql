SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE procedure [dbo].[VS_Menu_Copy_Tran]        
(        
  @ModuleName nvarchar(50),        
  @MenuKey nvarchar(50), 
  @GroupKey nvarchar(50),
  @NewModuleName nvarchar(50),        
  @NewMenuKey nvarchar(50),        
  @NewMenuCaption nvarchar(50), 
  @NewGroupKey nvarchar(50)    
)
WITH ENCRYPTION          
as      
begin        
  declare @v_errorid int 
      
  begin transaction       
    exec @v_errorid = [dbo].[VS_Menu_Copy_Proc]      
     @ModuleName ,        
  @MenuKey , 
  @GroupKey ,
  @NewModuleName ,        
  @NewMenuKey , 
  @NewMenuCaption,
  @NewGroupKey       
             
   
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