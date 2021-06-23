SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYMenus_Update](
    @ModuleName nvarchar(50) OUT,
    @MenuKey nvarchar(50) OUT,
    @MenuCaption nvarchar(4000),
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

IF @MenuKey is null
    SET @MenuKey = NewID()
IF @MenuKey =''
    SET @MenuKey = NewID()
IF @ModuleName is null
    SET @ModuleName = NewID()
IF @ModuleName =''
    SET @ModuleName = NewID()

IF NOT EXISTS (SELECT * FROM SYMenus WHERE MenuKey = @MenuKey AND ModuleName = @ModuleName)
BEGIN
    INSERT INTO SYMenus(
        ModuleName, MenuKey, MenuCaption, MenuToolTip, IsGroup,
        IsVisible, MenuRightsOn, GroupKey, IconKey, DisableInsert, DisableEdit,
        DisableDelete, HTTPLink, ActionName, Orders, ToolTip /*, _USERID_ */ )
    VALUES (
        @ModuleName, @MenuKey, @MenuCaption, @MenuToolTip, @IsGroup,
        @IsVisible, @MenuRightsOn, @GroupKey, @IconKey, @DisableInsert, @DisableEdit,
        @DisableDelete, @HTTPLink, @ActionName, @Orders, @ToolTip /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE SYMenus SET
        MenuCaption = @MenuCaption, MenuToolTip = @MenuToolTip, IsGroup = @IsGroup, IsVisible = @IsVisible, MenuRightsOn = @MenuRightsOn, GroupKey = @GroupKey,
        IconKey = @IconKey, DisableInsert = @DisableInsert, DisableEdit = @DisableEdit, DisableDelete = @DisableDelete, HTTPLink = @HTTPLink,
        ActionName = @ActionName, Orders = @Orders, ToolTip = @ToolTip /* , _USERID_ = @_USERID_ */ 
        WHERE MenuKey = @MenuKey AND ModuleName = @ModuleName
END
GO