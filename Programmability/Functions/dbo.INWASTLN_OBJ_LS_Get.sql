SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[INWASTLN_OBJ_LS_Get](@p_CCDID int, @p_KL5ID int, @p_UserID nvarchar(30))
returns table
as
return
select
 o.OBJ_ROWID
,o.OBJ_CODE
,o.OBJ_DESC
,OBJ_GROUP_DESC = OBG_DESC
,OBJ_LP = (row_number() over(order by op.OBJ_CODE, o.OBJ_CODE))
,OBJ_PARENT = case when o.OBJ_ROWID = o.OBJ_PARENTID then '' else op.OBJ_CODE end
,o.OBJ_PM
,OBJ_PSP = PSP_CODE
,o.OBJ_SERIAL
,OBJ_TYPE_DESC = (select TYP_DESC from dbo.TYP(nolock) where TYP_ENTITY = 'OBJ' and TYP_CODE = o.OBJ_TYPE)
,o.OBJ_TYPE2
,OBJ_ASSET = (select top 1  AST_CODE + ' - '+ AST_SUBCODE from dbo.ASSET (nolock) join dbo.OBJASSET (nolock) on AST_ROWID = OBA_ASTID where OBA_OBJID = o.OBJ_ROWID order by AST_SUBCODE)
,OBJ_CCDID = STN_CCDID
,OBJ_KL5ID = STN_KL5ID
from dbo.OBJ o
inner join dbo.OBJSTATION (nolock) on OSA_OBJID = o.OBJ_ROWID
inner join dbo.STATION (nolock) on STN_ROWID = OSA_STNID and STN_CCDID = @p_CCDID and STN_KL5ID = @p_KL5ID
left join dbo.OBJGROUP on OBG_ROWID = OBJ_GROUPID
left join dbo.OBJ op on op.OBJ_ROWID = o.OBJ_PARENTID
left join dbo.PSP (nolock) on PSP_ROWID = op.OBJ_PSPID
where isnull(o.OBJ_NOTUSED, 0) = 0
GO