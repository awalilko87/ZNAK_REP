SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[VS_DateTimeStr]() returns nvarchar(20)
AS
BEGIN
DECLARE @d datetime, @s nvarchar(20)
	set @d=getdate()
	set @s=convert(nvarchar(19),@d,121) 
	set @s=replace(@s,'-','_')
	set @s=replace(@s,':','')
	set @s=replace(@s,' ','_')
	return (@s)
END
GO