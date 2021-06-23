SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ZWFOT11_SZABv]      
as      
select       
 OT11_OTID = OT_ROWID      
,OT11_OTCODE = OT_CODE      
,OT11_CZY_BUD      
,OT11_SERNR_POSKI      
,OT11_POSNR_POSKI      
,OT11_CZY_SKL_POZW      
,OT11_HERST_POSKI      
,OT11_LAND1      
,OT11_MUZYTK      
,OT11_NAZWA_DOK      
,OT11_NUMER_DOK      
,OT11_DATA_DOK      
,OT11_WART_NAB_PLN      
,OT11_DATA_DOST = convert(datetime,cast([OT11_ROK_DOST]as nvarchar) + '-' + cast( [OT11_MIES_DOST] as nvarchar) + '-01')      
,OT11_PRZEW_OKRES      
,OT11_CZY_BEZ_ZM      
,OT11_CZY_ROZ_OKR      
,OT11_INVNR_NAZWA      
,OT11_ANLKL_POSKI     
,OT11_CHAR   
,OT11_SZABLON = (select NAME from dbo.ZWFOT_TEMPLATE where OT_ROWID = OTID)  
from dbo.SAPO_ZWFOT11      
inner join dbo.ZWFOT on OT_ROWID = OT11_ZMT_ROWID     
where OT11_IF_STATUS <> 4 and OT_TYPE = 'SAPO_ZWFOT11'
GO