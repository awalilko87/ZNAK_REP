SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[VS_SyUsersMenu] as
select 
	sym.MenuKey, 
	sym.GroupKey, 
	sym.MenuCaption, 
	sym.ModuleName as ModuleCode, 
	sym.Orders,
	SYGroups.GroupID as userID,
	case sume.UserID when sume.UserID then 1 else 0 end Visible,
	sume.DisableInsert,
	sume.DisableEdit,
	sume.DisableDelete 
from symenus sym 
	cross join SYGroups(nolock)
	left join dbo.SYUserMenu sume(nolock) on sume.menukey = sym.menukey and sume.UserID = SYGroups.GroupID
where  isnull(isvisible,0) = 1
 
GO