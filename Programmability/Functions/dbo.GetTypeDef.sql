SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE function [dbo].[GetTypeDef] 
(	
	-- Add the parameters for the function here
	@p_FormID nvarchar(50),
	@p_Org nvarchar(30), 
	@p_Type nvarchar(30), 
	@p_UserID nvarchar(50)
)
returns nvarchar(30)

as
begin
declare @v_pref nvarchar(10)
declare @r_typ nvarchar(30)

	select @v_pref = TablePrefix from dbo.VS_Forms (nolock) where FormID = @p_FormID
	
	declare @v_Grp nvarchar(30)
	select @v_Grp = UserGroupID from dbo.SYUsers (nolock) where UserID = @p_UserID
	
	select top 1 @r_typ = TYP_CODE 
	from dbo.TYP (nolock)
		join PRVTYPE (nolock) on TYP_ENTITY = PTY_ENTITY and TYP_CODE = PTY_TYPE and PTY_GROUP = @v_Grp
	where TYP_ENTITY = @v_pref 
	and (case TYP_ORG when '*' then @p_Org else TYP_ORG end) = @p_Org 
	and isnull(TYP_DEFAULT,0) = 1

	return @r_typ
end


GO