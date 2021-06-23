SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[GetDOCLink](@p_FID nvarchar(30), @p_FIELDID nvarchar(50), @p_ENT nvarchar(10), @p_PK1 nvarchar(30), @p_PK2 nvarchar(30), @p_PK3 nvarchar(30), @p_UserID nvarchar(30))
returns nvarchar(max)
as
begin
	declare @v_LangID nvarchar(10)
	declare @v_LINK nvarchar(max)
	declare @v_DOCFID nvarchar(50)
	declare @v_WIDTH nvarchar(5)
	declare @v_HEIGHT nvarchar(5)
	
	set @v_DOCFID = case @p_FIELDID 
	when 'TLB_DOCUPLOAD' then 'DOC_UPLOAD' 
	when 'TLB_ADDEXISTS' then 'DOC_ADDEXIST' 
	when 'TLB_ADDEXISTS_MULTI' then 'DOC_ADDEXIST_MULTI' 
	else '' end
	
	select
		 @v_WIDTH = pWidth
		,@v_HEIGHT = pHeight
	from dbo.VS_Forms(nolock)
	where FormID = @v_DOCFID
	
	select @v_LangID = LangID from dbo.SYUsers(nolock) where UserID = @p_UserID
	
	select @v_LINK = '<input class="e2-button e2-button-120" onclick="javascript:Simple_PopupWithoutReturnValue('''
					+dbo.VS_EncryptLink('/Forms/SimplePopup2.aspx?FID='+@v_DOCFID+'&A='+isnull(@p_FIELDID,'')+'&ENTITY='+isnull(@p_ENT,'')+'&PK1='+isnull(@p_PK1,'')
					+'&PK2='+isnull(@p_PK2,'')+'&PK3='+isnull(@p_PK3,''))+''','+@v_WIDTH+','+@v_HEIGHT
					+');" type="button" value="'+isnull(nullif(l.GridColCaption,''),f.GridColCaption)+'">'
    
	from dbo.VS_FormFields f(nolock)
	left join dbo.VS_LangMsgs l(nolock) on l.LangID = @v_LangID and ControlID = FieldID and ObjectType = 'FIELD' and ObjectID = FormID
	where FormID = @p_FID and FieldID = @p_FIELDID
	
	return @v_LINK
end
GO