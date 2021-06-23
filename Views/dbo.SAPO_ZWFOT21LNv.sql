SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[SAPO_ZWFOT21LNv]
as

select 
 
	ILOSC = isnull(OT21LN_ILOSC,1),
	NZWYP =  isnull(OT21LN_NZWYP,''),
	NR_PRA_UZYTK =  isnull(OT21LN_NR_PRA_UZYTK,''),
	GRUPA = isnull(OT21LN_GRUPA,''),
	SKL_RUCH =  isnull(OT21LN_SKL_RUCH,''),
	MUZYTK =  isnull(OT21LN_MUZYTK,''),
	WART_NAB_PLN = convert(decimal(30,2),Replace(convert(nvarchar,OT21LN_WART_NAB_PLN),',','.')),
	DOSTAWCA = isnull(OT21LN_DOSTAWCA,''), 
	NR_DOW_DOSTAWY = OT21LN_NR_DOW_DOSTAWY, 
	DT_DOSTAWY = isnull(convert(nvarchar(10),OT21LN_DT_DOSTAWY,121),''),
	ANLN1 = isnull(OT21LN_ANLN1,''),
	ANLN2 = isnull(OT21LN_ANLN2,''),
	ZMT_OBJ_CODE = isnull(OT21LN_ZMT_OBJ_CODE,''),
	 
	OT21LN_ROWID,
	OT21LN_ZMT_ROWID,
	OT21LN_OT21ID 
	
from dbo.SAPO_ZWFOT21LN (nolock) 

	join dbo.ZWFOTLN (nolock) on OTL_ROWID = OT21LN_ZMT_ROWID
where
	OTL_NOTUSED = 0
	 

 
GO