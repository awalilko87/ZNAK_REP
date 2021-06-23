SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[TabRights_Tree_Proc](
@p_GroupID nvarchar(30),
@p_UserID nvarchar(30)
)
as
begin

	declare @t_tabs table (FormID nvarchar(80), MenuID nvarchar(80), TabCaption nvarchar(180)/*, GroupID nvarchar(80)*/)

	if @p_GroupID = 'SA'
	begin
		insert into @t_tabs
		select SYMenus.MenuKey, null, MenuCaption
		from dbo.SYMenus(nolock)
		where SYMenus.IsGroup =1 and SYMenus.ModuleName = 'ZMT' and IsVisible = 1
			and SYMenus.MenuKey not in ('ZMT_REPORT','ZMT_LAST','ZMT_SYSTEM','')
		order by Orders
	end
	else
	begin
		insert into @t_tabs
		select SYMenus.MenuKey, null, '<b>'+MenuCaption+'</b><font color="orange"><small> - Menu gĹ‚Ăłwne</small></font>'
		from dbo.SYMenus(nolock)
		inner join dbo.SYUserMenu(nolock) on SYUserMenu.MenuKey = SYMenus.MenuKey
		where SYMenus.IsGroup =1 and SYMenus.ModuleName = 'ZMT' and SYUserMenu.UserID = @p_GroupID
			and SYUserMenu.ModuleCode = 'ZMT' and IsVisible = 1
			and SYMenus.MenuKey not in ('ZMT_REPORT','ZMT_LAST','ZMT_SYSTEM','')
		order by Orders
	end

	insert into @t_tabs
	select SYMenus.MenuKey, GroupKey, '<b>'+MenuCaption+'</b><font color="blue"><small> - Menu podrzÄ™dne</small></font>'
	from dbo.SYMenus(nolock) 
	inner join dbo.SYUserMenu(nolock) on SYUserMenu.MenuKey = SYMenus.MenuKey and SYMenus.ModuleName = 'ZMT' and SYUserMenu.UserID = @p_GroupID
	inner join @t_tabs on GroupKey like FormID+'%' and IsVisible = 1
	order by Orders

	insert into @t_tabs
	select vt.MenuID+'#'+vt.FormID, t.FormID, vt.TabCaption+'<font color="#30D5C8"><small> - ZakĹ‚adka</small></font>'
	from dbo.VS_Tabs vt(nolock)
	inner join @t_tabs t on isnull(t.MenuID,'nullek1') = isnull(vt.MenuKey,'nullek2')
	inner join dbo.SYMenus m(nolock) on isnull(vt.MenuKey,'nullek2') like m.GroupKey+'%' and m.HTTPLink like '%TGR_'+isnull(vt.MenuID,'uuuu')+'&%'
		and t.FormID = m.MenuKey and vt.Visible = 1 AND isnull(vt.NoUsed, 0) = 0
	order by vt.TabOrder

	select * from @t_tabs
end
GO