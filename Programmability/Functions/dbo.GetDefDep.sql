SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[GetDefDep] (@_UserID nvarchar(30))
RETURNS nvarchar(50)
AS

BEGIN
	DECLARE @DepartmentID nvarchar(50)
	SELECT @DepartmentID = ISNULL(DepartmentID, '') FROM SYUsers WHERE UserID = @_UserID
RETURN (@DepartmentID)
END
GO