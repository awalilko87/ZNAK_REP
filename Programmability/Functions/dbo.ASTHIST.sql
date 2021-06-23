SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
  
CREATE function [dbo].[ASTHIST]  
(  
 @ANLN1_POSKI nvarchar(30),  
 @ANLN2 nvarchar(30)  
)  
returns table as return  
  
select 'MT1' as TypDok, OT_CODE, OT31_IF_EQUNR, STA_DESC, max(OTL_CREDATE) as OTL_CREDATE, OTL_CREUSER, OT31LN_MPK_WYDANIA as MPK_WYDANIA, wyd.CCD_DESC as CCD_DESC_wyd, OT31LN_MPK_PRZYJECIA as MPK_PRZYJECIA, przy.CCD_DESC as CCD_DESC_przy  
from  
[dbo].[SAPO_ZWFOT31LN] (nolock)  
 join [dbo].[SAPO_ZWFOT31] (nolock) on OT31_ROWID = OT31LN_OT31ID  
 join [dbo].[SAPO_ZWFOT31DON] (nolock) on OT31DON_OT31ID = OT31LN_OT31ID  
  left join ASSET don (nolock) on don.AST_CODE = OT31LN_ANLN1_POSKI and don.AST_SUBCODE = OT31DON_ANLN2  
 join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT31LN_ZMT_ROWID  
 join [dbo].[ZWFOT] (nolock) on OT_ROWID = OTL_OTID  
 left join [dbo].[STA] (nolock) on STA_CODE = OT_STATUS and STA_ENTITY = 'OT31'  
 left join [dbo].[COSTCODE] wyd (nolock) on wyd.CCD_CODE = OT31LN_MPK_WYDANIA_POSKI  
 left join [dbo].[COSTCODE] przy (nolock) on przy.CCD_CODE = OT31LN_MPK_PRZYJECIA_POSKI  
   
where [OT_TYPE] = 'SAPO_ZWFOT31'  
and (OT31LN_ANLN1_POSKI = @ANLN1_POSKI  
or (OT31LN_ANLN1_POSKI = @ANLN1_POSKI and OT31DON_ANLN2 = @ANLN2))  
group by OT_CODE, OT31_IF_EQUNR, STA_DESC, OTL_CREUSER, OT31LN_MPK_WYDANIA, wyd.CCD_DESC, OT31LN_MPK_PRZYJECIA, przy.CCD_DESC  
  
   
union all   
  
select 'MT2' as TypDok, OT_CODE, OT32_IF_EQUNR, STA_DESC, max(OTL_CREDATE) as OTL_CREDATE, OTL_CREUSER, OT32LN_MPK_WYDANIA, wyd.CCD_DESC, OT32LN_MPK_PRZYJECIA, przy.CCD_DESC as CCD_DESC_przy  
from  
[dbo].[SAPO_ZWFOT32LN] (nolock)  
 join [dbo].[SAPO_ZWFOT32] (nolock) on OT32_ROWID = OT32LN_OT32ID  
 join [dbo].[SAPO_ZWFOT32DON] (nolock) on OT32DON_OT32ID = OT32LN_OT32ID  
  left join ASSET don (nolock) on don.AST_CODE = OT32LN_ANLN1_POSKI and don.AST_SUBCODE = OT32DON_ANLN2  
 join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT32LN_ZMT_ROWID  
 join [dbo].[ZWFOT] (nolock) on OT_ROWID = OTL_OTID  
 left join [dbo].[STA] (nolock) on STA_CODE = OT_STATUS and STA_ENTITY = 'OT32'  
 left join [dbo].[COSTCODE] wyd (nolock) on wyd.CCD_CODE = OT32LN_MPK_WYDANIA_POSKI  
 left join [dbo].[COSTCODE] przy (nolock) on przy.CCD_CODE = OT32LN_MPK_PRZYJECIA_POSKI  
   
where [OT_TYPE] = 'SAPO_ZWFOT32'  
and (OT32LN_ANLN1_POSKI = @ANLN1_POSKI  
or (OT32LN_ANLN1_POSKI = @ANLN1_POSKI and OT32DON_ANLN2 = @ANLN2))  
group by OT_CODE, OT32_IF_EQUNR, STA_DESC, OTL_CREUSER, OT32LN_MPK_WYDANIA, wyd.CCD_DESC, OT32LN_MPK_PRZYJECIA, przy.CCD_DESC  
  
union all  
   
