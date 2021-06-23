SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[GetDeps] (@_UserID nvarchar(30))
RETURNS @t Table (DepartmentID nvarchar(50))
AS
BEGIN
DECLARE @GroupID nvarchar(20)
	SELECT @GroupID = UserGroupID FROM dbo.SYUsers WHERE UserID = @_UserID
	IF @GroupID = 'SA'
		INSERT INTO @t(DepartmentID ) 
			SELECT ISNULL(DepartmentID ,'') d FROM VS_Departments 
			UNION ALL SELECT '*' /* wspólne pomiędzy departamentami */
			UNION ALL SELECT '' d 
			UNION ALL SELECT null d
	ELSE
		INSERT INTO @t(DepartmentID ) 
			SELECT ISNULL(DepartmentID ,'') FROM VS_DepartmentRights WHERE  UserID= @_UserID
			UNION ALL SELECT '*' /* wspólne pomiędzy departamentami */
			UNION ALL SELECT DepartmentID FROM SYUsers WHERE UserID= @_UserID
RETURN 
END
GO