SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYMenus_GetSorted](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ModuleName, MenuKey, MenuCaption, MenuIcon, MenuToolTip, IsGroup,
        IsVisible, MenuRightsOn, GroupKey, IconKey, DisableInsert, DisableEdit,
        DisableDelete, HTTPLink, ActionName, Orders, ToolTip,
        [Open] = null /*VMenu potrzebuje parametru Open*/
        /*, _USERID_ */ 
    FROM SYMenus
	ORDER BY ModuleName, MenuKey
GO