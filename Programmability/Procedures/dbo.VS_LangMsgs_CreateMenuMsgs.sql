SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangMsgs_CreateMenuMsgs](
	@LangID nvarchar(10)
)
WITH ENCRYPTION
AS

DECLARE menus CURSOR
KEYSET
FOR
    SELECT ModuleName, MenuKey FROM SYMenus

DECLARE @ModuleName nvarchar(50)
DECLARE @MenuKey nvarchar(50)

OPEN menus
FETCH NEXT FROM menus INTO @ModuleName, @MenuKey
WHILE (@@fetch_status <> -1)
	BEGIN
		IF NOT EXISTS (SELECT * FROM VS_LangMsgs WHERE [LangID] = @LangID AND [ObjectID] = @ModuleName AND [ControlID] = @MenuKey AND [ObjectType] = 'MENU')
		BEGIN
			INSERT INTO VS_LangMsgs([LangID], [ObjectID], [ControlID], [ObjectType], [Caption], [Tooltip])
			SELECT @LangID, @ModuleName, @MenuKey, 'MENU', MenuCaption, ToolTip FROM SYMenus WHERE ModuleName = @ModuleName AND MenuKey = @MenuKey
		END
	FETCH NEXT FROM menus INTO @ModuleName, @MenuKey
	END

CLOSE menus
DEALLOCATE menus

GO