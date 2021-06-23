SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

--select dbo.GetFormHeader ('EVT_ACT','CRA_2014_00060','W realizacji','TESTSWM OBRÓBKA PLASTIKU',null,'MATEO')
CREATE function [dbo].[GetFormHeader] 
(@p_FID nvarchar(50)
,@p_FLD1 nvarchar(100)
,@p_FLD2 nvarchar(100)
,@p_FLD3 nvarchar(100)
,@p_FLD4 nvarchar(100)
,@p_UserID nvarchar(30)
)
returns nvarchar(4000)
as
begin
	declare @v_ret nvarchar(4000)
	declare @v_ret1 nvarchar(4000)
	declare @v_ret2 nvarchar(4000)
	declare @v_ret3 nvarchar(4000)
	declare @v_ret4 nvarchar(4000)
	declare @v_LangID nvarchar(10) 
	declare @FlagBR int
	
	declare @t_hfields table (Panel nvarchar(10), Field nvarchar(60), Descr nvarchar(80)) 
	
	set @v_ret1 = ''
	set @v_ret2 = ''
	set @v_ret3 = ''
	set @v_ret4 = ''
	set @v_ret = ''
	select @v_LangID = dbo.fn_GetLangID(@p_UserID)
	
	insert into @t_hfields
	select panel = 'Panel_' + panel, fh.Fieldid, rv_caption
	from VS_FormHeader fh
	inner join (
		select 
			RV,
			RV_Caption = coalesce(l.Caption,p.caption,f.caption) 
		from [dbo].[GetRegisterVariable] (@p_FID)
		inner join VS_FormFields f on f.Formid = SrcFormID and f.FieldID = SrcFieldID
		left join dbo.VS_LangMsgs l on l.ObjectID = SrcFormID and l.ControlID = SrcFieldID and l.ObjectType = 'FIELD' and l.LangID = @v_LangID
		left join dbo.VS_LangMsgs p on p.ObjectID = SrcFormID and p.ControlID = SrcFieldID and p.ObjectType = 'FIELD' and l.LangID = 'PL')rvt on RV = fh.FieldID
	where fh.FormID = @p_FID
	union
	select panel = 'Panel_' + panel, fh.Fieldid,coalesce(l2.caption,p2.caption,f.caption)
	from VS_FormHeader fh
	inner join VS_FormFields f on f.Formid = fh.FormID and '@'+f.FieldID = fh.FieldID
	left join VS_LangMsgs l2  on l2.objectid = fh.FormID and l2.controlid = f.FieldID and l2.ObjectType = 'FIELD' and l2.LangID = @v_LangID
	left join VS_LangMsgs p2  on p2.objectid = fh.FormID and p2.controlid = f.FieldID and p2.ObjectType = 'FIELD' and p2.LangID = 'PL'
	where fh.FormID = @p_FID

	-- fld1
		select 
			@v_ret1 = isnull(v.Caption,Descr)+':<b>&nbsp' + case when isdate(@p_FLD1) = 1 then convert(varchar(10),convert(datetime,@p_FLD1),121) else isnull(@p_FLD1,'') end + '</b>'
		from @t_hfields
		left join VS_LangMSGS v on ObjectID = @p_FID and ObjectType='HEAD' and ControlID = Panel and LangID=@v_LangID
		where Panel = 'Panel_A'

	-- fld2
		select 
			@v_ret2 = isnull(v.Caption,Descr)+':<b>&nbsp' + case when isdate(@p_FLD2) = 1 then convert(varchar(10),convert(datetime,@p_FLD2),121) else isnull(@p_FLD2,'') end + '</b>'
		from @t_hfields
		left join VS_LangMSGS v on ObjectID = @p_FID and ObjectType='HEAD' and ControlID = Panel and LangID=@v_LangID
		where Panel = 'Panel_B'

	-- fld3
		select 
			@v_ret3 = isnull(v.Caption,Descr)+':<b>&nbsp' + case when isdate(@p_FLD3) = 1 then convert(varchar(10),convert(datetime,@p_FLD3),121) else isnull(@p_FLD3,'') end + '</b>'
		from @t_hfields
		left join VS_LangMSGS v on ObjectID = @p_FID and ObjectType='HEAD' and ControlID = Panel and LangID=@v_LangID
		where Panel = 'Panel_C'

	-- fld4
		select 
			@v_ret4 = isnull(v.Caption,Descr)+':<b>&nbsp' + case when isdate(@p_FLD4) = 1 then convert(varchar(10),convert(datetime,@p_FLD4),121) else isnull(@p_FLD4,'') end + '</b>'
		from @t_hfields
		left join VS_LangMSGS v on ObjectID = @p_FID and ObjectType='HEAD' and ControlID = Panel and LangID=@v_LangID
		where Panel = 'Panel_D'
	
	select @v_ret1 = ISNULL(@v_ret1,''), @v_ret2 = ISNULL(@v_ret2,''), @v_ret3 = ISNULL(@v_ret3,''), @v_ret4 = ISNULL(@v_ret4,'')

	--zawijanie tekstu w kontrolce
	/*if len(@v_ret1+'    '+@v_ret2)>=80
	begin
		set @v_ret=@v_ret1+'<br/>'+@v_ret2
		set @FlagBR=1
	end
	else 
	begin
		set @v_ret=@v_ret1+'&nbsp&nbsp&nbsp&nbsp'+@v_ret2
		set @FlagBR=0
	end

	if isnull(@FlagBR,0) = 1 
	begin
		if len(@v_ret2+'    '+@v_ret3)>=80
			set @v_ret=@v_ret+'<br/>'+@v_ret3
		else
			set @v_ret=@v_ret+'&nbsp&nbsp&nbsp&nbsp'+@v_ret3
	end
	else 
	begin
		set @v_ret=@v_ret+'<br/>'+@v_ret3
		set @FlagBR=1
	end

	if isnull(@FlagBR,0) = 1 
	begin
		if len(@v_ret3+'    '+@v_ret4)>=80
			set @v_ret=@v_ret+'<br/>'+@v_ret4
		else
			set @v_ret=@v_ret+'&nbsp&nbsp&nbsp&nbsp'+@v_ret4
	end*/
	
	set @v_ret = @v_ret1 + '&nbsp&nbsp&nbsp' + @v_ret2 + '&nbsp&nbsp&nbsp' + '<br>' + @v_ret3 + '&nbsp&nbsp&nbsp' + @v_ret4

return @v_ret

end

GO