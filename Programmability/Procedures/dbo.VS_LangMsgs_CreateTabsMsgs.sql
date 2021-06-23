SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangMsgs_CreateTabsMsgs](
	@LangID nvarchar(10)
)
WITH ENCRYPTION
AS

DECLARE tabs CURSOR
KEYSET
FOR
    SELECT MenuID, TabName FROM VS_Tabs

DECLARE @MenuID nvarchar(50)
DECLARE @TabName nvarchar(50)

OPEN tabs
FETCH NEXT FROM tabs INTO @MenuID, @TabName
WHILE (@@fetch_status <> -1)
	BEGIN
		IF NOT EXISTS (SELECT * FROM VS_LangMsgs WHERE [LangID] = @LangID AND [ObjectID] = @MenuID AND [ControlID] = @TabName AND [ObjectType] = 'TAB')
		BEGIN
			INSERT INTO VS_LangMsgs([LangID], [ObjectID], [ControlID], [ObjectType], [Caption], [Tooltip])
			SELECT @LangID, @MenuID, @TabName, 'TAB', TabCaption, TabTooltip FROM VS_Tabs WHERE MenuID = @MenuID AND TabName = @TabName
		END
	FETCH NEXT FROM tabs INTO @MenuID, @TabName
	END

CLOSE tabs
DEALLOCATE tabs

GO