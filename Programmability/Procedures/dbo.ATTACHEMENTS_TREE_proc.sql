SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

--exec ATTACHEMENTS_TREE_proc
CREATE procedure [dbo].[ATTACHEMENTS_TREE_proc]
as
begin


		select NULL AS DAE_PARENT, 'NOTYPE' as DAE_CHILD, '<input TYPE="image" SRC="/Images/16x16/Copy.png"> <b>Typ: </b>[Brak]' as DAE_DESC 
	union all
		select NULL AS DAE_PARENT, TYP_CODE as DAE_CHILD, '<input TYPE="image" SRC="/Images/16x16/Copy.png"> <b>Typ:</b> ['+TYP_DESC+']' as DAE_DESC from TYP where TYP_ENTITY = 'DAE'
	union all
		select TYP.TYP_CODE AS DAE_PARENT, TYP.TYP_CODE + '_' + typ2.TYP2_CODE as DAE_CHILD,  '<input TYPE="image" SRC="/Images/16x16/Copy.png"> <b>Typ2:</b> ['+typ2.TYP2_DESC+']' as DAE_DESC  from TYP 
			join typ2 on TYP2_ROWID = typ2.typ2_typ1id 
			where TYP_ENTITY = 'DAE'
	union all
		select TYP.TYP_CODE + '_' + typ2.TYP2_CODE AS DAE_PARENT, TYP.TYP_CODE + '_' + typ2.TYP2_CODE + '_' + typ3.TYP3_CODE as DAE_CHILD,  '<input TYPE="image" SRC="/Images/16x16/Copy.png"> <b>Typ3:</b> ['+typ3.TYP3_DESC+']' as DAE_DESC  from TYP 
			join typ2 on TYP_ROWID = typ2.typ2_typ1id
			join typ3 on TYP2_ROWID = typ3.typ3_typ2id
			where TYP_ENTITY = 'DAE'
	union all
		select 'NOTYPE' AS DAE_PARENT, DAE_DOCUMENT as DAE_CHILD, /*'[' + FileID2+ ']' + */' <a href="GetFile.aspx?O=G&amp;P=Files&amp;ID='+FileID2+'" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DAE_DESC 
		from dbo.DOCENTITIES 
			inner join dbo.Syfiles (nolock) on [FileID2] = DAE_DOCUMENT 
		where DAE_TYPE is null 
	union  all
		select distinct DAE_TYPE AS DAE_PARENT, DAE_DOCUMENT as DAE_CHILD,/* '[' + FileID2+ ']' + */' <a href="GetFile.aspx?O=G&amp;P=Files&amp;ID='+FileID2+'" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DAE_DESC 
		from dbo.DOCENTITIES 
			inner join dbo.Syfiles (nolock) on [FileID2] = DAE_DOCUMENT 
		where DAE_TYPE is not null and DAE_TYPE2 is null
	union  all
		select distinct DAE_TYPE + '_' + DAE_TYPE2 AS DAE_PARENT, DAE_DOCUMENT as DAE_CHILD,/* '[' + FileID2+ ']' + */' <a href="GetFile.aspx?O=G&amp;P=Files&amp;ID='+FileID2+'" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DAE_DESC 
		from dbo.DOCENTITIES 
			inner join dbo.Syfiles (nolock) on [FileID2] = DAE_DOCUMENT 
		where DAE_TYPE is not null and DAE_TYPE2 is not null and DAE_TYPE3 is null
	union  all
		select distinct DAE_TYPE + '_' + DAE_TYPE2 + '_' + DAE_TYPE3 AS DAE_PARENT, DAE_DOCUMENT as DAE_CHILD,/* '[' + FileID2+ ']' + */' <a href="GetFile.aspx?O=G&amp;P=Files&amp;ID='+FileID2+'" target="_blank">'+isnull(FileName,'')+'</a>'+(case when isnull(FileName,'') <> isnull(Description,'') then isnull(' '+Description,'') else '' end) as DAE_DESC 
		from dbo.DOCENTITIES 
			inner join dbo.Syfiles (nolock) on [FileID2] = DAE_DOCUMENT 
		where DAE_TYPE is not null and DAE_TYPE2 is not null and DAE_TYPE3 is not null
end

--order [DAE_TYPE] ASC, [DAE_TYPE2] ASC, [DAE_TYPE3] ASC

GO