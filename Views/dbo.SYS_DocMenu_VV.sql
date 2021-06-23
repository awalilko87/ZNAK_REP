SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[SYS_DocMenu_VV]
AS
SELECT     ModuleName, MenuKey, MenuCaption, GroupKey
FROM         dbo.SYMenus

GO