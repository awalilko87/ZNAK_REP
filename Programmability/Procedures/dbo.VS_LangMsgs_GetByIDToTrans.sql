SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangMsgs_GetByIDToTrans](
    @ControlID nvarchar(50) = '%',
    @LangID nvarchar(10) = '%',
    @ObjectID nvarchar(150) = '%',
    @ObjectType nvarchar(20) = '%'
)
WITH ENCRYPTION
AS
	IF EXISTS(SELECT [LangID] FROM VS_LangMsgs WHERE ControlID LIKE @ControlID AND [LangID] LIKE @LangID AND ObjectID LIKE @ObjectID AND ObjectType LIKE @ObjectType)
		SELECT
	        [LangID], ObjectID, ControlID, ObjectType, Tooltip,
	        ValidateErrMessage, GridColCaption, CallbackMessage, ButtonTextNew, ButtonTextDelete,
	        ButtonTextSave, AltSavePrompt, AltRequirePrompt, AltRecCountPrompt, AltPageOfCounter, Caption
		FROM VS_LangMsgs
			WHERE ControlID LIKE @ControlID AND [LangID] LIKE @LangID AND ObjectID LIKE @ObjectID AND ObjectType LIKE @ObjectType
	ELSE
		BEGIN	
			IF (@ObjectType = 'FORM')
				SELECT
					@LangID AS [LangID], @ObjectID AS ObjectID, @ControlID AS ControlID, @ObjectType AS ObjectType, '' AS Tooltip,
					'' AS ValidateErrMessage, '' AS GridColCaption, '' AS CallbackMessage, ButtonTextNew, ButtonTextDelete,
					ButtonTextSave, AltSavePrompt, AltRequirePrompt, AltRecCountPrompt, AltPageOfCounter, Title AS Caption
				FROM VS_Forms
					WHERE FormID = @ObjectID 
			ELSE IF (@ObjectType = 'FIELD') 
				SELECT
					@LangID AS [LangID], @ObjectID AS ObjectID, @ControlID AS ControlID, @ObjectType AS ObjectType, Tooltip,
					ValidateErrMessage, GridColCaption, CallbackMessage, '' AS ButtonTextNew, '' AS ButtonTextDelete,
					'' AS ButtonTextSave, '' AS AltSavePrompt, '' AS AltRequirePrompt, '' AS AltRecCountPrompt, '' AS AltPageOfCounter, Caption
				FROM VS_FormFields
					WHERE FormID = @ObjectID AND FieldID = @ControlID 
			ELSE IF (@ObjectType = 'TAB') 
				SELECT
					@LangID AS [LangID], @ObjectID AS ObjectID, @ControlID AS ControlID, @ObjectType AS ObjectType, TabTooltip AS Tooltip,
					'' AS ValidateErrMessage, '' AS GridColCaption, '' AS CallbackMessage, '' AS ButtonTextNew, '' AS ButtonTextDelete,
					'' AS ButtonTextSave, '' AS AltSavePrompt, '' AS AltRequirePrompt, '' AS AltRecCountPrompt, '' AS AltPageOfCounter, TabCaption AS Caption
				FROM VS_Tabs
					WHERE MenuID = @ObjectID AND TabName = @ControlID
			ELSE IF (@ObjectType = 'MENU')
				SELECT
					@LangID AS [LangID], @ObjectID AS ObjectID, @ControlID AS ControlID, @ObjectType AS ObjectType, ToolTip AS Tooltip,
					'' AS ValidateErrMessage, '' AS GridColCaption, '' AS CallbackMessage, '' AS ButtonTextNew, '' AS ButtonTextDelete,
					'' AS ButtonTextSave, '' AS AltSavePrompt, '' AS AltRequirePrompt, '' AS AltRecCountPrompt, '' AS AltPageOfCounter, MenuCaption AS Caption
				FROM SYMenus
					WHERE ModuleName = @ObjectID AND MenuKey = @ControlID
			ELSE
				SELECT
					[LangID], ObjectID, ControlID, ObjectType, Tooltip,
					ValidateErrMessage, GridColCaption, CallbackMessage, ButtonTextNew, ButtonTextDelete,
					ButtonTextSave, AltSavePrompt, AltRequirePrompt, AltRecCountPrompt, AltPageOfCounter, Caption
				FROM VS_LangMsgs
					WHERE ControlID LIKE @ControlID AND [LangID] LIKE @LangID AND ObjectID LIKE @ObjectID AND ObjectType LIKE @ObjectType

		  
		END
GO