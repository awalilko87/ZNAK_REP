SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE function [dbo].[GetOrgObjID](@p_UserID nvarchar(30))
returns int
as
begin
	declare @v_ret int
	declare @v_DefOrg nvarchar(30)

	select @v_DefOrg = dbo.GetOrgDef('OBJ_LS',@p_UserID)
	if @v_DefOrg is null
	begin
		select top 1 @v_DefOrg = POR_ORG from dbo.PRVORG(nolock) 
		inner join dbo.SYUsers(nolock) on UserID = @p_UserID and UserGroupID = POR_GROUP
	end

	select @v_ret = OBJ_ROWID from dbo.OBJ(nolock) where OBJ_CODE = @v_DefOrg and OBJ_ORG = @v_DefOrg

	return @v_ret
	
end
GO