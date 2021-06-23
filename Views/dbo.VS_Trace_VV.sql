SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


/****** Object:  View [dbo].[VS_trace_VV]    Script Date: 06/03/2013 11:07:02 ******/
create view [dbo].[VS_Trace_VV]
as
select top 99.9999 percent 
       TRC_FORM,
       TRC_ACTION,
       TRC_USER,
       TRC_DURATION = dbo.VS_FormatDate(TRC_END_DATE-TRC_START_DATE, 'HH:mm:ss.fff'),
       TRC_BANDWIDTH,
       TRC_START_DATE,
       TRC_END_DATE,
       TRC_ROWGUID
from dbo.VS_Trace (nolock)
order by TRC_START_DATE desc
GO