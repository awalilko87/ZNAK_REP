﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view  [dbo].[SAPO_ZWFOT31COMv] as
select 
 OT31COM_ROWID = COM_ROWID
,OT31COM_OT31ID = OT31_ROWID
,TDFORMAT = 'T'
,TDLINE = TXT
,OT31_IF_STATUS
from dbo.COMMENTS (nolock) 
join ZWFOT (nolock) on OT_ID = COM_ID
join SAPO_ZWFOT31 (nolock) on OT31_ZMT_ROWID = OT_ROWID and OT31_IF_STATUS = 1
cross apply dbo.SAPO_COMMENT_Split(COM_TEXT, 132)
where OT_TYPE = 'SAPO_ZWFOT31'
GO