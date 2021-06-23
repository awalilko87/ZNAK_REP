SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

create procedure [dbo].[VS_DecryptTxt](@txt nvarchar(max))
as
select dbo.VS_DecryptText(@txt)

GO