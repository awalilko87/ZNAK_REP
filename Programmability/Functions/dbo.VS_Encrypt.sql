SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create function [dbo].[VS_Encrypt](@link varchar(max), @key varchar(max))
returns varchar(max)
with encryption
as
begin
  declare @c varbinary(max)
  declare @h varchar(max)
  set @h = HashBytes('MD5', @key)
  set @c = EncryptByPassPhrase(@h, @link)
  return dbo.VS_EncodeBase64(@c);
end
GO