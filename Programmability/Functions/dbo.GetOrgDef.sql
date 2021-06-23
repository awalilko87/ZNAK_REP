SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE function [dbo].[GetOrgDef] 
(
	@p_FormID nvarchar(50)
  , @_UserID nvarchar(50)
)
returns nvarchar(30)
as
begin
	declare @r_Org nvarchar(30)
	declare @v_Module nvarchar(30)
	declare @v_MultiOrg bit
	declare @v_GroupID nvarchar(30)

	select @v_GroupID = UserGroupID, @v_Module = Module from dbo.SYUsersv (nolock) where UserID = @_UserID
	if @v_GroupID is null or @v_Module is null return ''

	select @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID
	
	if isnull(@v_MultiOrg,0) = 1
	  select top 1 @r_Org = p.POR_ORG from dbo.PRVORG p (nolock), dbo.ORG o (nolock)
	  where o.ORG_CODE = p.POR_ORG and POR_GROUP = @v_GroupID and ORG_MODULE = @v_Module and isnull(p.POR_DEFAULT,0) = 1
		and isnull(ORG_NOTUSED,0) = 0
	else 
	  select @r_Org = '*'

	return @r_Org
end

--select [dbo].[GetOrgDef] ('FORMTEST_LSRC','USER')





GO