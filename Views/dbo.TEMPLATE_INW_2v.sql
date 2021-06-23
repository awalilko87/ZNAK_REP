SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[TEMPLATE_INW_2v]          
AS          
          
SELECT distinct       
SIA_SINID      
, SIA_LP = ROW_NUMBER() over (partition by sia_sinid order by sia_astcode )     
, SIA_ASTCODE =IsNull(SIA_ASTCODE , N'Nadwyżka')     
, SIA_ASTSUBCODE      
, SIA_BARCODE AS INDEX_      
, SIA_ASTDESC AS NAZWA      
, AST_SAP_URWRT AS Wartosc      
, 1 AS Ilość      
,  cast(SIA_NOTE as nvarchar(max)) AS Uwagi          
FROM dbo.AST_INWLNv          
where         
--SIA_ASTCODE is not null          
--and         
SIA_NADWYZKA = 1
GO