SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create view [dbo].[PO_REPORTv]
as
select
POT_ROWID
,POT_CODE
,STN_DESC
,POT_DESC
,POT_CREDATE
,POT_STATUS_DESC = (select STA_DESC from dbo.STA where STA_CODE = POT_STATUS)
,POT_CREUSER_DESC = UserName
from objtechprot
left join station on STN_ROWID = POT_STNID
join SyUSers on POT_CREUSER = UserID
GO