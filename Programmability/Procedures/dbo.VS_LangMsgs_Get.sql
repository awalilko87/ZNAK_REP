SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangMsgs_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        LangID, ObjectID, ControlID, ObjectType, Tooltip,
        ValidateErrMessage, GridColCaption, CallbackMessage, ButtonTextNew, ButtonTextDelete,
        ButtonTextSave, AltSavePrompt, AltRequirePrompt, AltRecCountPrompt, AltPageOfCounter, Caption /*, _USERID_ */ 
    FROM VS_LangMsgs
GO