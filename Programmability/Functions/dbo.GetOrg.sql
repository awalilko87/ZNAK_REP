SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create function [dbo].[GetOrg](@p_FormID nvarchar(50), @_UserID nvarchar(30))  
returns   
@t table (org nvarchar(30) primary key)  
as  
begin  
	declare @v_Module nvarchar(30)  
	declare @v_MultiOrg bit  
	declare @v_GroupID nvarchar(30)  

	select @v_GroupID = UserGroupID, @v_Module = Module from dbo.SYUsers (nolock) where UserID = @_UserID  
	if @v_GroupID is null or @v_Module is null 
		return  

	select @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID  

	if isnull(@v_MultiOrg,0) = 1  
		insert into @t (org)   
		select distinct p.POR_ORG from dbo.PRVORG p (nolock), dbo.ORG o (nolock)  
		where o.ORG_CODE = p.POR_ORG and POR_GROUP = @v_GroupID and ORG_MODULE = 'ZMT' and isnull(ORG_NOTUSED,0) = 0  
	else  
		insert into @t (org)   
		select '*'  
   
 return   
end  
GO