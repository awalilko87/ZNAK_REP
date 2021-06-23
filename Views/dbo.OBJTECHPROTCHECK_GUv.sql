SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE view [dbo].[OBJTECHPROTCHECK_GUv]
as
select
	POC_ROWID,
	POC_POTID,
	case
		when POC_GROUPID = 'RKB' then 'GCB'
		else POC_GROUPID
	end as POC_GROUPID,
	case
		when POC_GROUPID = 'RKB' then 'Grupa Wsparcia Użytkowników GCB'
		else GroupName 
	end as GROUP_DESC,
	POC_CHECKUSER,
	POC_CHECKUSER_DESC = dbo.UserName(POC_CHECKUSER),
	POC_CHECKDATE,
	POC_CREUSER,
	POC_CREUSER_DESC = dbo.UserName(POC_CREUSER),
	POC_CREDATE,
	POC_UPDUSER,
	POC_UPDUSER_DESC = dbo.UserName(POC_UPDUSER),
	POC_UPDDATE
	
from dbo.OBJTECHPROTCHECK_GU (nolock) 
	join dbo.SYGroups (nolock) on GroupID = POC_GROUPID




GO