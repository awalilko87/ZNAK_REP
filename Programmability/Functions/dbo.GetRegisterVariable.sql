SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create function [dbo].[GetRegisterVariable] ( 
	@FormID nvarchar(50))

returns @indicestable table (
  [FormID] nvarchar(50),
  [RV] nvarchar(2000),
  [SrcFormID] nvarchar(50),
  [SrcFieldID] nvarchar(50),
  [SrcCaption] nvarchar(200)
)
as
begin
  declare @v_RV nvarchar(2000)
	select @v_RV = RegisterVariable from dbo.VS_Forms where FormID = @FormID

	insert into @indicestable ([FormID], [RV], [SrcFormID], [SrcFieldID], [SrcCaption])
	--select @FormID, '@RV_'+left(String,charindex('=',String)-1) from [dbo].[VS_Split2] (@v_RV,';') where String <> ''
	select A.FormID, A.RV, A.SrcFormID, A.SrcFieldID, F.Caption 
	from
	(
	  select 
		  FormID = @FormID
		, RV = '@RV_'+left(String,charindex('=',String)-1)
		, SrcFormID = left(replace(replace(String, left(String,charindex('#',String)),''), '#',''), charindex('.', replace(replace(String, left(String,charindex('#',String)),''), '#',''))-1)
		, SrcFieldID = right(replace(replace(String, left(String,charindex('#',String)),''), '#',''), len(replace(replace(String, left(String,charindex('#',String)),''), '#',''))-charindex('.',replace(replace(String, left(String,charindex('#',String)),''), '#','')))
	  from [dbo].[VS_Split2] (@v_RV,';')	where String <> ''
	) A
	inner join dbo.VS_FormFields F (nolock) on [SrcFormID]=F.[FormID] and [SrcFieldID]=F.[FieldID]


return;
end

--select * from [dbo].[VS_Split2] ('ID=#FORMTEST_LS._ID#;CODE=#FORMTEST_LS._CODE#;ORG=#FORMTEST_LS._ORG#;',';') 
--select  RegisterVariable from dbo.VS_Forms where FormID = 'FORMTEST_RC'
--select * from [dbo].[GetRegisterVariable] (N'FORMTEST_RC')


GO