﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view  [dbo].[SAPO_ZWFOT11COMv] as
select 
	OT11COM_ROWID = COM_ROWID,
	OT11COM_OT11ID = OT11_ROWID,
	TDFORMAT = 'T',
	TDLINE = COM_TEXT,OT11_IF_STATUS
from dbo.COMMENTS (nolock) 
	join ZWFOT (nolock) on OT_ID = COM_ID
	join SAPO_ZWFOT11 (nolock) on OT11_ZMT_ROWID = OT_ROWID and OT11_IF_STATUS = 1
where 
	OT_TYPE = 'SAPO_ZWFOT11'
GO