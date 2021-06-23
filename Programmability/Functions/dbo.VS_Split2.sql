SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[VS_Split2] ( 
	@StringToSplit nvarchar(4000),
	@Separator nvarchar(128))
RETURNS TABLE 
AS 
RETURN 
WITH indices AS 
( 
SELECT 
0 S, 
1 E, 
0 P 
UNION ALL 
SELECT 
E, 
CHARINDEX(@Separator, @StringToSplit, E) + LEN(@Separator), 
0 P 
FROM 
indices 
WHERE 
E > S 
) 
SELECT 
SUBSTRING(@StringToSplit, S, CASE WHEN E > LEN(@Separator) THEN E-S-len(@Separator) ELSE LEN(@StringToSplit) - S + 1 END) String, 
S StartIndex, 
ROW_NUMBER() OVER(ORDER BY P DESC) as ind 
FROM 
indices 
WHERE 
S > 0 

GO