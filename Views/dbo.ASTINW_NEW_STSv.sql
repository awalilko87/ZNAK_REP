﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ASTINW_NEW_STSv]
as
select
	AST_ROWID,
	ANO_ROWID,
	ANO_STSID as STSID,
	ANO_CREUSER as CREUSER,
	STS_CODE as STS,
	STS_SETTYPE as SETTYPE, 
	SIA_ASTCODE = AST_CODE,
	SIA_ASTSUBCODE = AST_SUBCODE,
	STN_ROWID as STNID, 
	OBJ_ROWID as [OBJID], 
	OBJ_CODE as OBJ, 
	STN_CODE as STN	
from dbo.ASSET
left join [dbo].[ASTINW_NEW_OBJ] (nolock) on ANO_ASTID = AST_ROWID
left join [dbo].[STENCIL] (nolock) on STS_ROWID = ANO_STSID
left join [dbo].[STATION] (nolock) on STN_CCDID = AST_CCDID and STN_KL5ID = AST_KL5ID
left join [dbo].[OBJ] (nolock) on OBJ_ANOID = ANO_ROWID
GO