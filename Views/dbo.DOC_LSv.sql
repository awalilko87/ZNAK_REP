SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create view [dbo].[DOC_LSv] 
as
select 
 [FileID2]
,[FileName]
,[Description]
,'<a href="'+ dbo.VS_EncryptLink('/GetFile.aspx?O=G&P=Files&ID='+FileID2)+'" target="_blank">'+isnull(FileName,'')+'</a>' as DAE_DESC
,DAE_TYPE = isnull(DAE_TYPE,'NOTYPE')
,DAE_TYPE_DESC = typ1.DES_TEXT
,DAE_TYPE2
,DAE_TYPE2_DESC = typ2.DES_TEXT
,DAE_TYPE3
,DAE_TYPE3_DESC = typ3.DES_TEXT
,DAE_TYPES = DAE_TYPE + isnull('_' + DAE_TYPE2,'') + isnull('_' + DAE_TYPE3,'')
,DAE_RELATION = (left (dae_code, charindex('#',dae_code)-1))
,DAE_ENTITY 
,DAE_ENTITYDESC = ent.DES_TEXT
,DAE_CREDATE
,DAE_CREUSER
,DAE_CREUSERDESC = dbo.UserName(DAE_CREUSER)
,DAE_LANGID = LangID
from dbo.SYFiles (nolock)
left join DOCENTITIES(nolock) on FILEID2 = DAE_DOCUMENT
cross join VS_Langs   
left join dbo.DESCRIPTIONS_DAEv typ1(nolock) on typ1.DES_TYPE = 'TYP1' and typ1.DES_CODE = DAE_TYPE and typ1.DES_LANGID = LangID  
left join dbo.DESCRIPTIONS_DAEv typ2(nolock) on typ2.DES_TYPE = 'TYP2' and typ2.DES_CODE = DAE_TYPE+'#'+DAE_TYPE2 and typ2.DES_LANGID = LangID  
left join dbo.DESCRIPTIONS_DAEv typ3(nolock) on typ3.DES_TYPE = 'TYP3' and typ3.DES_CODE = DAE_TYPE+'#'+DAE_TYPE2+'#'+DAE_TYPE3 and typ3.DES_LANGID = LangID
left join dbo.DESCRIPTIONS ent(nolock) on ent.DES_ENTITY = 'ENT' and ent.DES_TYPE = 'DESC' and ent.DES_CODE = DAE_ENTITY and ent.DES_LANGID = LangID 
where FilePath = 'Files' and TableName in ('ZMT', 'InforEAM')

GO