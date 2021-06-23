﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Tabs_GetToUseByMenuID](
    @MenuID nvarchar(50) = '%',
    @GroupID nvarchar(20),
    @LangID nvarchar(10),
	@UserID nvarchar(30) = null,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
    SELECT
        MenuID, TabName, MenuKey, ISNULL(SYS_MsgTab.Caption, TabCaption) TabCaption, FormID, Parameters,
        ISNULL(SYS_MsgTab.Tooltip, TabTooltip) TabTooltip,
        Visible, TabOrder, TabType, NoUsed 
    FROM VS_Tabs 
		LEFT JOIN (SELECT Tooltip,ObjectID,ControlID,Caption FROM SYS_MsgTab WHERE LangID = @LangID) SYS_MsgTab 
		ON VS_Tabs.MenuID = SYS_MsgTab.ObjectID AND VS_Tabs.TabName = SYS_MsgTab.ControlID
    WHERE MenuID LIKE @MenuID AND TabName <> '' AND ISNULL(NoUsed, 0) = 0
	ORDER BY TabOrder
GO