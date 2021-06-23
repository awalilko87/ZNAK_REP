SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[MAILRECIPIENTSv]  
as  
select  
 ROWID,  
 MAIS_LP = row_number() over (partition by 1 order by MAIR_MAISID),  
 MAIR_MAISID,  
 MAIR_MAIS = (select MAIS_ENT + ' - ' + isnull(MAIS_TYPE,'')+ ' - ' + MAIS_STATUS from mailsettings WHERE ROWID = MAIR_MAISID),  
 MAIR_EMPID,  
 MAIR_EMP = (select EMP_CODE + ' - ' + EMP_DESC from EMP (nolock) where ROWID = MAIR_EMPID ),  
 MAIR_MAIL = (select EMP_EMAIL from EMP (nolock) where ROWID = MAIR_EMPID ),  
 MAIR_QUERY,  
 MAIR_ENT = (select MAIS_ENT from mailsettings WHERE ROWID = MAIR_MAISID),  
 MAIR_TYPE = isnull((select MAIS_TYPE from mailsettings WHERE ROWID = MAIR_MAISID),''),  
 MAIR_STATUS = (select MAIS_STATUS from mailsettings WHERE ROWID = MAIR_MAISID)  
from MAILRECIPIENTS  
GO