SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangControls_Search](
    @LangID nvarchar(10),
    @FormID nvarchar(50),
    @ControlID nvarchar(50),
    @Caption nvarchar(200),
    @Tooltip nvarchar(50),
    @ValidateErrMessage nvarchar(150),
    @GridColCaption nvarchar(50),
    @CallbackMessage nvarchar(50),
    @ButtonTextNew nvarchar(150),
    @ButtonTextDelete nvarchar(150),
    @ButtonTextSave nvarchar(150),
    @AltSavePrompt nvarchar(100),
    @AltRequirePrompt nvarchar(100),
    @AltRecCountPrompt nvarchar(100),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        LangID, FormID, ControlID, Caption, Tooltip,
        ValidateErrMessage, GridColCaption, CallbackMessage, ButtonTextNew, ButtonTextDelete,
        ButtonTextSave, AltSavePrompt, AltRequirePrompt, AltRecCountPrompt /*, _USERID_ */ 
    FROM VS_LangControls
            /* WHERE Caption = @Caption AND Tooltip = @Tooltip AND ValidateErrMessage = @ValidateErrMessage AND GridColCaption = @GridColCaption AND CallbackMessage = @CallbackMessage AND
            ButtonTextNew = @ButtonTextNew AND ButtonTextDelete = @ButtonTextDelete AND ButtonTextSave = @ButtonTextSave AND AltSavePrompt = @AltSavePrompt AND AltRequirePrompt = @AltRequirePrompt AND
            AltRecCountPrompt = @AltRecCountPrompt /*  AND _USERID_ = @_USERID_ */ */
GO