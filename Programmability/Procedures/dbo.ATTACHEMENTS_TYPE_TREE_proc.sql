SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ATTACHEMENTS_TYPE_TREE_proc](
@p_UserID nvarchar(30)
)
as
begin
	declare @v_LangID nvarchar(10)
	declare @v_TYP1_DESC nvarchar(80)
	declare @v_TYP2_DESC nvarchar(80)
	declare @v_TYP3_DESC nvarchar(80)
	declare @v_BRAK nvarchar(80)
	declare @v_WSZYSTKIE nvarchar(80)
	
	select @v_LangID = LangID from dbo.SYUsers(nolock) where UserID = @p_UserID
	select 
		@v_TYP1_DESC = ISNULL(l.Caption,ff.Caption)
	from dbo.VS_FormFields ff(nolock)
	left join VS_LangMsgs l(nolock) on ObjectType = 'FIELD' and ControlID = FieldID and ObjectID = FormID and l.LangID = @v_LangID
	where FormID = 'DOC_LS' and FieldID = 'LBL_TYPE'
	select 
		@v_TYP2_DESC = ISNULL(l.Caption,ff.Caption)
	from dbo.VS_FormFields ff(nolock)
	left join VS_LangMsgs l(nolock) on ObjectType = 'FIELD' and ControlID = FieldID and ObjectID = FormID and l.LangID = @v_LangID
	where FormID = 'DOC_LS' and FieldID = 'LBL_TYPE2'
	select 
		@v_TYP3_DESC = ISNULL(l.Caption,ff.Caption)
	from dbo.VS_FormFields ff(nolock)
	left join VS_LangMsgs l(nolock) on ObjectType = 'FIELD' and ControlID = FieldID and ObjectID = FormID and l.LangID = @v_LangID
	where FormID = 'DOC_LS' and FieldID = 'LBL_TYPE3'
	select 
		@v_BRAK = ISNULL(l.Caption,ff.Caption)
	from dbo.VS_FormFields ff(nolock)
	left join VS_LangMsgs l(nolock) on ObjectType = 'FIELD' and ControlID = FieldID and ObjectID = FormID and l.LangID = @v_LangID
	where FormID = 'DOC_LS' and FieldID = 'LBL_BRAK'
	select 
		@v_WSZYSTKIE = ISNULL(l.Caption,ff.Caption)
	from dbo.VS_FormFields ff(nolock)
	left join VS_LangMsgs l(nolock) on ObjectType = 'FIELD' and ControlID = FieldID and ObjectID = FormID and l.LangID = @v_LangID
	where FormID = 'DOC_LS' and FieldID = 'LBL_WSZYSTKIE'


	select null AS DAE_PARENT, 'ALL' as DAE_CHILD, '<input TYPE="image" SRC="/Images/16x16/Document.png"><b>'+@v_TYP1_DESC+':</b> ['+@v_WSZYSTKIE+']' as DAE_DESC 
	union all
	select 'ALL' AS DAE_PARENT, 'NOTYPE' as DAE_CHILD, '<input TYPE="image" SRC="/Images/16x16/Document.png"><b>'+@v_TYP1_DESC+':</b> ['+@v_BRAK+']' as DAE_DESC 
	union all
	select 'ALL' AS DAE_PARENT, TYP_CODE as DAE_CHILD, '<input TYPE="image" SRC="/Images/16x16/Document.png"><b>'+@v_TYP1_DESC+':</b> ['+DES_TEXT+']' as DAE_DESC 
	from TYP 
	inner join dbo.DESCRIPTIONS_DAEv(nolock) on DES_TYPE = 'TYP1' and DES_CODE = TYP_CODE and DES_LANGID = @v_LangID
	where TYP_ENTITY = 'DAE'
	union all
	select TYP.TYP_CODE AS DAE_PARENT, TYP.TYP_CODE + '_' + TYP2_CODE as DAE_CHILD,  '<input TYPE="image" SRC="/Images/16x16/Document.png"><b>'+@v_TYP2_DESC+':</b> ['+DES_TEXT+']' as DAE_DESC  
	from TYP 
	inner join dbo.TYP2 on TYP2_ROWID = TYP2_TYP1ID 
	inner join dbo.DESCRIPTIONS_DAEv(nolock) on DES_TYPE = 'TYP2' and DES_CODE = typ.TYP_CODE+'#'+ TYP2_CODE and DES_LANGID = @v_LangID
	where TYP_ENTITY = 'DAE'
	union all
	select TYP.TYP_CODE + '_' + TYP2_CODE AS DAE_PARENT, TYP.TYP_CODE + '_' + TYP2_CODE + '_' + TYP3_CODE as DAE_CHILD,  '<input TYPE="image" SRC="/Images/16x16/Document.png"><b>'+@v_TYP3_DESC+':</b> ['+DES_TEXT+']' as DAE_DESC  
	from TYP 
	inner join TYP2 on TYP_ROWID = TYP2_TYP1ID
	inner join TYP3 on TYP2_ROWID = TYP3_TYP2ID
	inner join dbo.DESCRIPTIONS_DAEv(nolock) on DES_TYPE = 'TYP3' and DES_CODE = typ.TYP_CODE+'#'+TYP2_CODE+'#'+TYP3_CODE and DES_LANGID = @v_LangID
	where TYP_ENTITY = 'DAE'
	--union all
	--	select 'NOTYPE' AS DAE_PARENT, DAE_DOCUMENT as DAE_CHILD, /*'[' + FileID2+ ']' + */' <a href="GetFile.aspx?O=G&amp;P=Files&amp;ID='+FileID2+'" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DAE_DESC 
	--	from dbo.DOCENTITIES 
	--		inner join dbo.Syfiles (nolock) on [FileID2] = DAE_DOCUMENT 
	--	where DAE_TYPE is null 
	--union  all
	--	select distinct DAE_TYPE AS DAE_PARENT, DAE_DOCUMENT as DAE_CHILD,/* '[' + FileID2+ ']' + */' <a href="GetFile.aspx?O=G&amp;P=Files&amp;ID='+FileID2+'" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DAE_DESC 
	--	from dbo.DOCENTITIES 
	--		inner join dbo.Syfiles (nolock) on [FileID2] = DAE_DOCUMENT 
	--	where DAE_TYPE is not null and DAE_TYPE2 is null
	--union  all
	--	select distinct DAE_TYPE + '_' + DAE_TYPE2 AS DAE_PARENT, DAE_DOCUMENT as DAE_CHILD,/* '[' + FileID2+ ']' + */' <a href="GetFile.aspx?O=G&amp;P=Files&amp;ID='+FileID2+'" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DAE_DESC 
	--	from dbo.DOCENTITIES 
	--		inner join dbo.Syfiles (nolock) on [FileID2] = DAE_DOCUMENT 
	--	where DAE_TYPE is not null and DAE_TYPE2 is not null and DAE_TYPE3 is null
	--union  all
	--	select distinct DAE_TYPE + '_' + DAE_TYPE2 + '_' + DAE_TYPE3 AS DAE_PARENT, DAE_DOCUMENT as DAE_CHILD,/* '[' + FileID2+ ']' + */' <a href="GetFile.aspx?O=G&amp;P=Files&amp;ID='+FileID2+'" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DAE_DESC 
	--	from dbo.DOCENTITIES 
	--		inner join dbo.Syfiles (nolock) on [FileID2] = DAE_DOCUMENT 
	--	where DAE_TYPE is not null and DAE_TYPE2 is not null and DAE_TYPE3 is not null
end


GO