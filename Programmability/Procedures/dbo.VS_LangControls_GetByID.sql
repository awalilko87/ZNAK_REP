SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangControls_GetByID](
    @ControlID nvarchar(50) = '%',
    @FormID nvarchar(50) = '%',
    @LangID nvarchar(10) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        LangID, FormID, ControlID, Caption, Tooltip,
        ValidateErrMessage, GridColCaption, CallbackMessage, ButtonTextNew, ButtonTextDelete,
        ButtonTextSave, AltSavePrompt, AltRequirePrompt, AltRecCountPrompt /*, _USERID_ */ 
    FROM VS_LangControls
         WHERE ControlID LIKE @ControlID AND FormID LIKE @FormID AND LangID LIKE @LangID
GO