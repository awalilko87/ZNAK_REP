SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[PROPERTYVALUESv]
as
select 
	PRV_ROWID
	, PRV_PKID 
	, PRV_PROID 
	, PRV_ENT
	, PRV_UPDATECOUNT
	, PRV_CREATED
	, PRV_UPDATED 
	, PRV_NOTUSED
	, PRV_ERROR
	, PRV_VALUE
	, PRV_NVALUE
	, PRV_DVALUE
	, PRV_VALUE_LIST = 
		case 
			when PRO_TYPE = 'DDL' then CAST ((PRV_VALUE) as nvarchar)
			when PRO_TYPE = 'TXT' then CAST ((PRV_VALUE) as nvarchar)
			when PRO_TYPE = 'NTX' then CAST ((cast(isnull(PRV_NVALUE, nullif(replace(PRV_VALUE, ',', '.'),'')) as numeric(8,2))) as nvarchar)
			when PRO_TYPE = 'DTX' then convert (nvarchar(10),(isnull(PRV_DVALUE, nullif(PRV_VALUE,''))),121)
		end 
	, PRV_TOSEND
from PROPERTYVALUES PV (nolock)  
join PROPERTIES (nolock) on PRO_ROWID = PRV_PROID
GO