SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYMenus_GetItemsByModule](
	@ModuleName varchar(50)
)
WITH ENCRYPTION
AS

	SELECT
		ModuleName, MenuKey, MenuCaption, MenuIcon, MenuToolTip, IsGroup,
    IsVisible, MenuRightsOn, GroupKey, Orders, IconKey, DisableInsert,
    DisableEdit, DisableDelete, HTTPLink, ActionName, ToolTip,
    [Open] = null /*VMenu potrzebuje parametru Open*/
	FROM SYMenus 
	WHERE ModuleName = @ModuleName
	ORDER BY MenuKey, Orders
GO