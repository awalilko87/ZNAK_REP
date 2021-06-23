SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[SYS_DocForms_VV]
AS
SELECT     FormID, Title, SQLSelect, SQLGridSelect, SQLUpdate, SQLDelete, ShowGrid, ShowTree, TableName, FormDescription, RegisterVariable
FROM         dbo.VS_Forms

GO