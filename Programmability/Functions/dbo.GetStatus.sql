SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

--	select * from dbo.[GetStatus]('FORMTEST_RC','*',NULL,NULL,'JR') 
--	select * from dbo.[GetStatus]('FORMTEST_RC','*',null,'USER')
--select * from dbo.STA (nolock) where STA_ENTITY = '' and STA_ORG = '*' and (STA_TYPE = '*' or STA_TYPE = '*')

CREATE function [dbo].[GetStatus] 
(
	@p_FormID nvarchar(30),
	@p_Org nvarchar(30),
	@p_Type nvarchar(30),
	@p_OldStatus nvarchar(30),
	@p_UserID nvarchar(30)
)
returns 
@t table 
(
	[code] nvarchar(30),
	[desc] nvarchar(80)
)
as
begin
	declare @v_Pref nvarchar(10)
	declare @v_Class nvarchar(50)
	declare @v_MultiOrg bit
	select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg, @v_Class = isnull(Class,'*') from dbo.VS_Forms (nolock) where FormID = @p_FormID

	declare @v_Grp nvarchar(30)
	declare @v_LangID nvarchar(30)
	
	select 
		 @v_Grp = UserGroupID 
		,@v_LangID = LangID
	from dbo.SYUsers (nolock)
	where UserID = @p_UserID

	if isnull(@p_Type,'') = ''
	  set @p_Type = '*'

	insert into @t ([code],[desc])
	select 
	    STA_CODE
	  , STA_DESC = (case @v_Grp when 'SA' then STA_DESC+' ('+STA_CODE+')' else STA_DESC end)
	from 
	(
	  select STA_CODE, STA_DESC = STA_DESC, STA_DEFAULT, STA_ORDER 
	  from dbo.STA (nolock)
      where STA_CODE = @p_OldStatus and STA_ENTITY = @v_Pref 
		and (case STA_ORG when '*' then @p_Org else STA_ORG end) = @p_Org 
		and (case STA_TYPE when '*' then @p_Type else STA_TYPE end) = @p_Type
        and (case STA_CLASS when '*' then @v_Class else STA_CLASS end) = @v_Class
        union
	  select PST_NEWSTATUS, STA_DESC, STA_DEFAULT, STA_ORDER
	  from 
      (
	    select p.PST_NEWSTATUS, s.STA_DEFAULT, STA_ORDER, STA_DESC = STA_DESC
	    from dbo.PRVSTA p (nolock), dbo.STA s (nolock)
		where s.STA_CODE = p.PST_NEWSTATUS 
		and s.STA_ENTITY = p.PST_ENTITY 
		and p.PST_GROUP = @v_Grp
		and (case s.STA_ORG when '*' then @p_Org else s.STA_ORG end) = @p_Org
		and (case s.STA_TYPE when '*' then @p_Type else s.STA_TYPE end) = @p_Type
		and (case STA_CLASS when '*' then @v_Class else STA_CLASS end) = @v_Class
        and p.PST_ENTITY = @v_Pref and isnull(p.PST_OLDSTATUS,'-') = isnull(@p_OldStatus,'-') 
	  ) a
	) b
	order by STA_ORDER

	return 
end



GO