SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

--exec [VS_Menu_Copy_Proc] 'VISION','VISION_ADMIN','VISION_ADMIN',
--'ZMT','ZMT_aaaa','Administracja(1)',''

CREATE procedure [dbo].[VS_Menu_Copy_Proc]        
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
	INSERT INTO SYMenus(
	  [ModuleName],[MenuKey],[GroupKey],[Orders],[IconKey],[ActionName],[MenuToolTip],[HTTPLink],[LastUpdate],[UpdateInfo],[MenuRightsOn],[UpdateUser],[MenuCaption],[MenuIcon],[IsGroup],[IsVisible],[DisableInsert],[DisableEdit],[DisableDelete],[ToolTip]
		)
	SELECT 
	  case when isNull(@NewModuleName,'') = '' then [ModuleName] else @NewModuleName end,
	  case when isNull(@NewMenuKey,'') = '' then [MenuKey] else @NewMenuKey end,
	  case when isNull(@NewGroupKey,'') = '' then [GroupKey] else @NewGroupKey end, 
	  [Orders],[IconKey],[ActionName],[MenuToolTip],[HTTPLink],[LastUpdate],[UpdateInfo],[MenuRightsOn],[UpdateUser],
	  @NewMenuCaption,[MenuIcon],
	  case when isNull(@NewGroupKey,'') = '' then 1 else 0 end,
	  [IsVisible],[DisableInsert],[DisableEdit],[DisableDelete],[ToolTip]
	FROM SYMenus 
	WHERE ModuleName = @ModuleName AND MenuKey = @MenuKey AND GroupKey =  @GroupKey
	
	--dzieci
	INSERT INTO SYMenus(
	  [ModuleName],[MenuKey],[GroupKey],[Orders],[IconKey],[ActionName],[MenuToolTip],[HTTPLink],[LastUpdate],[UpdateInfo],[MenuRightsOn],[UpdateUser],[MenuCaption],[MenuIcon],[IsGroup],[IsVisible],[DisableInsert],[DisableEdit],[DisableDelete],[ToolTip]
		)
	SELECT 
	  case when isNull(@NewModuleName,'') = '' then [ModuleName] else @NewModuleName end,
	  Replace([MenuKey],@MenuKey, @NewMenuKey) ,
	  @NewMenuKey, 
	  [Orders],[IconKey],[ActionName],[MenuToolTip],[HTTPLink],[LastUpdate],[UpdateInfo],[MenuRightsOn],[UpdateUser],[MenuCaption],[MenuIcon],
	  [IsGroup],
	  [IsVisible],[DisableInsert],[DisableEdit],[DisableDelete],[ToolTip]
	FROM SYMenus 
	WHERE ModuleName = @ModuleName AND GroupKey =  @MenuKey
	
end 


GO