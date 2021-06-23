SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[VS_LangMsgs_GetByID](
    @ControlID nvarchar(50) = '%',
    @LangID nvarchar(10) = '%',
    @ObjectID nvarchar(150) = '%',
    @ObjectType nvarchar(20) = '%',
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT
        LangID, ObjectID, ControlID, ObjectType, Tooltip,
        ValidateErrMessage, GridColCaption, CallbackMessage, ButtonTextNew, ButtonTextDelete,
        ButtonTextSave, AltSavePrompt, AltRequirePrompt, AltRecCountPrompt, AltPageOfCounter, Caption /*, _USERID_ */ 
    FROM VS_LangMsgs
         WHERE ControlID LIKE @ControlID AND LangID LIKE @LangID AND ObjectID LIKE @ObjectID AND ObjectType LIKE @ObjectType
GO