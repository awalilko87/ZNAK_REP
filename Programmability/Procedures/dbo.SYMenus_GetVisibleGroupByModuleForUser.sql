SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYMenus_GetVisibleGroupByModuleForUser](
	@GroupID nvarchar(20) = null,
	@ModuleName varchar(50),
	@LangID nvarchar(50) = null
)
WITH ENCRYPTION
AS
if @GroupID='SA' SET @GroupID = null
if @GroupID is null
begin
	SELECT
		ModuleName, MenuKey,ISNULL(SYS_MsgMenu.Caption, MenuCaption) MenuCaption, MenuIcon, MenuToolTip, IsGroup,
    IsVisible, MenuRightsOn, GroupKey, Orders, IconKey, DisableInsert,
    DisableEdit, DisableDelete, HTTPLink, ActionName, ISNULL(SYS_MsgMenu.Tooltip,'Tooltip') AS Tooltip, SYMenus.ToolTip,
    [Open] = null /*VMenu potrzebuje parametru Open*/
	FROM SYMenus 
	  LEFT JOIN(SELECT * 
	            FROM SYS_MsgMenu WHERE LangID = @LangID) SYS_MsgMenu ON SYMenus.ModuleName = SYS_MsgMenu.ObjectID AND SYMenus.MenuKey = SYS_MsgMenu.ControlID
	WHERE IsGroup = 1 AND ModuleName = @ModuleName AND IsVisible = 1
	ORDER BY Orders
end
else
begin
	SELECT
		SYMenus.ModuleName, 
		SYMenus.MenuKey, 
		ISNULL(SYS_MsgMenu.Caption, SYMenus.MenuCaption) MenuCaption, 
		SYMenus.MenuIcon, 
		SYMenus.MenuToolTip, 
		SYMenus.IsGroup,
    SYMenus.IsVisible, 
    SYMenus.MenuRightsOn, 
    SYMenus.GroupKey, 
    SYMenus.Orders, 
    SYMenus.IconKey, 
    SYMenus.DisableInsert,
    SYMenus.DisableEdit, 
    SYMenus.DisableDelete, 
    SYMenus.HTTPLink, 
    SYMenus.ActionName, 
    ISNULL(SYS_MsgMenu.Tooltip,'Tooltip') Tooltip, 
    SYMenus.ToolTip,
    SYUserMenu.[Open]
	FROM SYMenus 
	  inner join SYUserMenu on SYUserMenu.MenuKey = SYMenus.MenuKey
		LEFT JOIN (SELECT * FROM SYS_MsgMenu WHERE LangID = @LangID) SYS_MsgMenu 
		ON SYMenus.ModuleName = SYS_MsgMenu.ObjectID AND SYMenus.MenuKey = SYS_MsgMenu.ControlID
	WHERE SYMenus.IsGroup =1 AND SYMenus.ModuleName = @ModuleName AND SYUserMenu.UserID = @GroupID 
		AND SYUserMenu.ModuleCode = @ModuleName AND IsVisible = 1
	ORDER BY SYMenus.Orders
end

GO