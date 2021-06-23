SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[SAPO_ZWFOT42LNv]
as

select 
	[BUKRS] = OT42LN_BUKRS,
	
	[ANLN1] = isnull(OT42LN_ANLN1,''),
	[ANLN2] = isnull(OT42LN_ANLN2,''),
	[KOSTL] =  isnull(OT42LN_KOSTL,''),
	[GDLGRP] = OT42LN_GDLGRP, 
	[ODZYSK] = OT42LN_ODZYSK, 
	[LIKWCZESC] = isnull(OT42LN_LIKWCZESC,''), 
	[PROC] =  isnull(OT42LN_PROC,0), 
	--Jeszcze prośba o pole likwidacja częściowa na pozycji w OT42. Przyjmuje wartość X lub pusty a w wysłanym xml’u jest wartość T.
	--<LIKWCZESC>T</LIKWCZESC> 
	 
	OT42LN_ROWID,
	OT42LN_ZMT_ROWID,
	OT42LN_OT42ID 
from dbo.SAPO_ZWFOT42LN (nolock) 
	join dbo.ZWFOTLN (nolock) on OTL_ROWID = OT42LN_ZMT_ROWID
where
	OTL_NOTUSED = 0
	 
GO