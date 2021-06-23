SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create function [dbo].[VS_Decrypt](@enc varchar(max), @key varchar(max))
returns varchar(max)
with encryption
as
begin
  declare @c varbinary(max)
  declare @h varchar(max)
  set @h = HashBytes('MD5', @key)
  set @c = convert(varbinary(max),dbo.VS_DecodeBase64(@enc))
  set @c = DecryptByPassPhrase(@h, @c)
  return convert(varchar(max),@c);
end
GO