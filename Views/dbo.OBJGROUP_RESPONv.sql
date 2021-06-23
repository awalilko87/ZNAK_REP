SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create   view [dbo].[OBJGROUP_RESPONv]
as
select 
 OBG_ROWID
,OBG_CODE
,GroupID 
from dbo.PRVOBJ p
inner join dbo.SYGroups gu on gu.GroupID = p.PVO_GROUPID
inner join dbo.OBJGROUP on OBG_ROWID = PVO_OBGID
where right(GroupID,1) <> 'A' and GroupID not in ('BRS')
GO