SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- CREATE VIEW-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

CREATE view [dbo].[OT11_MASS_XLSv]    
as     
select    
 ROWID     
 ,SPID    
 ,IMPORTUSER    
 ,LP
 ,OT11_ACTION    
 ,OT11_BUKRS    
 ,OT11_SAPUSER    
 ,OT11_STATION  
  ,OT11_STENCIL   
 ,OT11_PARENT  
 ,OT11_QTY  
 ,OT11_VALUE  
 ,OT11_OBJ  
 ,OT11_TYP_SKLADNIKA    
 ,OT11_CZY_BUD    
 ,OT11_SERNR_POSKI    
 ,OT11_POSNR_POSKI    
 ,OT11_ANLN1_POSKI    
 ,OT11_ANLN2_POSKI    
 ,OT11_INVNR_NAZWA    
 ,OT11_CZY_FUND    
 ,OT11_CZY_SKL_POZW  
 ,OT11_CZY_POZWOL
 ,OT11_CZY_PLAN_POZW
 ,OT11_ZZ_PLAN_DATA_ZGL
 ,OT11_CZY_WYD_POZW
 ,OT11_ZZ_DATA_ZGLDEC
 ,OT11_ZZ_DATA_UPRA_ZGLDEC
 ,OT11_CZY_DZIENNIK
 ,OT11_DATA_DZIENNIK
 ,OT11_CZY_WEW_BUDYNKU
 ,OT11_CZY_NIEMAT    
 ,OT11_HERST_POSKI    
 ,OT11_LAND1    
 ,OT11_KOSTL_POSKI    
 ,OT11_GDLGRP_POSKI    
 ,OT11_MUZYTK    
 ,OT11_NAZWA_DOK    
 ,OT11_NUMER_DOK    
 ,OT11_DATA_DOK    
 ,OT11_WART_NAB_PLN  
 ,OT11_WART_FUND    
 ,OT11_MIES_DOST    
 ,OT11_ROK_DOST    
 ,OT11_PRZEW_OKRES    
 ,OT11_CZY_BEZ_ZM     
 ,OT11_CZY_ROZ_OKR    
 ,OT11_WOJEWODZTWO  
 ,OT11_BRANZA  
 ,OT11_PODZ_USL_1P    
 ,OT11_PODZ_USL_2S    
 ,OT11_PODZ_USL_3B    
 ,OT11_PODZ_USL_4C    
 ,OT11_PODZ_USL_5U    
 ,OT11_PODZ_USL_6H    
 ,OT11_PODZ_USL_7SUMA    
 ,OT11_CHAR    
 ,OT11_ANLKL_POSKI    
 ,OT11_CZY_BUDOWLA    
 ,ErrorMessage    
 ,OT11_LINIA = 0 -- Numer zaczytanej linii, do utworzenia pojedynczego dokumentu OT    
 ,LP1 = LP -1
from [dbo].[OT11_MASS_XLS]   
GO