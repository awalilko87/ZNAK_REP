SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[VS_Auditv]
as
select 
AuditID
,RowID
--,OBJ_CODE = (select OBJ_CODE from dbo.OBJ where OBJ_ROWID = ad.RowID)
,TableName
,FieldName = 'STATUS'
,OldValue
,OldValueDesc = (select STA_DESC from dbo.STA where STA_CODE = ad.OldValue)
,ad.NewValue
,NewValueDesc = (select STA_DESC from dbo.STA where STA_CODE = ad.NewValue)
,DateWhen
,UserID = case when ad.UserID = 'NO_User' then 'Zmiana systemowa' else (select UserName from SYUsers usr where usr.UserID = ad.UserID) end
from
Vs_Audit ad
where TableName = 'OBJ'
and FieldName = 'OBJ_STATUS'
GO