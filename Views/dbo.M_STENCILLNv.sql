SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[M_STENCILLNv]
as
select
  STS_ROWID  
, STL_PARENTID 
, STS_SETTYPE 
, STS_SETTYPEDESC --= STT_DESC 
, STS_SIGNED
, STS_SIGNLOC
, STS_CODE
, STS_DESC
, NEWID() as STS_ID -- unikalne STS_ID potrzebne do mobile (rowguid)
, STS_GROUP --= OBG_CODE
, STS_GROUP_DESC --= OBG_DESC
, STS_QTY = 0
, STL_SINID = null
, STL_SINCODE = null
, STL_PAR_DESC = (select top 1 STS_DESC from STENCILv where STL_PARENTID = STS_ROWID)
, STL_UPDDATE = CAST ('1900-01-01' as datetime)

from dbo.[STENCILLNv] (nolock)
 
 union

select 
STS_ROWID  
, STL_PARENTID=STS_ROWID
, STS_SETTYPE 
, STS_SETTYPEDESC --= STT_DESC 
, STS_SIGNED
, STS_SIGNLOC
, STS_CODE
, STS_DESC
, NEWID() as STS_ID -- unikalne STS_ID potrzebne do mobile (rowguid)
, STS_GROUP --= OBG_CODE
, STS_GROUP_DESC --= OBG_DESC
, STS_QTY = 0
, STL_SINID = null
, STL_SINCODE = null
, STL_PAR_DESC = STS_DESC
, STL_UPDDATE = CAST ('1900-01-01' as datetime)

from dbo.[STENCILv] (nolock)
where not exists (select 1 from [STENCILLNv] where [STENCILv].STS_ROWID = [STENCILLNv].STL_PARENTID)


GO