SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYMenus_VisibleItemsByGroup](
	@MenuKey varchar(50),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

	SELECT
		ModuleName, MenuKey, MenuCaption, MenuIcon, MenuToolTip, IsGroup,
    IsVisible, MenuRightsOn, GroupKey, Orders, IconKey, DisableInsert,
    DisableEdit, DisableDelete, HTTPLink, ActionName, ToolTip,
    [Open] = null /*VMenu potrzebuje parametru Open*/
	FROM SYMenus 
	WHERE GroupKey = @MenuKey AND IsVisible = 1
		ORDER BY Orders

GO