SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangMsgs_GetByObjectType](
	@LangID nvarchar(10) = '%',
    @ObjectType nvarchar(20) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        [LangID], ObjectID, ControlID, ObjectType, Caption,
        Tooltip, ValidateErrMessage, GridColCaption, CallbackMessage, ButtonTextNew,
        ButtonTextDelete, ButtonTextSave, AltSavePrompt, AltRequirePrompt, AltRecCountPrompt, AltPageOfCounter /*, _USERID_ */ 
    FROM VS_LangMsgs
         WHERE [LangID] = @LangID AND ObjectType = @ObjectType
	ORDER BY ObjectID, ControlID
GO