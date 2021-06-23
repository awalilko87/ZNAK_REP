SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- select * from dbo.GetType('FORMTEST_RC','*')   
-- select * from dbo.GetType('FORMTEST_RC','BUK')   
  
CREATE function [dbo].[GetType]   
(   
 -- Add the parameters for the function here  
 @p_FormID nvarchar(50),  
 @p_Org nvarchar(30),  
 @p_type nvarchar(30),  
 @p_UserID nvarchar(50)  
)  
returns   
@t table  
(  
   [typ] nvarchar(30)  
  ,[desc] nvarchar(80)  
)  
  
as  
begin  
	declare @v_Pref nvarchar(10)  
	declare @v_MultiOrg bit  
	declare @p_Class nvarchar(10)  

	select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg, @p_Class = Class from dbo.VS_Forms (nolock) where FormID = @p_FormID  

	declare @v_Grp nvarchar(30)
	declare @v_LangID nvarchar(30)
	
	select 
		 @v_Grp = UserGroupID 
		,@v_LangID = LangID
	from dbo.SYUsers (nolock)
	where UserID = @p_UserID

	if isnull(@v_MultiOrg,0) = 1  
	begin  
		insert into @t ([typ], [desc])  
		select TYP_CODE, TYP_DESC = (case @v_Grp when 'SA' then TYP_DESC+' ('+TYP_CODE+')' else TYP_DESC end) from (  
			select TYP_CODE, TYP_DESC = ISNULL(DES_TEXT,TYP_DESC), TYP_ORDER  
			from dbo.TYP (nolock)  
			join PRVTYPE (nolock) on TYP_ENTITY = PTY_ENTITY  and PTY_GROUP = @v_Grp  and (TYP_CODE = PTY_TYPE or PTY_TYPE = '*')
			left join dbo.DESCRIPTIONS(nolock) on DES_ENTITY = TYP_ENTITY and DES_LANGID = @v_LangID and DES_CODE = TYP_CODE
			where TYP_ENTITY = @v_Pref   
			and TYP_ORG in (select POR_ORG from dbo.PRVORG (nolock) where POR_GROUP = @v_Grp union select '*') --(@p_Org,'*')  
			--and isnull(TYP_CLASS,@p_Class) = (case isnull(@p_Class,'') when '' then isnull(TYP_CLASS,'') else @p_Class end)   
			and isnull(TYP_NOTUSED,0) = 0  
			union  
			select TYP_CODE, TYP_DESC = ISNULL(DES_TEXT,TYP_DESC), TYP_ORDER  
			from dbo.TYP (nolock) 
			left join dbo.DESCRIPTIONS(nolock) on DES_ENTITY = TYP_ENTITY and DES_LANGID = @v_LangID and DES_CODE = TYP_CODE 
			where TYP_ENTITY = @v_Pref and TYP_CODE = @p_type)typ 
		order by isnull(TYP_ORDER,0), TYP_CODE  
	end  
	else  
	begin  
		insert into @t  
		select TYP_CODE, TYP_DESC = (case @v_Grp when 'SA' then TYP_DESC+' ('+TYP_CODE+')' else TYP_DESC end) from (  
		select TYP_CODE, TYP_DESC = ISNULL(DES_TEXT,TYP_DESC), TYP_ORDER  
		from dbo.TYP (nolock)
		inner join PRVTYPE (nolock) on TYP_ENTITY = PTY_ENTITY and PTY_GROUP = @v_Grp and (TYP_CODE = PTY_TYPE or PTY_TYPE = '*') 
		left join dbo.DESCRIPTIONS(nolock) on DES_ENTITY = TYP_ENTITY and DES_LANGID = @v_LangID and DES_CODE = TYP_CODE
		where TYP_ENTITY = @v_Pref   
		and TYP_ORG  in (select ORG from dbo.GetUserOrg(@p_UserID) union select '*')  
		and isnull(TYP_CLASS,'') = (case isnull(@p_Class,'') when '' then isnull(TYP_CLASS,'') else @p_Class end)   
		and isnull(TYP_NOTUSED,0) = 0  
		union   
		select TYP_CODE, TYP_DESC = ISNULL(DES_TEXT,TYP_DESC), TYP_ORDER  
		from dbo.TYP (nolock) 
		left join dbo.DESCRIPTIONS(nolock) on DES_ENTITY = TYP_ENTITY and DES_LANGID = @v_LangID and DES_CODE = TYP_CODE 
		where TYP_ENTITY = @v_Pref and TYP_CODE = @p_type)typ order by isnull(TYP_ORDER,0), TYP_CODE  
	end  
return   
end  

GO