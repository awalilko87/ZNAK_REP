SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[SYS_DocMenuItems_VV]
AS
SELECT     ModuleName, MenuKey, MenuCaption, GroupKey
FROM         dbo.SYMenus
WHERE     (GroupKey NOT LIKE '')

GO