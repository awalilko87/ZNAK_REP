﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOTOBJv]
as
select
 o.OBJ_ROWID
,o.OBJ_CODE
,o.OBJ_DESC
,OBJ_TYPE_DESC = (select TYP_DESC from dbo.TYP where TYP_ENTITY = 'OBJ' and TYP_CODE = o.OBJ_TYPE)
,OBJ_PARENT = p.OBJ_CODE
,OBJ_PARENT_DESC = p.OBJ_DESC
,OBJ_ASSET
,OBJ_STATION_DESC = STN_DESC
,OBJ_GROUP_DESC = OBG_DESC
,OBJ_PSP = PSP_CODE
,o.OBJ_VALUE
from dbo.OBJ o
inner join dbo.OBJGROUP on OBG_ROWID = OBJ_GROUPID
left join dbo.PSP on PSP_ROWID = OBJ_PSPID
left join dbo.OBJ p on p.OBJ_ROWID = o.OBJ_PARENTID and o.OBJ_ROWID <> o.OBJ_PARENTID
left join dbo.OBJSTATION on OSA_OBJID = o.OBJ_ROWID
left join dbo.STATION on STN_ROWID = OSA_STNID
outer apply (select top 1 OBJ_ASSET = AST_CODE+' - '+AST_SUBCODE from dbo.OBJASSETv oa where oa.OBJ_ROWID = o.OBJ_ROWID order by AST_SUBCODE)oast
GO