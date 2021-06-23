SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE  view [dbo].[SAPO_ZWFOT33CHARv]
as
select 

	LP = isnull(OT33CHAR_LP,0),
	ANLN2 = isnull(OT33CHAR_ANLN2,''),
	METAL = isnull(OT33CHAR_METAL,''),
	KATALIZATOR = isnull(OT33CHAR_KATALIZATOR,''),
	METAL_OPIS = isnull(OT33CHAR_METAL_OPIS,''),
	WSK_IL_METAL = isnull(OT33CHAR_WSK_IL_METAL,''),
	MENGE = convert(decimal(13,2),Replace(convert(nvarchar,OT33CHAR_MENGE),',','.')), 
	MEINS = isnull(OT33CHAR_MEINS,''),
	RODZ_IL_METAL = isnull(OT33CHAR_RODZ_IL_METAL,''),
	WSK_KW_METAL = isnull(OT33CHAR_WSK_KW_METAL,''),
	KW_METAL = isnull(OT33CHAR_KW_METAL,0.00),
	RODZ_KW_METAL = isnull(OT33CHAR_RODZ_KW_METAL,''),
	ZRODLO = isnull(OT33CHAR_ZRODLO,''),
	OPIS = isnull(OT33CHAR_OPIS,''),
	AEDAT = isnull(OT33CHAR_AEDAT,''),
	AEZET = isnull(OT33CHAR_AEZET,'00:00'),
	AENAM = isnull(OT33CHAR_AENAM,''),
	ZAL = isnull(OT33CHAR_ZAL,''),
	ILOSC_NOWA = convert(decimal(13,2),Replace(convert(nvarchar,OT33CHAR_ILOSC_NOWA),',','.')), 
	KW_NOWA = convert(decimal(13,2),Replace(convert(nvarchar,OT33CHAR_KW_NOWA),',','.')), 
	OT33CHAR_ROWID,
	OT33CHAR_ZMT_ROWID,
	OT33CHAR_OT33ID
	
from dbo.SAPO_ZWFOT33CHAR (nolock) 
	where OT33CHAR_ROWID in 
		(select   
			max(X1.OT33CHAR_ROWID)
		from dbo.SAPO_ZWFOT33CHAR (nolock) X1
		group by X1.OT33CHAR_OT33ID)
	  
GO