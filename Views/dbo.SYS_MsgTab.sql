SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[SYS_MsgTab]
WITH ENCRYPTION
AS
	SELECT     ObjectID, LangID, ControlID, Caption, Tooltip
	FROM         dbo.VS_LangMsgs
	WHERE     (ObjectType = N'TAB')
GO