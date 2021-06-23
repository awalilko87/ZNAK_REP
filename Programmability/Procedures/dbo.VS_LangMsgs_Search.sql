SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangMsgs_Search](
    @LangID nvarchar(10),
    @ObjectID nvarchar(150),
    @ControlID nvarchar(50),
    @ObjectType nvarchar(20),
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

    SELECT
        LangID, ObjectID, ControlID, ObjectType, Tooltip,
        ValidateErrMessage, GridColCaption, CallbackMessage, ButtonTextNew, ButtonTextDelete,
        ButtonTextSave, AltSavePrompt, AltRequirePrompt, AltRecCountPrompt, AltPageOfCounter, Caption /*, _USERID_ */ 
    FROM VS_LangMsgs
            /* WHERE Tooltip = @Tooltip AND ValidateErrMessage = @ValidateErrMessage AND GridColCaption = @GridColCaption AND CallbackMessage = @CallbackMessage AND ButtonTextNew = @ButtonTextNew AND
            ButtonTextDelete = @ButtonTextDelete AND ButtonTextSave = @ButtonTextSave AND AltSavePrompt = @AltSavePrompt AND AltRequirePrompt = @AltRequirePrompt AND AltRecCountPrompt = @AltRecCountPrompt AND AltPageOfCounter = @AltPageOfCounter AND
            Caption = @Caption /*  AND _USERID_ = @_USERID_ */ */
GO