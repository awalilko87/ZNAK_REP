SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[SYS_MsgField]
WITH ENCRYPTION
AS
	SELECT LangID, ObjectID, ControlID, ObjectType, Caption,
		Tooltip, ValidateErrMessage, GridColCaption, CallbackMessage
	FROM         dbo.VS_LangMsgs
	WHERE     (ObjectType = N'FIELD')
GO