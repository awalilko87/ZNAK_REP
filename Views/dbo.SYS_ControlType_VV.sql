SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE view [dbo].[SYS_ControlType_VV]
as 
with kody as(
            SELECT Kod='BTC', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/BTC" target="_blank">Link</a>'
  UNION ALL SELECT Kod='BTF', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/BTF" target="_blank">Link</a>'
  UNION ALL SELECT Kod='BTFM', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/BTFM" target="_blank">Link</a>'
  UNION ALL SELECT Kod='BTH', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/BTH" target="_blank">Link</a>'
  UNION ALL SELECT Kod='BTM', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/BTM" target="_blank">Link</a>'
  UNION ALL SELECT Kod='BTN', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/BTN" target="_blank">Link</a>'
  UNION ALL SELECT Kod='BTQ', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/BTQ" target="_blank">Link</a>'
  UNION ALL SELECT Kod='BTR', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/BTR" target="_blank">Link</a>'
  UNION ALL SELECT Kod='BIF', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/BIF" target="_blank">Link</a>'
  /*UNION ALL SELECT Kod='CALM', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/CALM" target="_blank">Link</a>'*/
  UNION ALL SELECT Kod='CHK', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/CHK" target="_blank">Link</a>'
  UNION ALL SELECT Kod='CHL', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/CHL" target="_blank">Link</a>'
  UNION ALL SELECT Kod='CHR', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/CHR" target="_blank">Link</a>'
  UNION ALL SELECT Kod='DDD', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/DDD" target="_blank">Link</a>'
  UNION ALL SELECT Kod='DDL', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/DDL" target="_blank">Link</a>'
  UNION ALL SELECT Kod='DDC', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/DDC" target="_blank">Link</a>'
  UNION ALL SELECT Kod='DTE', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/DTE" target="_blank">Link</a>'
  UNION ALL SELECT Kod='DTS', [Status]='Not used', Link = '<a href="javascript:alert(''Not used'');" target="_blank">Link</a>'
  UNION ALL SELECT Kod='DTX', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/DTX" target="_blank">Link</a>'
  UNION ALL SELECT Kod='FIB', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/FIB" target="_blank">Link</a>'
  UNION ALL SELECT Kod='HTB', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/pages/viewpage.action?pageId=8749078" target="_blank">Link</a>'
  UNION ALL SELECT Kod='HTX', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/HTX" target="_blank">Link</a>'
  UNION ALL SELECT Kod='IMC', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/IMC" target="_blank">Link</a>'
  UNION ALL SELECT Kod='IMF', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/IMF" target="_blank">Link</a>'
  UNION ALL SELECT Kod='IMFM', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/IMFM" target="_blank">Link</a>'
  UNION ALL SELECT Kod='IMH', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/IMH" target="_blank">Link</a>'
  UNION ALL SELECT Kod='IMM', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/IMM" target="_blank">Link</a>'
  UNION ALL SELECT Kod='IMN', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/IMN" target="_blank">Link</a>'
  UNION ALL SELECT Kod='IMR', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/IMR" target="_blank">Link</a>'
  UNION ALL SELECT Kod='IMS', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/BTF" target="_blank">Link</a>'
  UNION ALL SELECT Kod='LBC', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/x/NIBs" target="_blank">Link</a>'
  UNION ALL SELECT Kod='LBL', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/x/MoBs" target="_blank">Link</a>'
  UNION ALL SELECT Kod='LBT', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/LBT" target="_blank">Link</a>'
  UNION ALL SELECT Kod='MTX', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/MTX" target="_blank">Link</a>'
  UNION ALL SELECT Kod='NTX', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/NTX" target="_blank">Link</a>'
  UNION ALL SELECT Kod='PUI', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/PUI" target="_blank">Link</a>'
  UNION ALL SELECT Kod='PUP', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/x/P4Bs" target="_blank">Link</a>'
  UNION ALL SELECT Kod='PUPM', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/x/T4Bs" target="_blank">Link</a>'
  UNION ALL SELECT Kod='RBL', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/RBL" target="_blank">Link</a>'
  UNION ALL SELECT Kod='RPV', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/RPV" target="_blank">Link</a>'
  UNION ALL SELECT Kod='SES', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/SES" target="_blank">Link</a>'
  UNION ALL SELECT Kod='TME', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/x/LAB8" target="_blank">Link</a>'
  UNION ALL SELECT Kod='TXT', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/x/NoBs" target="_blank">Link</a>'
  UNION ALL SELECT Kod='XLI', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/BTF" target="_blank">Link</a>'
  UNION ALL SELECT Kod='DFU', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/DFU" target="_blank">Link</a>'
  UNION ALL SELECT Kod='RIT', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/RIT" target="_blank">Link</a>'
  UNION ALL SELECT Kod='IMX', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/IMX" target="_blank">Link</a>'
  UNION ALL SELECT Kod='SLD', [Status]='', Link = '<a href="http://info.eurotronic.net.pl/display/VS/SLD" target="_blank">Link</a>'
)      
Select top 99.99 percent 
    kody.Kod, 
    kody.Link,
    kody.[Status],
    (SELECT top 1 Caption FROM VS_LangMsgs WHERE ObjectType LIKE 'OBJTYPE' AND ObjectID LIKE 'DESC_' + kody.Kod AND LangID = l.LangID) as Opis,
    (SELECT top 1 Caption FROM VS_LangMsgs WHERE ObjectType LIKE 'OBJTYPE' AND ObjectID LIKE 'NAME_' + kody.Kod AND LangID = l.LangID) as Nazwa,    
    l.LangID
from dbo.VS_Langs l /*dla każdego jezyka zwroci powtrzony wpis kodów, a formatka wyłuska tylko ten jezyk jaki ma biezacy user*/
    cross join kody
order by kody.Kod  

GO