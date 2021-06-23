SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--	select * from dbo.[GetStatusDef]('FORMTEST_RC','*',NULL,NULL,'JR') 
--	select * from dbo.[GetStatusDef]('FORMTEST_RC','*',null,'USER')
--select * from dbo.STA (nolock) where STA_ENTITY = '' and STA_ORG = '*' and (STA_TYPE = '*' or STA_TYPE = '*')

CREATE function [dbo].[GetStatusDef] 
(
	@p_FormID nvarchar(30),
	@p_Type nvarchar(30),
	@p_UserID nvarchar(30)
)
returns nvarchar(30)
as
begin
	declare @r_StatusDef nvarchar(20)
	
	declare @v_Pref nvarchar(20)
	declare @v_MultiOrg bit
	declare @v_Org nvarchar(30)
	declare @v_Class nvarchar(50)
	
	select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg, @v_Class = isnull(Class,'*')  from dbo.VS_Forms (nolock) where FormID = @p_FormID

	declare @v_Grp nvarchar(30)
	select @v_Grp = UserGroupID from dbo.SYUsers (nolock) where UserID = @p_UserID

	select @v_Org = dbo.GetOrgDef(@p_FormID,@p_UserID)

	if isnull(@p_Type,'') = ''
	  set @p_Type = '*'

	if not exists (select 1 from PRVSTA where PST_ENTITY = @v_Pref and PST_GROUP = @v_Grp and isnull(PST_DEFAULT,0) = 1)
	begin
		select top 1 @r_StatusDef = STA_CODE
		from 
		(
		  select STA_CODE, STA_DESC, STA_DEFAULT, STA_ORDER 
		  from dbo.STA (nolock)
		  where isnull(STA_DEFAULT,0) = 1 and STA_ENTITY = @v_Pref 
			and (case STA_ORG when '*' then @v_Org else STA_ORG end) = @v_Org 
			and (case STA_TYPE when '*' then @p_Type else STA_TYPE end) = isnull(@p_Type,'*')
			and (case STA_CLASS when '*' then @v_Class else STA_CLASS end) = @v_Class
	        
		) b
		order by STA_ORDER
	end
	else
	begin
		select top 1 @r_StatusDef = STA_CODE
		from 
		(
		  select STA_CODE, STA_DESC, PST_DEFAULT, STA_ORDER 
		  from dbo.STA (nolock)
			join dbo.PRVSTA (nolock) on STA_ENTITY = PST_ENTITY and STA_CODE = PST_NEWSTATUS and PST_GROUP = @v_Grp
		  where isnull(PST_DEFAULT,0) = 1 and STA_ENTITY = @v_Pref 
			and (case STA_ORG when '*' then @v_Org else STA_ORG end) = @v_Org 
			and (case STA_TYPE when '*' then @p_Type else STA_TYPE end) = isnull(@p_Type,'*')
			and (case STA_CLASS when '*' then @v_Class else STA_CLASS end) = @v_Class	        
		) b
		order by STA_ORDER	
	end
	
	return @r_StatusDef
end

GO