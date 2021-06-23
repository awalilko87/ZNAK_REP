SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[SYMenus_GetVisibleGroupByModuleForUser_Tree](  
@parent nvarchar(50),  
@module nvarchar(50),  
@_App nvarchar(30), --WC APP
@_AppCode nvarchar(30), --WC APPCODE 
@_UserID nvarchar(30),
@_LangID nvarchar(3))
WITH ENCRYPTION  
as  
declare @isAdmin bit

declare @langs table( Caption nvarchar(4000),
					ObjectID nvarchar(150),
					ControlID nvarchar(50),
					UserID nvarchar(30))

--CREATE TABLE #LANGS(
--         Caption nvarchar(4000),
--		 ObjectID nvarchar(150),
--		 ControlID nvarchar(50),
--		 UserID nvarchar(30))
 
 INSERT INTO @langs (Caption,ObjectID,ControlID,UserID)
 SELECT 
	LM.Caption,
	LM.ObjectID,
	LM.ControlID,
	UserID = @_UserID
FROM VS_LangMsgs LM
WHERE LM.ObjectType = 'MENU' 
AND LM.[LangID] = @_LangID
AND isnull(LM.Caption,'') <> ''

if exists (select null 
           from SYSettings s 
             join SYUsers u ON u.UserGroupID = ltrim(rtrim(s.SettingValue))
           where s.ModuleCode = @_App
           and s.KeyCode = @_AppCode + '_ADMINID'
           and u.UserID = @_UserID)
  set @isAdmin = 1
if @isAdmin = 1 BEGIN  
  WITH    v (MenuKey, GroupKey, ModuleName, TreeLevel, Orders, IconKey, ActionName, MenuToolTip, HTTPLink, ToolTip, MenuRightsOn, MenuCaption, MenuIcon, IsGroup, IsVisible, DisableInsert, DisableEdit, DisableDelete) AS  
          (  
          SELECT  MenuKey, GroupKey, ModuleName, 1, Orders, IconKey, ActionName, MenuToolTip, HTTPLink, ToolTip, MenuRightsOn, MenuCaption, MenuIcon, IsGroup, IsVisible, DisableInsert, DisableEdit, DisableDelete  
          FROM    SYMenus  
          WHERE   GroupKey = @parent  
          AND ModuleName = @module  
          UNION ALL  
          SELECT  t.MenuKey, t.GroupKey, t.ModuleName, v.TreeLevel + 1, t.Orders, t.IconKey, t.ActionName, t.MenuToolTip, t.HTTPLink, t.ToolTip, t.MenuRightsOn, t.MenuCaption, t.MenuIcon, t.IsGroup, t.IsVisible, t.DisableInsert, t.DisableEdit, t.DisableDelete
          FROM    v  
          JOIN    SYMenus t  
          ON      t.GroupKey = v.MenuKey
          WHERE   t.ModuleName = @module  
          )  
  SELECT DISTINCT 
  v.MenuKey, 
  v.GroupKey, 
  v.ModuleName, 
  v.TreeLevel, 
  v.Orders, 
  v.IconKey, 
  v.ActionName, 
  v.MenuToolTip, 
  v.HTTPLink, 
  v.ToolTip, 
  v.MenuRightsOn, 
  case when coalesce(LM.Caption, v.MenuCaption, v.MenuKey) = '' then v.MenuKey
	   when coalesce(LM.Caption, v.MenuCaption, v.MenuKey) like '%[\/]%' then v.MenuKey
	   else coalesce(LM.Caption, v.MenuCaption, v.MenuKey) 
  end as MenuCaption, 
  v.MenuIcon, 
  v.IsGroup, 
  v.IsVisible, 
  v.DisableInsert, 
  v.DisableEdit, 
  v.DisableDelete,
  [Open] = null 
  FROM v 
    left join @langs LM ON LM.ObjectID = v.ModuleName AND LM.ControlID = v.MenuKey  AND LM.UserID = @_UserID  
  WHERE isnull(v.IsVisible,0) = 1  
  AND v.ModuleName = @module  
  ORDER BY v.TreeLevel, v.Orders, v.MenuKey 
END  
ELSE BEGIN  
  WITH    v1 (MenuKey, GroupKey, ModuleName, TreeLevel, Orders, IconKey, ActionName, MenuToolTip, HTTPLink, ToolTip, MenuRightsOn, MenuCaption, MenuIcon, IsGroup, IsVisible, DisableInsert, DisableEdit, DisableDelete) AS  
          (  
          SELECT  MenuKey, GroupKey, ModuleName, 1, Orders, IconKey, ActionName, MenuToolTip, HTTPLink, ToolTip, MenuRightsOn, MenuCaption, MenuIcon, IsGroup, IsVisible, DisableInsert, DisableEdit, DisableDelete  
          FROM    SYMenus  
          WHERE   GroupKey = @parent  
          AND ModuleName = @module  
          UNION ALL  
          SELECT  t.MenuKey, t.GroupKey, t.ModuleName, v1.TreeLevel + 1, t.Orders, t.IconKey, t.ActionName, t.MenuToolTip, t.HTTPLink, t.ToolTip, t.MenuRightsOn, t.MenuCaption, t.MenuIcon, t.IsGroup, t.IsVisible, t.DisableInsert, t.DisableEdit, t.DisableDelete
          FROM    v1  
          JOIN    SYMenus t  
          ON      t.GroupKey = v1.MenuKey  
          WHERE   t.ModuleName = @module  
          )  
  SELECT DISTINCT 
  v1.MenuKey, 
  v1.GroupKey, 
  v1.ModuleName, 
  v1.TreeLevel, 
  v1.Orders, 
  v1.IconKey, 
  v1.ActionName, 
  v1.MenuToolTip, 
  v1.HTTPLink, 
  v1.ToolTip, 
  v1.MenuRightsOn, 
   case when coalesce(LM.Caption, v1.MenuCaption, v1.MenuKey) = '' then v1.MenuKey
	   when coalesce(LM.Caption, v1.MenuCaption, v1.MenuKey) like '%[\/]%' then v1.MenuKey
	   else coalesce(LM.Caption, v1.MenuCaption, v1.MenuKey) 
  end as MenuCaption, 
  v1.MenuIcon, 
  v1.IsGroup, 
  v1.IsVisible, 
  coalesce(UM.DisableInsert, v1.DisableInsert) as DisableInsert, 
  coalesce(UM.DisableEdit, v1.DisableEdit) as DisableEdit,
  coalesce(UM.DisableDelete, v1.DisableDelete) as DisableDelete,
  UM.[Open] 
  FROM v1  
    JOIN SYUserMenu UM on UM.MenuKey = v1.MenuKey and UM.ModuleCode = v1.ModuleName 
    JOIN SYUsers U on U.UserGroupID = UM.UserID
    left join @langs LM ON LM.ObjectID = v1.ModuleName AND LM.ControlID = v1.MenuKey  AND LM.UserID = @_UserID  
  WHERE U.UserID = @_UserID  
  AND isnull(v1.IsVisible,0) = 1  
  AND v1.ModuleName = @module  
  ORDER BY v1.TreeLevel, v1.Orders, v1.MenuKey 
END 
GO