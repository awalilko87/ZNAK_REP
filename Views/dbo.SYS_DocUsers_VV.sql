﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[SYS_DocUsers_VV]
AS
SELECT     UserName, UserGroupID, LangID
FROM         dbo.SYUsers

GO