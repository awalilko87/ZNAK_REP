SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE view [dbo].[OBJTECHPROTCHECKv]
as
select
	POC_ROWID,
	POC_POTID,
	POC_OBGID,
	POC_OBG = OBG_CODE,
	POC_OBG_DESC = OBG_DESC,
	POC_CHECKUSER,
	POC_CHECKUSER_DESC = dbo.UserName(POC_CHECKUSER),
	POC_CHECKDATE,
	POC_CREUSER,
	POC_CREUSER_DESC = dbo.UserName(POC_CREUSER),
	POC_CREDATE,
	POC_UPDUSER,
	POC_UPDUSER_DESC = dbo.UserName(POC_UPDUSER),
	POC_UPDDATE
	
from dbo.OBJTECHPROTCHECK (nolock) 
	join dbo.OBJGROUP (nolock) on OBG_ROWID = POC_OBGID

GO