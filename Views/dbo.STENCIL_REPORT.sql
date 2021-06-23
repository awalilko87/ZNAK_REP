SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[STENCIL_REPORT]  
as   
    
select    
--std    
  s1.STS_ROWID   -- ID   
, STS_SETTYPEDESC = (select STT_DESC from SETTYPE (nolock) where STT_CODE = s1.STS_SETTYPE) -- Szablon    
, STS_SIGNED = case when s1.STS_SIGNED = 1 then 'TAK' else 'NIE' end    -- oklejanie majątku  
, s1.STS_SIGNLOC  -- lokalizacja naklejki   
, s1.STS_CODE  -- kod szablonu  
, s1.STS_ORG  -- Siedziba  
, s1.STS_DESC  -- Opis szablonu  
, s1.STS_NOTE  -- Charakterystyka opisowa składnika  
, s1.STS_DATE -- data   
, STS_TIME = (dbo.e2_im_gettimefromdatetime(isnull(s1.STS_DATE,'1900-01-01')))  -- czas   
, STS_STATUS_DESC = (select STA_DESC from STA (nolock) where STA_CODE = s1.STS_STATUS and STA_ENTITY = 'STS')  --Status  
, STS_TYPE_DESC = (select TYP_DESC from TYP (nolock) where TYP_CODE = s1.STS_TYPE and TYP_ENTITY = 'OBJ')  -- Typ składnika  
, STS_TYPE2_DESC = (select TYP2.TYP2_DESC from TYP2 (nolock) join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = s1.STS_TYPE2 and TYP_ENTITY = 'OBJ')  -- Podtyp składnika  
, STS_CREUSER_DESC = dbo.UserName(s1.STS_CREUSER)  --Utworzył  
, s1.STS_CREDATE      
, STS_UPDUSER_DESC = dbo.UserName(s1.STS_UPDUSER)    
, s1.STS_UPDDATE       
, STS_GROUP_DESC = (select OBG_DESC from OBJGROUP where OBG_ROWID = s1.STS_GROUPID)  --Grupa  
--, STS_MANUFAC = (select MFC_CODE from dbo.MANUFAC (nolock) where MFC_ROWID = STS_MANUFACID) -- Producent  
--, STS_PERSON_DESC = dbo.EmpDesc(STS_PERSON,STS_ORG)  -- Własciciel   
--, STS_PARTSLIST = (select OPL_CODE from dbo.OBJPARTSLIST (nolock) where OPL_ROWID = STS_PARTSLISTID)  -- Lista części zamiennych  
--, STS_LOC  = (select LOC_CODE from dbo.LOCATION (nolock) where LOCATION.LOC_ROWID = STS_LOCID)  -- Budynek  
--, STS_CATALOGNO  --Nr katalogowy  
--, STS_YEAR   -- Rok produkcji  
--, STS_SERIAL -- Numer seryjny  
, s1.STS_DEFAULT_KST -- Domyślny symbol KŚT   
, STS_DEFAULT_KST_DESC = (select CCF_DESC from COSTCLASSIFICATIONv where CCF_CODE = s1.STS_DEFAULT_KST)    
    
--, STS_ACCOUNTID  -- konto  
--, STS_ACCOUNT = null    
--, STS_COSTCODEID    
--, STS_COSTCODE = (select CCD_CODE from dbo.COSTCODE (nolock) where COSTCODE.CCD_ROWID = STS_COSTCODEID)  -- Kod kosztów  
--, STS_MRC = (select MRC_CODE from dbo.MRC (nolock) where MRC_ROWID = STS_MRCID)  -- Wydział/dział  
, STS_SAP_CHK = case when s1.STS_SAP_CHK = 1 then 'TAK' else 'NIE' end-- Wyświetlaj nazwę SAP  
, STS_ROTARY = case when s1.STS_ROTARY = 1 then 'TAK' else 'NIE' end  -- Rotujący  
, STS_PM_TOSEND  = case when s1.STS_PM_TOSEND = 1 then 'TAK' else 'NIE' end -- Urządzenie w SAP PM    
, STS_TXT01  = case when s1.STS_TXT01 = 1 then 'TAK' else 'NIE' end-- czy składnik jest budowlą  
, s1.STS_TXT02 -- Gwarancja  
, s1.STS_TXT03 -- Ilość miesięcy  
--, STL_ROWID  
--, STL_CODE = s2.STS_CODE -- Podskładnik  
--, STL_DESC = s2.STS_DESC -- Nazwa podskładnika  
--, STL_GROUP_DESC2 = (select OBG_DESC from OBJGROUP where OBG_ROWID = s2.STS_GROUPID)  
--, STL_TYPE_DESC2 = (select TYP_DESC from TYP (nolock) where TYP_CODE = s2.STS_TYPE and TYP_ENTITY = 'OBJ')  -- Typ podskładnika  
--, STL_REQUIRED  
--, STL_ONE  
--, STL_DEFAULT_NUMBER = Isnull(STL_DEFAULT_NUMBER, 0)  
--, STL_STATUS_DESC2 = (select STA_DESC from STA (nolock) where STA_CODE = s2.STS_STATUS and STA_ENTITY = 'STS')  --Status podskładnika  
, PRO_ROWID  
, PRO_CODE   
, PRO_TEXT  
, ASP_UOM = (select UOM_CODE from UOM (nolock) where UOM_ROWID = ASP_UOMID) --j.m.  
, ASP_VALUE -- domyślna wartośc parametru  
, ASP_REQUIRED   
from dbo.[STENCIL] (nolock) s1    
 --LEFT JOIN STENCILLN on STL_PARENTID = s1.STS_ROWID    
 --LEFT JOIN STENCIL s2 on STL_CHILDID = s2.STS_ROWID  
 LEFT JOIN ADDSTSPROPERTIES (nolock)  on ASP_STSID = s1.STS_ROWID  
 INNER JOIN PROPERTIES (nolock) on PRO_ROWID = ASP_PROID  
 --left join dbo.PROPERTIES_LIST on PRL_PROID = pro_rowid  
 where isnull(s1.STS_CODE,'') <> '-' and isnull(s1.STS_NOTUSED,0) <> 1   
--and s1.STS_ROWID = 10372
GO