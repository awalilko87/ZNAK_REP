SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[VS_KPIUSERSv]  
AS  
SELECT  
  KPU_KPIID  
, KPU_USERID  
, KPU_USERID_LIST = (CASE WHEN KPU_ISSELECTED = 'TAK' THEN '<font color= red>'+KPU_USERID+'</font>' ELSE KPU_USERID END)  
, KPU_USERNAME = (CASE WHEN KPU_ISSELECTED = 'TAK' THEN '<font color= red>'+KPU_USERNAME+'</font>' ELSE KPU_USERNAME END)  
, KPU_USERGROUP = (CASE WHEN KPU_ISSELECTED = 'TAK' THEN '<font color= red>'+KPU_USERGROUP+'</font>' ELSE KPU_USERGROUP END)  
, KPU_ISSELECTED = (CASE WHEN KPU_ISSELECTED = 'TAK' THEN '<font color= red>'+KPU_ISSELECTED+'</font>' ELSE KPU_ISSELECTED END)  
FROM  
  (  
 SELECT  
   KPU_KPIID = A.ROWID  
 , KPU_USERID = A.UserID  
 , KPU_USERNAME = A.UserName  
 , KPU_USERGROUP = A.UserGroupID  
 , KPU_ISSELECTED = (CASE WHEN KPU_USERID IS NULL THEN 'NIE' ELSE 'TAK' END)  
 FROM (SELECT VS_KPI.ROWID, UserID, UserName, UserGroupID FROM dbo.VS_KPI (nolock) JOIN dbo.SYUsers ON 1 = 1) A   
   LEFT JOIN dbo.VS_KPIUSERS (nolock) ON KPU_USERID = A.UserID AND KPU_KPIID = A.ROWID  
  ) tab  

GO