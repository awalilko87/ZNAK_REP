SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE view [dbo].[VS_LangMsgs_KPI]
as  
select  
  KPI_ID
  ,LangID
  ,ControlID
  ,ObjectType
  ,ObjectID
  ,Caption = case when isnull(LangID,'PL') = 'PL' and Caption is null then KPI_DESC else Caption end
from VS_KPI
left join VS_LangMsgs on ObjectType = 'KPI' and ControlID = KPI_ID
GO