SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYMenus_Search](
    @ModuleName nvarchar(50),
    @MenuKey nvarchar(50),
    @MenuCaption nvarchar(4000),
    @MenuIcon nvarchar(4000),
    @MenuToolTip nvarchar(1000),
    @IsGroup bit,
    @IsVisible bit,
    @MenuRightsOn bit,
    @GroupKey nvarchar(50),
    @IconKey nvarchar(100),
    @DisableInsert bit,
    @DisableEdit bit,
    @DisableDelete bit,
    @HTTPLink nvarchar(1000),
    @ActionName nvarchar(50),
    @Orders int,
    @ToolTip nvarchar(max),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        ModuleName, MenuKey, MenuCaption, MenuIcon, MenuToolTip, IsGroup,
        IsVisible, MenuRightsOn, GroupKey, IconKey, DisableInsert, DisableEdit,
        DisableDelete, HTTPLink, ActionName, Orders, ToolTip,
        [Open] = null /*VMenu potrzebuje parametru Open */
        /*_USERID_ */ 
    FROM SYMenus
            /* WHERE MenuCaption = @MenuCaption AND MenuToolTip = @MenuToolTip AND IsGroup = @IsGroup AND IsVisible = @IsVisible AND GroupKey = @GroupKey AND
            IconKey = @IconKey AND DisableInsert = @DisableInsert AND DisableEdit = @DisableEdit AND DisableDelete = @DisableDelete AND HTTPLink = @HTTPLink AND
            ActionName = @ActionName AND Orders = @Orders AND ToolTip = @ToolTip /*  AND _USERID_ = @_USERID_ */ */
GO