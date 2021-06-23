SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[DESCRIPTIONS_STAv]
as
select 
 DES_ENTITY = STA_ENTITY
,DES_TYPE = isnull(DES_TYPE,'STAT')
,DES_LANGID = ISNULL(DES_LANGID,LangID)
,DES_CODE = STA_CODE
,DES_TEXT
from dbo.DESCRIPTIONS(nolock)
right join (select 
				 STA_ENTITY
				,STA_CODE
				,LangID 
			from dbo.STA(nolock)
			cross join dbo.VS_Langs(nolock))sl on STA_ENTITY = DES_ENTITY and DES_CODE = STA_CODE and DES_LANGID = LangID
where isnull(DES_TYPE,'STAT') = 'STAT'

GO