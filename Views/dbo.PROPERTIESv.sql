﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[PROPERTIESv]
as 
select 
	  PRO_ROWID
	, PRO_CODE
	, PRO_TYPE
	, PRO_TEXT
	, PRO_MIN
	, PRO_MAX
	, PRO_UPDATECOUNT
	, PRO_CREATED
	, PRO_UPDATED
	, PRO_TYPE_DESC
	, PRO_SQLTYPE
	, PRO_SQLSIZE
	, PRO_NOTUSED
	, PRO_PM_KLASA
	, PRO_PM_CECHA
	, count(PRL_ROWID) as PRO_PRL_COUNT
from PROPERTIES (nolock)
	left join PROPERTIES_LIST (nolock) on PRL_PROID = PRO_ROWID
group by 
	  PRO_ROWID	
	, PRO_CODE
	, PRO_TYPE
	, PRO_TEXT
	, PRO_MIN
	, PRO_MAX
	, PRO_UPDATECOUNT
	, PRO_CREATED
	, PRO_UPDATED
	, PRO_TYPE_DESC
	, PRO_SQLTYPE
	, PRO_SQLSIZE
	, PRO_NOTUSED
	, PRO_PM_KLASA
	, PRO_PM_CECHA
	

GO