SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangMsgs_Update](
    @LangID nvarchar(10) OUT,
    @ObjectID nvarchar(150) OUT,
    @ControlID nvarchar(50) OUT,
    @ObjectType nvarchar(20) OUT,
    @Tooltip nvarchar(4000),
    @ValidateErrMessage nvarchar(150),
    @GridColCaption nvarchar(50),
    @CallbackMessage nvarchar(50),
    @ButtonTextNew nvarchar(150),
    @ButtonTextDelete nvarchar(150),
    @ButtonTextSave nvarchar(150),
    @AltSavePrompt nvarchar(100),
    @AltRequirePrompt nvarchar(100),
    @AltRecCountPrompt nvarchar(100),
	@AltPageOfCounter nvarchar(100),
    @Caption nvarchar(4000),
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF NOT EXISTS (SELECT * FROM VS_LangMsgs WHERE ControlID = @ControlID AND LangID = @LangID AND ObjectID = @ObjectID AND ObjectType = @ObjectType)
BEGIN
    INSERT INTO VS_LangMsgs(
        LangID, ObjectID, ControlID, ObjectType, Tooltip,
        ValidateErrMessage, GridColCaption, CallbackMessage, ButtonTextNew, ButtonTextDelete,
        ButtonTextSave, AltSavePrompt, AltRequirePrompt, AltRecCountPrompt, AltPageOfCounter, Caption /*, _USERID_ */ )
    VALUES (
        @LangID, @ObjectID, @ControlID, @ObjectType, @Tooltip,
        @ValidateErrMessage, @GridColCaption, @CallbackMessage, @ButtonTextNew, @ButtonTextDelete,
        @ButtonTextSave, @AltSavePrompt, @AltRequirePrompt, @AltRecCountPrompt, @AltPageOfCounter, @Caption /*, p_USERID_ */ )
END
ELSE
BEGIN
    UPDATE VS_LangMsgs SET
        Tooltip = @Tooltip, ValidateErrMessage = @ValidateErrMessage, GridColCaption = @GridColCaption, CallbackMessage = @CallbackMessage, ButtonTextNew = @ButtonTextNew,
        ButtonTextDelete = @ButtonTextDelete, ButtonTextSave = @ButtonTextSave, AltSavePrompt = @AltSavePrompt, AltRequirePrompt = @AltRequirePrompt, AltRecCountPrompt = @AltRecCountPrompt, AltPageOfCounter = @AltPageOfCounter,
        Caption = @Caption /* , _USERID_ = @_USERID_ */ 
        WHERE ControlID = @ControlID AND LangID = @LangID AND ObjectID = @ObjectID AND ObjectType = @ObjectType
END
GO