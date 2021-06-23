﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create function [dbo].[VS_EncryptText](@text varchar(max))
returns varchar(max)
with encryption
as
  begin
  declare @key varchar(max)
  select @key = [SettingValue] from dbo.SYSettings (nolock) where [KeyCode] = 'EncryptionKey'
  return dbo.VS_Encrypt(@text, @key)
  end
GO