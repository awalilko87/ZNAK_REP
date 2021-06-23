SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangMsgs_CreateFormsMsgs](
	@LangID nvarchar(10)
)
WITH ENCRYPTION
AS

DECLARE forms CURSOR
KEYSET
FOR
    SELECT FormID FROM VS_Forms

DECLARE @FormID nvarchar(50)

OPEN forms
FETCH NEXT FROM forms INTO @FormID
WHILE (@@fetch_status <> -1)
	BEGIN
		IF NOT EXISTS (SELECT * FROM VS_LangMsgs WHERE [LangID] = @LangID AND [ObjectID] = @FormID AND [ControlID] = '' AND [ObjectType] = 'FORM')
		BEGIN
			INSERT INTO VS_LangMsgs([LangID], [ObjectID], [ControlID], [ObjectType], [Caption], [ButtonTextNew], [ButtonTextDelete], [ButtonTextSave], [AltSavePrompt], [AltRequirePrompt], [AltRecCountPrompt], [AltPageOfCounter])
			SELECT @LangID, @FormID, '', 'FORM', [Title], [ButtonTextNew], [ButtonTextDelete], [ButtonTextSave], [AltSavePrompt], [AltRequirePrompt], [AltRecCountPrompt], [AltPageOfCounter] FROM VS_Forms WHERE FormID = @FormID
			--VALUES(@LangID, @FormID, '', 'FORM', @FormID, 'Nowy', 'Usuń', 'Zapisz', 'Dane zapisane.', 'Pole wymagane', 'Rekordów: {0}')
			INSERT INTO VS_LangMsgs([LangID], [ObjectID], [ControlID], [ObjectType], [Caption], [Tooltip], [ValidateErrMessage], [GridColCaption], [CallbackMessage])
			SELECT @LangID, @FormID, FieldID, 'FIELD', Caption, Tooltip, ValidateErrMessage, GridColCaption, CallbackMessage FROM VS_FormFields WHERE FormID = @FormID
		END
	FETCH NEXT FROM forms INTO @FormID
	END
 
CLOSE forms
DEALLOCATE forms

GO