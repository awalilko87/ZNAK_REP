SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[INVTSKv] 
as
select
	ITS_ROWID,  
	ITS_CODE, 
	ITS_ORG, 
	ITS_DESC, 
	ITS_DATE, 
	ITS_TIME = (dbo.e2_im_gettimefromdatetime(isnull(ITS_DATE,'1900-01-01'))),
	ITS_STATUS, 
	ITS_STATUS_DESC = (select STA_DESC from STA (nolock) where STA_CODE = ITS_STATUS and STA_ENTITY = 'ITS'),
	ITS_ICONSTATUS = null,-- dbo.[GetStatusImage] ('ITS', ITS_STATUS),
	ITS_TYPE, 
	ITS_TYPE_DESC = null,--(select TYP_DESC from TYP (nolock) where TYP_CODE = ITS_TYPE and TYP_ENTITY = 'ITS'),
	ITS_TYPE2,
	ITS_TYPE2_DESC = null,--(select TYP2.TYP2_DESC from TYP2 (nolock) join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = ITS_TYPE and TYP_ENTITY = 'ITS'),
	ITS_TYPE3,
	ITS_TYPE3_DESC = null,--(select TYP3.TYP3_DESC from TYP3 (nolock) join TYP2 (nolock) on TYP2.TYP2_ROWID = TYP3.TYP3_TYP2ID join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = ITS_TYPE and TYP_ENTITY = 'ITS'),
	ITS_RSTATUS, 
	ITS_CREUSER, 
	ITS_CREUSER_DESC = dbo.UserName(ITS_CREUSER),
	ITS_CREDATE, 
	ITS_UPDUSER, 
	ITS_UPDUSER_DESC = dbo.UserName(ITS_UPDUSER),
	ITS_UPDDATE, 
	ITS_NOTUSED, 
	ITS_ID, 
	ITS_TXT01, 
	ITS_TXT02, 
	ITS_TXT03, 
	ITS_TXT04, 
	ITS_TXT05, 
	ITS_TXT06, 
	ITS_TXT07, 
	ITS_TXT08, 
	ITS_TXT09, 
	ITS_TXT10, 
	ITS_TXT11, 
	ITS_TXT12, 
	ITS_NTX01, 
	ITS_NTX02, 
	ITS_NTX03, 
	ITS_NTX04, 
	ITS_NTX05, 
	ITS_COM01, 
	ITS_COM02, 
	ITS_DTX01, 
	ITS_DTX02, 
	ITS_DTX03, 
	ITS_DTX04, 
	ITS_DTX05,  
	ITS_NOTE, 
	ITS_COSTCODEID, 
	ITS_COSTCODE = (select CCD_CODE from dbo.COSTCODE (nolock) where COSTCODE.CCD_ROWID = ITS_COSTCODEID),
	ITS_SAP_PSPNR,
	ITS_SAP_POST1,
	ITS_SAP_POSID,
	ITS_SAP_OBJNR,
	ITS_SAP_ERNAM,
	ITS_SAP_ERDAT,
	ITS_SAP_AENAM,
	ITS_SAP_AEDAT,
	ITS_SAP_STSPR,
	ITS_SAP_VERNR,
	ITS_SAP_VERNA,
	ITS_SAP_ASTNR,
	ITS_SAP_ASTNA,
	ITS_SAP_VBUKR,
	ITS_SAP_VGSBR,
	ITS_SAP_VKOKR,
	ITS_SAP_PRCTR,
	ITS_SAP_PWHIE,
	ITS_SAP_ZUORD,
	ITS_SAP_PLFAZ,
	ITS_SAP_PLSEZ,
	ITS_SAP_KALID,
	ITS_SAP_VGPLF,
	ITS_SAP_EWPLF,
	ITS_SAP_ZTEHT,
	ITS_SAP_PLNAW,
	ITS_SAP_PROFL,
	ITS_SAP_BPROF,
	ITS_SAP_TXTSP,
	ITS_SAP_KOSTL,
	ITS_SAP_KTRG,
	ITS_SAP_SCPRF,
	ITS_SAP_IMPRF,
	ITS_SAP_PPROF,
	ITS_SAP_ZZKIER,
	ITS_SAP_STUFE,
	ITS_SAP_BANFN,
	ITS_SAP_BNFPO,
	ITS_SAP_ZEBKN,
	ITS_SAP_EBELN,
	ITS_SAP_EBELP,
	ITS_SAP_ZEKKN,
	ITS_SAP_ACTIVE,
	ITS_SAP_PSPHI,
	ITS_STATIONS = Stuff((SELECT N', ' + cast(STN_CODE as nvarchar(10)) FROM STATION (nolock) where STN_ROWID in (select INS_STNID from INVTSK_STATIONS (nolock) where INS_ITSID = ITS_ROWID) FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(max)'),1,2,N''),
	ITS_PSP_COUNT = PSP_TOTALCOUNT,
	ITS_REQ_COUNT = PSP_REQCOUNT,
	ITS_ORD_COUNT = PSP_ORDCOUNT
from [dbo].[INVTSK] (nolock) 
left join (
	select
		 PSP_ITSID
		,PSP_TOTALCOUNT = count(*)
		,PSP_REQCOUNT = count(nullif(PSP_SAP_BANFN,''))
		,PSP_ORDCOUNT = count(nullif(PSP_SAP_EBELN,''))
	from psp
	where isnull(PSP_SAP_ACTIVE,0) = 1
	group by PSP_ITSID)pspcount on PSP_ITSID = ITS_ROWID
GO