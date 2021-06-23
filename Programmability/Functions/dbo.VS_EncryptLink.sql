SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create function [dbo].[VS_EncryptLink](@link varchar(max))
returns varchar(max)
with encryption
as
  begin
  declare @ret varchar(max)
  declare @key varchar(max)
  declare @url varchar(max)
  select @key = [SettingValue] from dbo.SYSettings (nolock) where [KeyCode] = 'EncryptionKey'
  select @ret = substring(@link, 0, charindex('?',@link))
  select @url = substring(@link, charindex('?',@link)+1, len(@link) - charindex('?',@link))
  select @ret = @ret + '?data='
  select @ret = @ret + dbo.VS_Encrypt(@url, @key)
  return @ret
  end
GO