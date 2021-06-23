SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE view [dbo].[PSPv]   
as  
select  
 PSP_ROWID,   
 PSP_ITSID,  
 PSP_ITS = ITS_CODE,  
 PSP_CODE,   
 PSP_ORG,   
 PSP_DESC,   
 PSP_DATE,   
 PSP_TIME = (dbo.e2_im_gettimefromdatetime(isnull(PSP_DATE,'1900-01-01'))),  
 PSP_STATUS,   
 PSP_STATUS_DESC = (select STA_DESC from STA (nolock) where STA_CODE = PSP_STATUS and STA_ENTITY = 'PSP'),  
 PSP_ICONSTATUS =  dbo.[GetStatusImage] ('PSP', PSP_STATUS),  
 PSP_TYPE,   
 PSP_TYPE_DESC = (select TYP_DESC from TYP (nolock) where TYP_CODE = PSP_TYPE and TYP_ENTITY = 'PSP'),  
 PSP_TYPE2,  
 PSP_TYPE2_DESC = (select TYP2.TYP2_DESC from TYP2 (nolock) join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = PSP_TYPE and TYP_ENTITY = 'PSP'),  
 PSP_TYPE3,  
 PSP_TYPE3_DESC = (select TYP3.TYP3_DESC from TYP3 (nolock) join TYP2 (nolock) on TYP2.TYP2_ROWID = TYP3.TYP3_TYP2ID join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = PSP_TYPE and TYP_ENTITY = 'PSP'),  
 PSP_RSTATUS,   
 PSP_CREUSER,   
 PSP_CREUSER_DESC = dbo.UserName(PSP_CREUSER),  
 PSP_CREDATE,   
 PSP_UPDUSER,   
 PSP_UPDUSER_DESC = dbo.UserName(PSP_UPDUSER),  
 PSP_UPDDATE,   
 PSP_NOTUSED,   
 PSP_ID,   
 PSP_TXT01,   
 PSP_TXT02,   
 PSP_TXT03,   
 PSP_TXT04,   
 PSP_TXT05,   
 PSP_TXT06,   
 PSP_TXT07,   
 PSP_TXT08,   
 PSP_TXT09,   
 PSP_TXT10,   
 PSP_TXT11,   
 PSP_TXT12,   
 PSP_NTX01,   
 PSP_NTX02,   
 PSP_NTX03,   
 PSP_NTX04,   
 PSP_NTX05,   
 PSP_COM01,   
 PSP_COM02,   
 PSP_DTX01,   
 PSP_DTX02,   
 PSP_DTX03,   
 PSP_DTX04,   
 PSP_DTX05,    
 PSP_NOTE,   
 PSP_COSTCODEID,   
 PSP_COSTCODE = (select CCD_CODE from dbo.COSTCODE (nolock) where COSTCODE.CCD_ROWID = PSP_COSTCODEID),  
 PSP_SAP_PSPNR,--Definicja projektu (wewnętrzna)  
 PSP_SAP_POST1,--PS: Krótki opis (pierwsza linia tekstu)  
 PSP_SAP_PSPHI,--Numer bieżący odpowiedniego projektu  
 PSP_SAP_POSID,--Element planu strukturalnego projektu (element PSP)  
 PSP_SAP_OBJNR,--Numer obiektu  
 PSP_SAP_ERNAM,--Użytkownik, który utworzył dany obiekt  
 PSP_SAP_ERDAT,--Data utworzenia rekordu  
 PSP_SAP_AENAM,--Nazwisko osoby, która zmieniła obiekt  
 PSP_SAP_AEDAT,--Data ostatniej zmiany obiektu  
 PSP_SAP_STSPR,--Schemat statusów dla elementu PSP  
 PSP_SAP_VERNR,--Numer osoby odpowiedzialnej (kierownik projektu)  
 PSP_SAP_VERNA,--Osoba odpowiedzialna (menedżer projektu)  
 PSP_SAP_ASTNR,--Numer wnioskodawcy  
 PSP_SAP_ASTNA,--Wnioskodawca  
 PSP_SAP_VBUKR,--Jednostka gospodarcza projektu  
 PSP_SAP_VGSBR,--Dział gospodarczy projektu  
 PSP_SAP_VKOKR,--Obszar rachunku kosztów projektu  
 PSP_SAP_PRCTR,--Centrum zysku  
 PSP_SAP_PWHIE,--Waluta PSP (definicja projektu)  
 PSP_SAP_ZUORD,--Przypisanie sieci  
 PSP_SAP_PLFAZ,--Planowany termin rozpoczęcia projektu  
 PSP_SAP_PLSEZ,--Planowany termin zakończenia projektu  
 PSP_SAP_KALID,--Klucz kalendarza zakładowego  
 PSP_SAP_VGPLF,--Metoda planowania terminów bazowych w projekcie  
 PSP_SAP_EWPLF,--Metoda planowania terminów prognozowanych w projekcie  
 PSP_SAP_ZTEHT,--Jednostka czasu planowania terminów  
 PSP_SAP_PLNAW,--Wykorzystanie marszruty/planu  
 PSP_SAP_PROFL,--Profil projektu  
 PSP_SAP_BPROF,--Profil budżetu  
 PSP_SAP_TXTSP,--Klucz języka  
 PSP_SAP_KOSTL,--Miejsce powstawania kosztów  
 PSP_SAP_KTRG,--Nośnik kosztów  
 PSP_SAP_SCPRF,--Profil opracowania harmonogramu PSP  
 PSP_SAP_IMPRF,--Profil środków inwestycyjnych  
 PSP_SAP_PPROF,--Profil planu  
 PSP_SAP_ZZKIER,--Kierunki inwestowania dla projektów momodułu PS  
 PSP_SAP_STUFE,--Poziom w hierarchii projektu  
 PSP_SAP_BANFN,--Numer zgłoszenia zapotrzebowania  
 PSP_SAP_BNFPO,--Numer pozycji zgłoszenia zapotrzebowania  
 PSP_SAP_ZEBKN,--Bieżący nr dla segmentu dekretacji zgłoszenia zapotrzeb.  
 PSP_SAP_EBELN,--Numer dokumentu zaopatrzeniowego  
 PSP_SAP_EBELP,--Numer pozycji dokumentu zaopatrzeniowego  
 PSP_SAP_ZEKKN,--Bieżący numer dekretacji  
 PSP_SAP_ACTIVE--Aktywny  
from PSP (nolock)  
 left join INVTSK ITS (nolock) on PSP_ITSID = ITS.ITS_ROWID  
 and ISNULL(PSP_NOTUSED,0) = 0 
  
GO