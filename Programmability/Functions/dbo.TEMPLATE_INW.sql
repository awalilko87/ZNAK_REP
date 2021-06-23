SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE function [dbo].[TEMPLATE_INW](@p_SINID int)  
returns table  
AS  
return  
with OBJASSET_ONE as (select OBA_ASTID, min(OBA_OBJID) OBA_OBJID from OBJASSET (nolock) group by OBA_ASTID),
ast_inw as (
select 
SIA_SINID
,SIA_LP= ROW_NUMBER () over (partition by SIA_SINID order by SIA_ASTCODE, SIA_ASTSUBCODE)
,SIA_ASTCODE
,SIA_ASTSUBCODE
,INDEX_
,NAZWA
,Wartosc
,Ilość
,Uwagi
,SIA_ANLKL
,SIA_NADWYZKA
,AST_SUBCODE
 from (
select 
SIA_SINID
, SIA_ASTCODE = IsNull(AST_CODE, N'Nadwyżka')
, SIA_ASTSUBCODE = cast(convert(varchar,floor(AST_SUBCODE)) as int) 
, '' AS INDEX_
, isnull(OBJ_DESC + '. ', '') + '(SAP: ' + coalesce (AST_DESC, (select OBJ_DESC from OBJ where OBJ_CODE = SIA_BARCODE))+ ')' AS NAZWA
, Wartosc = dbo.GetASTValue(AST_CODE, AST_SUBCODE)
, SIA_NEWQTY AS Ilość
, '' AS Uwagi
, SIA_ANLKL = AST_SAP_ANLKL
, SIA_NADWYZKA = isNull(SIA_NADWYZKA,0)
, AST_SUBCODE 
FROM dbo.AST_INWLN ARI
left join dbo.ASSET(nolock) on AST_ROWID = SIA_ASSETID 
left join OBJASSET_one on OBA_ASTID = AST_ROWID
left join dbo.OBJ (nolock) on (OBJ_ROWID = OBA_OBJID and OBA_OBJID is not null)
where SIA_SINID = @p_SINID --and ISNull(SIA_NADWYZKA, 0) = 0 
and OBA_OBJID is not null
union all
select 
SIA_SINID
, SIA_ASTCODE = IsNull(AST_CODE, N'Nadwyżka')
, SIA_ASTSUBCODE = cast(convert(varchar,floor(AST_SUBCODE)) as int) 
, '' AS INDEX_
, isnull(OBJ_DESC + '. ', '') + '(SAP: ' + coalesce (AST_DESC, (select OBJ_DESC from OBJ where OBJ_CODE = SIA_BARCODE))+ ')' AS NAZWA
, Wartosc = dbo.GetASTValue(AST_CODE, AST_SUBCODE)
, SIA_NEWQTY AS Ilość
, '' AS Uwagi
, SIA_ANLKL = AST_SAP_ANLKL
, SIA_NADWYZKA = isNull(SIA_NADWYZKA,0) 
, AST_SUBCODE 
FROM dbo.AST_INWLN ARI
left join dbo.ASSET(nolock) on AST_ROWID = SIA_ASSETID 
left join OBJASSET_one on OBA_ASTID = AST_ROWID
left join dbo.OBJ (nolock) on OBJ_CODE = SIA_BARCODE
where SIA_SINID = @p_SINID --and ISNull(SIA_NADWYZKA, 0) = 0 
and OBA_OBJID is null
)ast)

select 
SIA_SINID
,SIA_LP
,SIA_ASTCODE
,SIA_ASTSUBCODE
,INDEX_
,NAZWA
,Wartosc
,Ilość
,Uwagi
,SIA_ANLKL
,SIA_NADWYZKA
from ast_inw 
where SIA_NADWYZKA = 0
  
/*PODSUMOWANIE*/
union all
SELECT 
SIA_SINID
,9997 as SIA_LP
, null as SIA_ASTCODE
, null as SIA_ASTSUBCODE
, '' AS INDEX_
, 'SUMA' AS NAZWA
 --, replace(replace(convert(varchar,sum(dbo.GetASTValue (SIA_ASTCODE, SIA_ASTSUBCODE)),1),',',' '),'.',',') 
 , sum(dbo.GetASTValue (SIA_ASTCODE, AST_SUBCODE))

, null AS Ilość 
, '' AS Uwagi
, null as SIA_ANLKL
, null as SIA_NADWYZKA
FROM ast_inw
where SIA_SINID = @p_SINID
group by SIA_SINID 
   
  
 /*WIERSZ PUSTY*/   
  
union all  
  
SELECT  
SIN_ROWID  
,9998 as SIA_LP  
, NULL as SIA_ASTCODE  
, null as SIA_ASTSUBCODE  
, NULL AS INDEX_  
, NULL AS NAZWA  
, NULL  
, NULL AS Ilość   
, NULL AS Uwagi  
, null as SIA_ANLKL  
, null as SIA_NADWYZKA  
FROM dbo.ST_INW  
where SIN_ROWID = @p_SINID  
  
/*PODPISY*/  
  
UNION ALL  
  
SELECT SIN_ROWID  
, 9999 as SIA_LP  
, NULL as SIA_ASTCODE  
, null as SIA_ASTSUBCODE  
, 'PODPIS OSOBY MATERIALNIE ODPOWIEDZIALNEJ' AS INDEX_  
, 'PODPISY CZŁOWNKÓW ZESPOŁU SPISOWEGO:' AS NAZWA  
, NULL  
, NULL AS Ilość   
, NULL AS Uwagi  
, null as SIA_ANLKL  
, null as SIA_NADWYZKA  
FROM dbo.ST_INW  
where SIN_ROWID = @p_SINID  
GO