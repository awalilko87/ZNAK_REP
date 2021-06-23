SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYMenus_GetVisibleGroupByModuleForWEBUser](
	@UserID nvarchar(30) = null,
	@ModuleName varchar(50)
)
WITH ENCRYPTION
AS

if @UserID is null
begin
	SELECT
		ModuleName, MenuKey, MenuCaption, MenuIcon, MenuToolTip, IsGroup,
    IsVisible, MenuRightsOn, GroupKey, Orders, IconKey, DisableInsert,
    DisableEdit, DisableDelete, HTTPLink, ActionName, ToolTip,
    [Open] = null /*VMenu potrzebuje parametru Open*/
	FROM SYMenus 
	WHERE IsGroup =1 AND ModuleName = @ModuleName
	ORDER BY Orders
end
else
begin
	SELECT
		SYMenus.ModuleName, SYMenus.MenuKey, SYMenus.MenuCaption, SYMenus.MenuIcon, SYMenus.MenuToolTip, SYMenus.IsGroup,
    SYMenus.IsVisible, SYMenus.MenuRightsOn, SYMenus.GroupKey, SYMenus.Orders, SYMenus.IconKey, SYMenus.DisableInsert,
    SYMenus.DisableEdit, SYMenus.DisableDelete, SYMenus.HTTPLink, SYMenus.ActionName, SYMenus.ToolTip,
    SYUserMenu.[Open] /*VMenu potrzebuje parametru Open*/
	FROM SYMenus 
	  inner join SYUserMenu on SYUserMenu.MenuKey = SYMenus.MenuKey
	WHERE SYMenus.IsGroup =1 AND SYMenus.ModuleName = @ModuleName AND SYUserMenu.UserID = @UserID AND SYUserMenu.ModuleCode = @ModuleName
	ORDER BY SYMenus.Orders
end

GO