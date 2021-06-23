SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[GetRepHeadline] (@p_ReportID nvarchar(30), @p_LangID nvarchar(30))
returns nvarchar(max)
as
begin
	declare @return nvarchar(max)
	
	select @return = case when rep.LangID = 'PL' and lm.Caption is null then rep.ReportName else lm.Caption end
	from dbo.VS_LangMsgs lm(nolock)
	right join (select 
					 ReportID
					,ReportCaption 
					,ReportName 
					,LangID
				from dbo.SYReportsv(nolock)
				cross join dbo.VS_Langs(nolock)) rep on 'CR_'+rep.ReportID = ObjectID and rep.LangID = lm.LangID and ControlID = '' and lm.ObjectType = 'REPNAME'
	left join VS_FormFields ff on FormID = 'SYS_REPORTS' and FieldID = 'ReportName'
	left join VS_LangMsgs lm1 on lm1.ObjectID = 'SYS_REPORTS' and lm1.ControlID = 'ReportName' and lm1.ObjectType = 'FIELD' and lm1.LangID = rep.LangID
	where isnull(lm.ObjectType,'REPNAME') = 'REPNAME'
	and ReportID= @p_ReportID and rep.LangID = @p_LangID
	
	set @return = isnull(@return,'')
	
	return @return 
end
GO