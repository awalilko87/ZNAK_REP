﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create view [dbo].[DESCRIPTIONS_DAEv]
as
select
 DES_TYPE
,DES_LANGID
,DES_CODE
,DES_TEXT
from dbo.DESCRIPTIONS(nolock)
where DES_ENTITY = 'DAE'

GO