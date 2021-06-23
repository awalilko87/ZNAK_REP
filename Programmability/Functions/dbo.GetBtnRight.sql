SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
 
--select [dbo].[GetBtnRight] (N'FORMTEST_RC')

create function [dbo].[GetBtnRight] ( 
	@p_Org nvarchar(50),
	@p_FormID nvarchar(50),
	@p_UserID nvarchar(50),
	@p_FieldID nvarchar(50)
)

returns int
as
begin
  declare @r_right int
  declare @v_UserGroupID nvarchar(20)

	select @v_UserGroupID = UserGroupID from dbo.SYUsers where UserID = @p_UserID
	select @r_right = ReadOnly from dbo.VS_FormToolbarBtnProfiles(nolock) where /*Org = @p_Org and */FormID = @p_FormID and UserGroupID = @v_UserGroupID and FieldID = @p_FieldID
	set @r_right = isnull(@r_right,0)
return @r_right;
end

--select [dbo].[GetBtnRight] (N'FORMTEST_LS', N'JR', N'TLB_ADDNEW')

GO