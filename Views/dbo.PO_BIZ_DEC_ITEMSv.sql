SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[PO_BIZ_DEC_ITEMSv]
as
select 
/*LP							*/ BII_LP = row_number() over (partition by BII_BIZID order by OBJ_CODE)
/*Id stacji paliw				*/,BII_STNID
/*Numer stacji paliw			*/,BII_STN = (select STN_CODE from dbo.STATION where STN_ROWID = BII_STNID)
/*Kod obiektu					*/,BII_OBJ = OBJ_CODE
/*Nazwa obiektu					*/,BII_OBJDESC = OBJ_DESC
/*Numer inwentarzowy			*/,BII_ASSET = (select AST_CODE +' - '+ AST_SUBCODE from dbo.ASSET where AST_ROWID = BII_ASTID)
/*Grupa składników				*/,BII_OBG
/*Kod szablonu składnika		*/,BII_STS = (select STS_CODE from dbo.STENCIL where STS_ROWID = BII_STSID)
/*Typ składnika					*/,BII_OBJTYPE = OBJ_TYPE
/*Wartość początkowa			*/,BII_PRICE
/*Wartość netto					*/,BII_NETTO
/*Faktyczna wartość odsprzedaży */,BII_WART_ODSP 
/*Id decyzji biznesowej	 */		  ,BII_BIZID
/*Id pozycji decyzji biznesowej	*/,BII_ROWID
from dbo.PO_BIZ_DEC_ITEMS 
join dbo.OBJ on OBJ_ROWID = BII_OBJID
left join dbo.OBJTECHPROTLN on POL_OBJID = OBJ_ROWID and POL_BIZ_DEC = 1
left join dbo.OBJTECHPROT on POL_POTID = POL_ROWID
GO