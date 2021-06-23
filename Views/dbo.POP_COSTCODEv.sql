﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create view [dbo].[POP_COSTCODEv]
as
select     
 CCD_ROWID
,CCD_CODE
,CCD_KL5_DEFAULT = CCD_CODE + '0'
,CCD_ORG
,CCD_DESC
,CCD_NOTUSED
,CCD_SAP_MCTXT
,CCD_SAP_KOKRS
,CCD_SAP_KOSTL
,CCD_SAP_DATBI
,CCD_SAP_DATAB
,CCD_SAP_BUKRS
,CCD_SAP_GSBER
,CCD_SAP_KOSAR
,CCD_SAP_VERAK
,CCD_SAP_VERAK_USER
,CCD_SAP_WAERS
,CCD_SAP_ERSDA
,CCD_SAP_USNAM
,CCD_SAP_ABTEI
,CCD_SAP_SPRAS
,CCD_SAP_FUNC_AREA
,CCD_SAP_KOMPL
,CCD_SAP_OBJNR
,CCD_SAP_ACTIVE
from dbo.COSTCODE (nolock)
where CCD_ORG = 'PKN' and CCD_NOTUSED = 0
GO