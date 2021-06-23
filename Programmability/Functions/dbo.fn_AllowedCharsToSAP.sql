SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create function [dbo].[fn_AllowedCharsToSAP](@String nvarchar(max))
returns nvarchar(max)
as
begin
	set @String=IsNull(@String,'')

	declare @ret nvarchar(max);
	set @ret = cast((
		select substring(@String, n, 1) 
		from dbo.GetNums(datalength(@String)/2)
		join dbo.AllowedCharsToSAP on substring(@String, n, 1) = ACHAR
		for xml path('')
	) as xml).value('.', 'nvarchar(max)');
	return @ret;
end;
GO