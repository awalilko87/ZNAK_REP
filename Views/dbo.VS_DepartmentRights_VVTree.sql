SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE view [dbo].[VS_DepartmentRights_VVTree] as
SELECT [DepartmentID],[DepartmentName],ParentID FROM (
SELECT [DepartmentID]
      ,'Departament: <b>' + ISNULL([DepartmentName],'') +'</b> (<b>' +(SELECT CONVERT(nvarchar(10),COUNT(*)) FROM VS_DepartmentRights x WHERE x.[DepartmentID] =[VS_Departments].[DepartmentID] ) +'</b>)' [DepartmentName]
      ,null ParentID
  FROM [dbo].[VS_Departments]
UNION ALL
SELECT VS_DepartmentRights.[UserID] [DepartmentID]
      ,'Użytkownik: <b>' +ISNULL([UserName],'') + '</b> [' + ISNULL(UserGroupID,'') + '], Domyslny departament: <b>' + ISNULL([SYUsers].[DepartmentID],'')+'</b>' [DepartmentName]
      ,VS_DepartmentRights.[DepartmentID] ParentID
	FROM dbo.VS_DepartmentRights LEFT JOIN [dbo].[SYUsers] ON VS_DepartmentRights.[UserID]=[SYUsers].[UserID] ) AS AA
	


GO