SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create view [dbo].[DOC_POPv] 
as
select distinct
	 [FileID2]
	,[FileName]
	,[Description]
	,DAE_TYPE
	,DAE_TYPE_DESC = (select top 1 TYP_DESC from dbo.TYP (nolock) where TYP_ENTITY = 'DAE' and TYP_CODE =DAE_TYPE)
	--,DAE_TYPE2
	--,DAE_TYPE2_DESC = (select top 1 TYP_DESC from dbo.TYP2 (nolock) where TYP_CODE =DAE_TYPE2 and TYP_TYP1ID = (select top 1 TYP.ROWID from dbo.TYP (nolock) where TYP_ENTITY = 'DAE' and TYP_CODE =DAE_TYPE))
	--,DAE_TYPE3
	--,DAE_TYPE3_DESC = (select top 1 TYP_DESC from dbo.TYP3 (nolock) where TYP_CODE =DAE_TYPE3 and TYP_TYP2ID = (select top 1 TYP2.ROWID from dbo.TYP2 (nolock) where TYP_CODE =DAE_TYPE2 and TYP_TYP1ID = (select top 1 TYP.ROWID from dbo.TYP (nolock) where TYP_ENTITY = 'DAE' and TYP_CODE =DAE_TYPE)))	 
	,DAE_TYPE + isnull('_' + DAE_TYPE2,'') + isnull('_' + DAE_TYPE3,'') as DAE_TYPES
from dbo.SYFiles (nolock)
left join DOCENTITIES(nolock) on FILEID2 = DAE_DOCUMENT
where FilePath = '/Files'

GO