SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

 --update a set controlsource = 'select org_code from org where org_notused = 0' from vs_formfields a where a.formid = 'SYS_PRVORG' and a.fieldid = 'POR_ORG'
 
CREATE view [dbo].[TYPv] as 
SELECT [TYP_ROWID], [TYP_ENTITY], [TYP_ORG], [TYP_CODE], [TYP_ORDER], [TYP_DESC], [TYP_DEFAULT], [TYP_CLASS], [TYP_NOTUSED], [TYP_COUNT] = (select count(*) from dbo.TYP2 (NOLOCK) where TYP2_TYP1ID = TYP.TYP_ROWID) 
FROM [TYP] (NOLOCK) 
 
GO