﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[STENCILPROPERTIESv]
as 
select 

	ASP_ROWID
	, ASP_PROID 
	, ASP_PRO = PRO_CODE
	, ASP_PRODESC = PRO_TEXT
	, ASP_PROTYPE = PRO_TYPE
	, ASP_ENT
	, ASP_STSID 
	, ASP_UOMID
	, ASP_UOM = UOM_CODE
	, ASP_UOMDESC = UOM_DESC
	, ASP_LIST
	, ASP_REQUIRED
	, ASP_UPDATECOUNT
	, ASP_CREATED
	, ASP_UPDATED
 	, STS_ORG = NULL
	, ASP_VALUE
	, ASP_PM_KLASA = PRO_PM_KLASA
	, ASP_PM_CECHA = PRO_PM_CECHA
from ADDSTSPROPERTIES (nolock)
inner join PROPERTIES (nolock) on PRO_ROWID = ASP_PROID
left join UOM (nolock) on UOM_ROWID = ASP_UOMID
where ASP_ENT = 'OBJ'
GO