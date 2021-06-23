SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VS_DepartmentRights_VV] AS 
SELECT [VS_DepartmentRights].[DepartmentID], [VS_DepartmentRights].[UserID] FROM VS_DepartmentRights(NOLOCK)
GO