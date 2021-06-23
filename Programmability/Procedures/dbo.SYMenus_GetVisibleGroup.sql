SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYMenus_GetVisibleGroup](
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
	WHERE IsGroup = 1 AND ModuleName = 'ARWEB' 
	ORDER BY Orders


GO