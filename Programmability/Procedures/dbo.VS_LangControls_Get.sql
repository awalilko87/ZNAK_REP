SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangControls_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        LangID, FormID, ControlID, Caption, Tooltip,
        ValidateErrMessage, GridColCaption, CallbackMessage, ButtonTextNew, ButtonTextDelete,
        ButtonTextSave, AltSavePrompt, AltRequirePrompt, AltRecCountPrompt /*, _USERID_ */ 
    FROM VS_LangControls
GO