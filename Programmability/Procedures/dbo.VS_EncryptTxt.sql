SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create procedure [dbo].[VS_EncryptTxt](@txt nvarchar(max))
as
select dbo.VS_EncryptText(@txt)

GO