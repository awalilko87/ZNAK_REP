SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[DOC_UPLOAD_AUDITv]
as
select 
AuditID
,FieldName
,UserID
,DateWhen
,OldValue
,NewValue
,TableRowID
,SystemID
,Oper
,adt.LastUpdate
, OBJ_CODE
from VS_AUDIT adt
--left join DOCENTITIES on TableRowid = DAE_DOCUMENT
left join OBJ on ROWID = OBJ_CODE
--left join SYFILES fil on DAE_DOCUMENT = fil.FILEID2
where adt.TableName = 'DOCENTITIES'
GO