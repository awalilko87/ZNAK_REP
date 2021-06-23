SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangControls_Update](
    @LangID nvarchar(10) OUT,
    @FormID nvarchar(50) OUT,
    @ControlID nvarchar(50) OUT,
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

IF NOT EXISTS (SELECT * FROM VS_LangControls WHERE ControlID = @ControlID AND FormID = @FormID AND LangID = @LangID)
BEGIN
    INSERT INTO VS_LangControls(
        LangID, FormID, ControlID, Caption, Tooltip,
        ValidateErrMessage, GridColCaption, CallbackMessage, ButtonTextNew, ButtonTextDelete,
        ButtonTextSave, AltSavePrompt, AltRequirePrompt, AltRecCountPrompt /*, _USERID_ */ )
    VALUES (
        @LangID, @FormID, @ControlID, @Caption, @Tooltip,
        @ValidateErrMessage, @GridColCaption, @CallbackMessage, @ButtonTextNew, @ButtonTextDelete,
        @ButtonTextSave, @AltSavePrompt, @AltRequirePrompt, @AltRecCountPrompt /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE VS_LangControls SET
        Caption = @Caption, Tooltip = @Tooltip, ValidateErrMessage = @ValidateErrMessage, GridColCaption = @GridColCaption, CallbackMessage = @CallbackMessage,
        ButtonTextNew = @ButtonTextNew, ButtonTextDelete = @ButtonTextDelete, ButtonTextSave = @ButtonTextSave, AltSavePrompt = @AltSavePrompt, AltRequirePrompt = @AltRequirePrompt,
        AltRecCountPrompt = @AltRecCountPrompt /* , _USERID_ = @_USERID_ */ 
        WHERE ControlID = @ControlID AND FormID = @FormID AND LangID = @LangID
END
GO