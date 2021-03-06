SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[SAPO_ZWFOT33LNv]
as

select 
	LP = OT33LN_LP,
	BUKRS = OT33LN_BUKRS,
	ANLN1 = isnull(OT33LN_ANLN1,''),
	TXT50 = isnull(OT33LN_TXT50,''),
	UZASADNIENIE = isnull(OT33LN_UZASADNIENIE,''),
	DT_WYDANIA = OT33LN_DT_WYDANIA,
	MPK_WYDANIA = isnull(left(OT33LN_MPK_WYDANIA,10),''),
	GDLGRP = isnull(left(OT33LN_GDLGRP,8),''),
 	OT33LN_ROWID,
	OT33LN_ZMT_ROWID,
	OT33LN_OT33ID 
from dbo.SAPO_ZWFOT33LN (nolock) 
	join dbo.ZWFOTLN (nolock) on OTL_ROWID = OT33LN_ZMT_ROWID
where
	OTL_NOTUSED = 0
	 
 
GO