SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[SAPO_ZWFOT12LNv]
as

select 
	INVNR_NAZWA = isnull(OT12LN_INVNR_NAZWA,''),
	CHAR_SKLAD = isnull(OT12LN_CHAR_SKLAD,''),
	WART_ELEME = convert(decimal(30,2),Replace(convert(nvarchar,OT12LN_WART_ELEME),',','.')), 
	ANLN1 = isnull(OT12LN_ANLN1,''),
	ANLN2 = isnull(OT12LN_ANLN2,''),
	ZMT_OBJ_CODE = isnull(OT12LN_ZMT_OBJ_CODE,''),
	OT12LN_ROWID,
	OT12LN_ZMT_ROWID,
	OT12LN_OT12ID,
	OT12LN_LP = row_number() over(partition by OT12LN_OT12ID order by case when OBJ_ROWID = OBJ_PARENTID then 0 else 1 end, OBJ_CODE,OT12LN_INVNR_NAZWA asc)
from dbo.SAPO_ZWFOT12LN (nolock) 
	join dbo.ZWFOTLN (nolock) on OTL_ROWID = OT12LN_ZMT_ROWID
	left join dbo.OBJ (nolock) on OBJ.OBJ_ROWID = OTL_OBJID  
where
	OTL_NOTUSED = 0
GO