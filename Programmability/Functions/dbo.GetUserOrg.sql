SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[GetUserOrg] 
(
	@_UserID nvarchar(50)
)
RETURNS 
@t TABLE 
(
	ORG nvarchar(30),
	DEF int
)
AS
BEGIN
	declare @Module nvarchar(30)
	declare @GroupID nvarchar(30)
	select @GroupID = UserGroupID, @Module = isnull(Module, 'ZMT') from SYUsers where UserID = @_UserID

	-- Fill the table variable with the rows for your result set
	if @groupID='SA' 
		insert Into @t (ORG, DEF) 
		SELECT ORG_CODE, ORG_DEFAULT FROM ORG WHERE ORG_MODULE = @Module
	else
		insert Into @t (ORG, DEF) 
		SELECT distinct p.POR_ORG, o.ORG_DEFAULT FROM dbo.PRVORG p, dbo.ORG o
			WHERE o.ORG_CODE = p.POR_ORG and POR_GROUP = @GroupID and ORG_MODULE = @Module
	RETURN 
END






GO