SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE function [dbo].[VS_Split3] ( 
	@StringToSplit nvarchar(4000),
	@Separator nvarchar(128))

returns @indicestable table (
  [String] nvarchar(1000),
  [StartIndex] int,
  [ind] int
)
as
begin
with indices AS 
( 
  select 
	0 S, 
	1 E, 
	0 P 
  union all 
  select 
	E, 
	charindex(@Separator, @StringToSplit, E) + len(@Separator), 
	0 P 
  from 
	indices 
  where 
	E > S 
) 
  insert into @indicestable ([String],[StartIndex],[ind])
  select 
	substring(@StringToSplit, S, case when E > len(@Separator) then E-S-len(@Separator) else len(@StringToSplit) - S + 1 end) String
	, S StartIndex
	, row_number() over(order by P desc) as ind 
  from 
	indices 
  where 
	S > 0 
  option (maxrecursion 0)

return;
end
GO