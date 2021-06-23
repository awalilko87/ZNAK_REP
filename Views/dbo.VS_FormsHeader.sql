SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create view [dbo].[VS_FormsHeader]
as
select 
  FormID
, TablePrefix
, FormDescription = isnull((select top 1 T.TabCaption from dbo.VS_Tabs T where T.FormID = F.FormID),FormDescription)
, FieldID_A = (select HA.FieldID from dbo.VS_FormHeader HA (nolock) where HA.FormID = F.FormID and HA.Panel = 'A')
, Caption_A = (select HA.Caption from dbo.VS_FormHeader HA (nolock) where HA.FormID = F.FormID and HA.Panel = 'A')
, FieldID_B = (select HA.FieldID from dbo.VS_FormHeader HA (nolock) where HA.FormID = F.FormID and HA.Panel = 'B')
, Caption_B = (select HA.Caption from dbo.VS_FormHeader HA (nolock) where HA.FormID = F.FormID and HA.Panel = 'B')
, FieldID_C = (select HA.FieldID from dbo.VS_FormHeader HA (nolock) where HA.FormID = F.FormID and HA.Panel = 'C')
, Caption_C = (select HA.Caption from dbo.VS_FormHeader HA (nolock) where HA.FormID = F.FormID and HA.Panel = 'C')
, FieldID_D = (select HA.FieldID from dbo.VS_FormHeader HA (nolock) where HA.FormID = F.FormID and HA.Panel = 'D')
, Caption_D = (select HA.Caption from dbo.VS_FormHeader HA (nolock) where HA.FormID = F.FormID and HA.Panel = 'D')

from dbo.VS_Forms F(nolock)
where F.FormID not like 'SYS%' and F.FormID not like 'KPI%' and F.FormID not in ('A_KPI', 'MSGS')

GO