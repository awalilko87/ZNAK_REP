SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--select dbo.[GetStatusImage] ('RST', 'RST_001')

CREATE function [dbo].[GetStatusImage] (@p_ENTITY nvarchar(50),@p_STATUS nvarchar(30))
returns nvarchar(max)
as
begin
  declare @r_ico nvarchar(500)
  set @r_ico = '<img src="'+isnull((select top 1 STA_ICON from dbo.STA (nolock) where STA_ENTITY = @p_ENTITY and STA_CODE = @p_STATUS),'/Images/16x16/Selection.png')+'" border=0 />'


return (@r_ico)
end






GO