SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[VS_Split] ( 
	@StringToSplit nvarchar(4000),
	@Separator nvarchar(128))
returns table as return
with indices as
( 
select 0 S, 1 E
union all
select E, charindex(@Separator, @StringToSplit, E) + len(@Separator) 
from indices
where E > S 
)
select substring(@StringToSplit,S, 
case when E > len(@Separator) then E-S-len(@Separator) else len(@StringToSplit) - S + 1 end) String
,S StartIndex        
from indices where S >0

GO