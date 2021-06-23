SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[SYS_MsgForm]
WITH ENCRYPTION
AS
	SELECT LangID, ObjectID, ControlID, ObjectType, Caption,
		Tooltip, ButtonTextNew, ButtonTextDelete, ButtonTextSave, AltSavePrompt,
		AltRequirePrompt, AltRecCountPrompt, AltPageOfCounter
	FROM         dbo.VS_LangMsgs
	WHERE     (ObjectType = N'FORM')
GO