SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create view [dbo].[DOC_LSpopv]
as
select 
 [FileID2]
,[FileName]
,[Description]
,DAE_DESC = '<a href="'+ dbo.VS_EncryptLink('/GetFile.aspx?O=G&P=Files&ID='+FileID2)+'" target="_blank">'+isnull(FileName,'')+'</a>'
,DAE_TYPE
,DAE_TYPE_DESC = typ1.DES_TEXT
,DAE_TYPE2
,DAE_TYPE2_DESC = typ2.DES_TEXT
,DAE_TYPE3
,DAE_TYPE3_DESC = typ3.DES_TEXT
,DAE_TYPES = DAE_TYPE + isnull('_' + DAE_TYPE2,'') + isnull('_' + DAE_TYPE3,'')
,DAE_LANGID = LangID
from dbo.SYFiles (nolock)
left join (select distinct
			 DAE_DOCUMENT
			,DAE_TYPE = isnull(DAE_TYPE,'NOTYPE')
			,DAE_TYPE2
			,DAE_TYPE3
		from DOCENTITIES(nolock))doc on DAE_DOCUMENT = FILEID2
cross join VS_Langs   
left join dbo.DESCRIPTIONS_DAEv typ1(nolock) on typ1.DES_TYPE = 'TYP1' and typ1.DES_CODE = DAE_TYPE and typ1.DES_LANGID = LangID  
left join dbo.DESCRIPTIONS_DAEv typ2(nolock) on typ2.DES_TYPE = 'TYP2' and typ2.DES_CODE = DAE_TYPE+'#'+DAE_TYPE2 and typ2.DES_LANGID = LangID  
left join dbo.DESCRIPTIONS_DAEv typ3(nolock) on typ3.DES_TYPE = 'TYP3' and typ3.DES_CODE = DAE_TYPE+'#'+DAE_TYPE2+'#'+DAE_TYPE3 and typ3.DES_LANGID = LangID
where FilePath = 'Files' and TableName in ('ZMT', 'InforEAM')

GO