SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[MapPath_SplitQueryString] (@s varchar(8000))
RETURNS table
AS
RETURN (
    WITH splitter_cte AS (
      SELECT CHARINDEX('&', @s) as pos, 0 as lastPos
      UNION ALL
      SELECT CHARINDEX('&', @s, pos + 1), pos
      FROM splitter_cte
      WHERE pos > 0
      ),
    pair_cte AS (
    SELECT chunk,
           CHARINDEX('=', chunk) as pos
    FROM (
        SELECT SUBSTRING(@s, lastPos + 1,
                         case when pos = 0 then 80000
                         else pos - lastPos -1 end) as chunk
        FROM splitter_cte) as t1
  )
    SELECT substring(chunk, 0, pos) as keyName,
           substring(chunk, pos+1, 8000) as keyValue
    FROM pair_cte
)
GO