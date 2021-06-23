SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[OBJTECHPROT_TODOv]
as
select 
 POT_ROWID_TODO = POT_ROWID
,POT_DZR_TODO = case when exists ( select 1 from OBJTECHPROTCHECK_GU where POC_POTID = POT_ROWID and POC_GROUPID = 'DZR' ) then 0 else isnull(CHK_GU_DZR,0) end
,CHK_GU_DZR_USER
,POT_IT_TODO = case when exists ( select 1 from OBJTECHPROTCHECK_GU where POC_POTID = POT_ROWID and POC_GROUPID = 'IT' ) then 0 else isnull(CHK_GU_IT,0) end
,CHK_GU_IT_USER
,POT_RKB_TODO = case when exists ( select 1 from OBJTECHPROTCHECK_GU where POC_POTID = POT_ROWID and POC_GROUPID = 'RKB' ) then 0 else isnull(CHK_GU_RKB,0) end
,CHK_GU_RKB_USER
,POT_UR_TODO  = case when exists ( select 1 from OBJTECHPROTCHECK_GU where POC_POTID = POT_ROWID and POC_GROUPID = 'UR' ) then 0 else isnull(CHK_GU_UR,0) end
,CHK_GU_UR_USER
from OBJTECHPROT 
GO