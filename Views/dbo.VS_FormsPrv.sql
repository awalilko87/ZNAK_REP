SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create view [dbo].[VS_FormsPrv]
as
select 
  FormID
, FormDescription = isnull((select top 1 T.TabCaption from dbo.VS_Tabs T where T.FormID = F.FormID),FormDescription)

from dbo.VS_Forms F(nolock)
where F.ShowGrid = 1 and F.FormID not like 'SYS%'

GO