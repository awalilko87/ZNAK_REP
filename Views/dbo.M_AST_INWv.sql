SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[M_AST_INWv]
as
select 
	  SIN_ROWID
	, SIN_STNID
	, SIN_STN = STN_CODE 
	, SIN_STN_DESC = STN_DESC
	, SIN_CCDID
	, SIN_CCD = CCD_CODE
	, SIN_CCD_DESC = CCD_DESC
	, SIN_CODE
	, SIN_ORG
	, SIN_DESC
	, SIN_DATE
	, SIN_STATUS
	, SIN_STATUS_DESC = sta.DES_TEXT
	, SIN_RESPON
	, SIN_RESPON_DESC = dbo.EmpDesc(SIN_RESPON, SIN_ORG)
	, SIN_CREUSER
	, SIN_CREUSER_DESC = dbo.UserName(SIN_CREUSER)
	, SIN_CREDATE
	, SIN_ID = CONVERT(uniqueidentifier, SIN_ID)
	, SIN_BTN_ENABLE
	, SIN_M_ACTIVE = convert(nvarchar(30),'')
	, SIN_DEVICE_USER
FROM dbo.ST_INW(nolock)
	cross join VS_Langs
	left join dbo.STATION (nolock) on STN_ROWID = SIN_STNID
	left join dbo.COSTCODE (nolock) on CCD_ROWID = SIN_CCDID
	left join dbo.DESCRIPTIONS_SINv sta(nolock) on sta.DES_TYPE = 'STAT' and sta.DES_CODE = SIN_STATUS and sta.DES_LANGID = LangID
	left join dbo.DESCRIPTIONS_SINv typ1(nolock) on typ1.DES_TYPE = 'TYP1' and typ1.DES_CODE = SIN_TYPE and typ1.DES_LANGID = LangID
	left join dbo.DESCRIPTIONS_SINv typ2(nolock) on typ2.DES_TYPE = 'TYP2' and typ2.DES_CODE = SIN_TYPE+'#'+SIN_TYPE2 and typ2.DES_LANGID = LangID
	left join dbo.DESCRIPTIONS_SINv typ3(nolock) on typ3.DES_TYPE = 'TYP3' and typ3.DES_CODE = SIN_TYPE+'#'+SIN_TYPE2+'#'+SIN_TYPE3 and typ3.DES_LANGID = LangID
where [SIN_AST] = 1 
	and SIN_STATUS = 'SIN_003'
	and LangID = 'PL' 
	and isnull(SIN_NOTUSED,0) = 0

GO