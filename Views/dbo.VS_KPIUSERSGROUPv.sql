﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[VS_KPIUSERSGROUPv]
AS
SELECT 
  KPG_KPIID = A.ROWID
, KPG_USERGROUP = A.GroupID
, KPG_USERGROUP_B = A.GroupID
, KPG_USERGROUPNAME = A.GroupName
, KPG_ISSELECTED = (CASE WHEN KPG_GROUPID IS NULL THEN 'NIE' ELSE 'TAK' END)
FROM (SELECT VS_KPI.ROWID, GroupID, GroupName FROM dbo.VS_KPI (nolock) JOIN dbo.SYGroups ON 1 = 1) A 
	  LEFT JOIN dbo.VS_KPIUSERSGROUP (nolock) ON KPG_GROUPID = A.GroupID AND KPG_KPIID = A.ROWID

GO