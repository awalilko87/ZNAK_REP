SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE view [dbo].[PROPERTIES_LISTv]
as
SELECT 
	[PRL_TEXT]
	,[PRL_UPDATECOUNT]
	,[PRL_CREATED]
	,[PRL_UPDATED]
	,[PRL_ROWID]
	,[PRL_PROID]
FROM 
	[dbo].[PROPERTIES_LIST]




GO