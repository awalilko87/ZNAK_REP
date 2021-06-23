SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[SYS_SettingsADV_VV]
AS
SELECT     '' AS PTYPE, '' AS CurrentPassword, UserID, UserName
FROM         dbo.SYUsers

GO