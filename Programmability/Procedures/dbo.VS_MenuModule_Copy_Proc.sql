SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[VS_MenuModule_Copy_Proc]        
(        
  @ModuleCode nvarchar(20),        
  @NewModuleCode nvarchar(20), 
  @NewModuleCaption nvarchar(20)
      
)
WITH ENCRYPTION          
as  
begin        
    INSERT INTO SYModules(
	  [ModuleCode],[ModuleDesc],[VerticalCaption],[INIFileName],[Orders],[LastUpdate],[UpdateInfo],[UpdateUser]
		)
	SELECT 
	  @NewModuleCode,@NewModuleCaption,[VerticalCaption],[INIFileName],[Orders],[LastUpdate],[UpdateInfo],[UpdateUser]
	FROM SYModules WHERE [ModuleCode]= @ModuleCode
	
	
	INSERT INTO SYMenus(
	  [ModuleName],[MenuKey],[GroupKey],[Orders],[IconKey],[ActionName],[MenuToolTip],[HTTPLink],[LastUpdate],[UpdateInfo],[MenuRightsOn],[UpdateUser],[MenuCaption],[MenuIcon],[IsGroup],[IsVisible],[DisableInsert],[DisableEdit],[DisableDelete],[ToolTip]
		)
	SELECT 
	  @NewModuleCode,[MenuKey],[GroupKey],[Orders],[IconKey],[ActionName],[MenuToolTip],[HTTPLink],[LastUpdate],[UpdateInfo],[MenuRightsOn],[UpdateUser],[MenuCaption],[MenuIcon],[IsGroup],[IsVisible],[DisableInsert],[DisableEdit],[DisableDelete],[ToolTip]
	FROM SYMenus WHERE ModuleName = @ModuleCode
	
end 


GO