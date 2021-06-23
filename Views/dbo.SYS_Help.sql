SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[SYS_Help]
AS
SELECT     LangID, ControlID, ObjectType, ObjectID, Caption
FROM         dbo.VS_LangMsgs

GO