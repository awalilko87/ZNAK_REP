SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create function [dbo].[GetTabRight] (  
	@p_MenuID nvarchar(30),
	@p_TabName nvarchar(50),
	@p_FormID nvarchar(50),
	@p_GroupID nvarchar(30)
)

returns int
as
begin
	declare @r_right int
	
	if not exists (select 1 from dbo.VS_Rights(nolock) 
		where formid = @p_MenuID and fieldid = @p_TabName and UserID = @p_GroupID and isnumeric(rVisible) = 1)
	select @r_right = 1
	else
	select top 1 @r_right = cast(rvisible as INT) from dbo.VS_Rights(nolock) 
	where formid = @p_MenuID and fieldid = @p_TabName and UserID = @p_GroupID and isnumeric(rVisible) = 1
	
	set @r_right = isnull(@r_right,0)
	return @r_right;
end

--select [dbo].[GetTabRight] ('REQ', 'REQ_SUPP', 'REQ_SUPP', 'K_UR')
--select * from vs_rights where userid = 'SA' and fieldid = 'OBJ_COM'
--select *from vs_tabs
-- 
GO