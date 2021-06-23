SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

--	select * from dbo.GetType2('ZAP_AXAPTA','JR') 
--	select * from dbo.GetType2('ZAP_AXAPTA','USER')

CREATE function [dbo].[GetType2] 
(	
	-- Add the parameters for the function here
	@p_FormID nvarchar(50),
	@p_TYP1 nvarchar(30),
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
	select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID

	declare @v_Grp nvarchar(30)
	declare @v_LangID nvarchar(30)
	
	select 
		 @v_Grp = UserGroupID 
		,@v_LangID = LangID
	from dbo.SYUsers (nolock)
	where UserID = @p_UserID

	insert into @t ([typ], [desc])
	select TYP2.TYP2_CODE, (case @v_Grp when 'SA' then ISNULL(DES_TEXT,TYP2.TYP2_DESC)+' ('+TYP2.TYP2_CODE+')' else ISNULL(DES_TEXT,TYP2.TYP2_DESC) end)
	from dbo.TYP2 (nolock) 
	inner join dbo.TYP(nolock) on TYP.TYP_ROWID = TYP2_TYP1ID and TYP_ENTITY = @v_Pref
	left join dbo.DESCRIPTIONS(nolock) on DES_ENTITY = TYP_ENTITY and DES_LANGID = @v_LangID and DES_CODE = TYP.TYP_CODE+'#'+TYP2.TYP2_CODE
	where TYP.TYP_CODE = @p_TYP1 order by TYP2.TYP2_DESC

	return 
end

GO