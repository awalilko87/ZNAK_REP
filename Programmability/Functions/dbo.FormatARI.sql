SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FormatARI]
(
@wartosc float
)
RETURNS nvarchar(20)
AS
BEGIN
declare @v_money varchar(30)
declare @przed varchar(30)
declare @po varchar(30)
declare @dlugosc int
declare @dlugosc2 int = 1
declare @got varchar(30)
declare @got2 varchar(30)

set @v_money = CONVERT(varchar(30), convert(money, @wartosc))

set @przed = substring(@v_money, 1, CHARINDEX('.', @v_money, 1)-1)
set @po = RIGHT(convert(money, @wartosc), 2)
set @dlugosc = LEN(@przed)

if @dlugosc > 3
begin
	while @dlugosc > 0
	begin
	
		if @dlugosc%3 = 0
		begin
		if (LEN(@przed)-@dlugosc) > 3 or (LEN(@przed)-@dlugosc) = 0
			set @got = substring(@przed, @dlugosc2, 3)+' '
		else 
			set @got = substring(@przed, @dlugosc2, LEN(@przed)-@dlugosc)+' '
			
			set @dlugosc2 = LEN(@got)+1
			
			set @got2 = ISNULL(@got2, '') + @got
		end
	
	set @dlugosc -= 1
	end

	set @got2 = @got2 + SUBSTRING(@przed, len(REPLACE(@got2, ' ', ''))+1, 3)
end
else
	set @got2 = @przed

RETURN rtrim(@got2)+','+@po

END
GO