select 'MT3' as TypDok, OT_CODE, OT33_IF_EQUNR, STA_DESC, max(OTL_CREDATE) as OTL_CREDATE, OTL_CREUSER, OT33LN_MPK_WYDANIA, wyd.CCD_DESC, '', ''  
from  
[dbo].[SAPO_ZWFOT33LN] (nolock)  
 join [dbo].[SAPO_ZWFOT33] (nolock) on OT33_ROWID = OT33LN_OT33ID  
 join [dbo].[SAPO_ZWFOT33DON] (nolock) on OT33DON_OT33ID = OT33LN_OT33ID  
  left join ASSET don (nolock) on don.AST_CODE = OT33LN_ANLN1_POSKI and don.AST_SUBCODE = OT33DON_ANLN2  
 join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT33LN_ZMT_ROWID  
 join [dbo].[ZWFOT] (nolock) on OT_ROWID = OTL_OTID  
 left join [dbo].[STA] (nolock) on STA_CODE = OT_STATUS and STA_ENTITY = 'OT33'  
 left join [dbo].[COSTCODE] wyd (nolock) on wyd.CCD_CODE = OT33LN_MPK_WYDANIA_POSKI  
where [OT_TYPE] = 'SAPO_ZWFOT33'  
and (OT33LN_ANLN1_POSKI = @ANLN1_POSKI  
or (OT33LN_ANLN1_POSKI = @ANLN1_POSKI and OT33DON_ANLN2 = @ANLN2))  
group by OT_CODE, OT33_IF_EQUNR, STA_DESC, OTL_CREUSER, OT33LN_MPK_WYDANIA, wyd.CCD_DESC  
  
union all  
  
select 'PL' as TypDok, OT_CODE, OT42_IF_EQUNR, STA_DESC, max(OTL_CREDATE) as OTL_CREDATE, OTL_CREUSER, '', '', '', ''  
from  
[dbo].[SAPO_ZWFOT42LN] (nolock)  
 join [dbo].[SAPO_ZWFOT42] (nolock) on OT42_ROWID = OT42LN_OT42ID  
 join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT42LN_ZMT_ROWID  
 join [dbo].[ZWFOT] (nolock) on OT_ROWID = OTL_OTID  
 left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OTL_OBJID]  
 left join [dbo].[STA] (nolock) on STA_CODE = OT_STATUS and STA_ENTITY = 'OT42'  
   
 left join [dbo].[ASSET] (nolock) on AST_CODE = OT42LN_ANLN1_POSKI  
where [OT_TYPE] = 'SAPO_ZWFOT42'  
and OT42LN_ANLN1_POSKI = @ANLN1_POSKI  
group by OT_CODE, OT42_IF_EQUNR, STA_DESC, OTL_CREUSER  
  
union all  
  
select 'LTS' as TypDok, OT_CODE, OT40_IF_EQUNR, STA_DESC, max(OTL_CREDATE) as OTL_CREDATE, OTL_CREUSER, '', '', '', ''  
from  
[dbo].[SAPO_ZWFOT40LN] (nolock)  
 join [dbo].[SAPO_ZWFOT40] (nolock) on OT40_ROWID = OT40LN_OT40ID  
 join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT40LN_ZMT_ROWID  
 join [dbo].[ZWFOT] (nolock) on OT_ROWID = OTL_OTID  
 left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OTL_OBJID]  
 left join [dbo].[STA] (nolock) on STA_CODE = OT_STATUS and STA_ENTITY = 'OT40'  
   
 left join [dbo].[ASSET] (nolock) on AST_CODE = OT40LN_ANLN1_POSKI  
where [OT_TYPE] = 'SAPO_ZWFOT40'  
and OT40LN_ANLN1_POSKI = @ANLN1_POSKI  
group by OT_CODE, OT40_IF_EQUNR, STA_DESC, OTL_CREUSER  
  
union all  
   
select 'LTW' as TypDok, OT_CODE, OT41_IF_EQUNR, STA_DESC, max(OTL_CREDATE) as OTL_CREDATE, OTL_CREUSER, '', '', '', ''  
from  
[dbo].[SAPO_ZWFOT41LN] (nolock)  
 join [dbo].[SAPO_ZWFOT41] (nolock) on OT41_ROWID = OT41LN_OT41ID  
 join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT41LN_ZMT_ROWID  
 join [dbo].[ZWFOT] (nolock) on OT_ROWID = OTL_OTID  
 left join [dbo].[OBJ] (nolock) on OBJ.OBJ_ROWID = [OTL_OBJID]  
 left join [dbo].[STA] (nolock) on STA_CODE = OT_STATUS and STA_ENTITY = 'OT41'  
   
 left join [dbo].[ASSET] (nolock) on AST_CODE = OT41LN_ANLN1_POSKI  
where [OT_TYPE] = 'SAPO_ZWFOT41'  
and OT41LN_ANLN1_POSKI = @ANLN1_POSKI  
group by OT_CODE, OT41_IF_EQUNR, STA_DESC, OTL_CREUSER
GO