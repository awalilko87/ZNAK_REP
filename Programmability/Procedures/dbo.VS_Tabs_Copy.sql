SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_Tabs_Copy](
  @MenuID nvarchar(50),
  @NewMenuID nvarchar(50),
  @TabCaption nvarchar(50)
)
WITH ENCRYPTION
AS

IF EXISTS (SELECT * FROM VS_Tabs WHERE MenuID = @NewMenuID AND TabName = '')
BEGIN
    RAISERROR ('1', 16, 1)
    RETURN
END
ELSE
BEGIN
	INSERT INTO VS_Tabs(
		MenuID, TabName, MenuKey, TabCaption, FormID, Parameters, TabTooltip,
		Visible, TabOrder, TabType, NoUsed )
	SELECT @NewMenuID, TabName, MenuKey, @TabCaption, FormID, Parameters, TabTooltip,
		Visible, TabOrder, TabType, NoUsed
	FROM VS_Tabs WHERE MenuID = @MenuID AND TabName = ''

	INSERT INTO VS_Tabs(
		MenuID, TabName, MenuKey, TabCaption, FormID, Parameters, TabTooltip,
		Visible, TabOrder, TabType, NoUsed )
	SELECT @NewMenuID, TabName, MenuKey, TabCaption, FormID, Parameters, TabTooltip,
		Visible, TabOrder, TabType, NoUsed
	FROM VS_Tabs WHERE MenuID = @MenuID AND TabName <> ''

	INSERT INTO VS_Rights(
		UserID, FormID, FieldID, Rights, Cond, rReadOnly, rVisible, rRequire)
	SELECT UserID, @NewMenuID, FieldID, Rights, Cond, rReadOnly, rVisible, rRequire
	FROM VS_Rights WHERE FormID = @MenuID
END

GO