SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[SYS_DocDepartments_VV]
AS
SELECT     DepartmentID, DepartmentName
FROM         dbo.VS_Departments

GO