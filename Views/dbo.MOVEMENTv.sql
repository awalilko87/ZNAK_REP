SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[MOVEMENTv]
as
select 
	  MOV_ROWID
	, MOV_STNID
	, MOV_STN = STN_CODE 
	, MOV_STN_DESC = STN_DESC
	, MOV_CCDID
	, MOV_CCD = CCD_CODE
	, MOV_CCD_DESC = CCD_DESC
	, MOV_CODE
	, MOV_ORG
	, MOV_DESC
	, MOV_NOTE
	, MOV_DATE
	, MOV_STATUS 
	, MOV_STATUS_DESC = (select STA_DESC from STA (nolock) where STA_CODE = MOV_STATUS and STA_ENTITY = 'MOV')
	, MOV_RESPON
	, MOV_RESPON_DESC = dbo.EmpDesc(MOV_RESPON, MOV_ORG)
	, MOV_ICONSTATUS =  dbo.[GetStatusImage] ('MOV', MOV_STATUS)
	, MOV_TYPE
	, MOV_TYPE_DESC = (select TYP_DESC from TYP (nolock) where TYP_CODE = MOV_TYPE and TYP_ENTITY = 'MOV')
	, MOV_TYPE2
	, MOV_TYPE2_DESC = (select TYP2.TYP2_DESC from TYP2 (nolock) join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = MOV_TYPE and TYP_ENTITY = 'MOV')
	, MOV_TYPE3
	, MOV_TYPE3_DESC = (select TYP3.TYP3_DESC from TYP3 (nolock) join TYP2 (nolock) on TYP2.TYP2_ROWID = TYP3.TYP3_TYP2ID join TYP (nolock) on TYP.TYP_ROWID = TYP2.TYP2_TYP1ID where TYP2.TYP2_CODE = MOV_TYPE and TYP_ENTITY = 'MOV')
	, MOV_RSTATUS
	, MOV_CREUSER
	, MOV_CREUSER_DESC = dbo.UserName(MOV_CREUSER)
	, MOV_CREDATE
	, MOV_UPDUSER
	, MOV_UPDUSER_DESC = dbo.UserName(MOV_UPDUSER)
	, MOV_UPDDATE
	, MOV_NOTUSED
	, MOV_ID
	, MOV_TXT01, MOV_TXT02, MOV_TXT03, MOV_TXT04, MOV_TXT05, MOV_TXT06,MOV_TXT07,MOV_TXT08,MOV_TXT09
	, MOV_NTX01, MOV_NTX02, MOV_NTX03, MOV_NTX04, MOV_NTX05
	, MOV_COM01, MOV_COM02
	, MOV_DTX01, MOV_DTX02, MOV_DTX03, MOV_DTX04, MOV_DTX05
	, MOV_AUTH
	, MOV_AUTH_DESC = dbo.EmpDesc(MOV_AUTH, MOV_ORG)
	, MOV_AUTHDATE
	, MOV_BTN_ENABLE
	, MOV_LANGID = LangID
	, MOV_ROWGUID

	, MOV_CHECK_OBGID = NULL --zmienna do procedury akceptacji na formatce
	
FROM dbo.MOVEMENT(nolock)
	cross join VS_Langs
	left join dbo.STATION (nolock) on STN_ROWID = MOV_STNID
	left join dbo.COSTCODE (nolock) on CCD_ROWID = MOV_CCDID
 





GO