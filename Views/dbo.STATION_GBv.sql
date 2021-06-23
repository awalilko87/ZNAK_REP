SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create   view [dbo].[STATION_GBv]
as
SELECT 
 STN_ROWID
,STN_PARENTID --wypełaniane przy stacjach - użytkownikach zastępczych (np IT oraz UR)

,STN_CODE = isnull(STN_CODE,0) --0 dla serwisów, NULL nie może być przez filtr na formatce STN_LSRC
,STN_ORG
,STN_ID
,STN_STATUS_DESC = (select STA_DESC from dbo.STA (nolock) where STA_CODE = STN_STATUS and STA_ENTITY = 'STN')
,STN_STATUS
,STN_TYPE
,STN_TYPE_DESC= TYP_DESC
,STN_STREET
,STN_CITY
,STN_VOIVODESHIP
,STN_VOIVODESHIP_DESC = (select [desc] from dbo.VOIVODESHIPv (nolock) where code = STN_VOIVODESHIP)
,STN_CCDID
,STN_CCD = CCD_CODE
,STN_CCD_DESC = CCD_DESC
,STN_KL5ID
,STN_KL5 = KL5_CODE
,STN_KL5_DESC = KL5_DESC
,STN_DESC
,STN_FILTER = case
		when STN_TYPE = 'STACJA' then isnull ( cast (STN_CODE  as nvarchar) ,'') + ' - ' + STN_DESC 
		when STN_TYPE = 'ZASTEPCZY' then isnull ( cast (STN_CODE  as nvarchar) ,'') + ' - ' + STN_DESC 
		--when STN_TYPE = 'SERWIS' then 'Zabranie do serwisu: ' + STN_DESC 
		when STN_TYPE = 'SERWIS' then isnull ( cast (STN_CODE  as nvarchar) ,'') + ' - ' + STN_DESC
		when STN_TYPE = 'BAR' then isnull ( cast (STN_CODE  as nvarchar) ,'') + ' - ' + STN_DESC
	end
,STN_FILTER_ID = case
		when STN_TYPE = 'STACJA' then isnull ( cast (STN_CODE  as nvarchar) ,'') + ' - ' + STN_DESC + ' - ' + right(KL5_CODE, 1)
		when STN_TYPE = 'ZASTEPCZY' then isnull ( cast (STN_CODE  as nvarchar) ,'') + ' - ' + STN_DESC + ' - ' + right(KL5_CODE, 1)
		--when STN_TYPE = 'SERWIS' then 'Zabranie do serwisu: ' + STN_DESC + ' - ' + right(KL5_CODE, 1)
		when STN_TYPE = 'SERWIS' then isnull ( cast (STN_CODE  as nvarchar) ,'') + ' - ' + STN_DESC + ' - ' + right(KL5_CODE, 1)
		when STN_TYPE = 'BAR' then isnull ( cast (STN_CODE  as nvarchar) ,'') + ' - ' + STN_DESC + ' - ' + right(KL5_CODE, 1)
	end
,STN_NOTUSED
,STN_CREDATE
,STN_CREUSER
,STN_CREUSER_DESC = dbo.UserName(STN_CREUSER)
,STN_UPDDATE
,STN_UPDUSER
,STN_UPDUSER_DESC = dbo.UserName(STN_UPDUSER)
,STN_LF
FROM dbo.STATION (nolock) 
join dbo.COSTCODE (nolock) on CCD_ROWID = STN_CCDID
join dbo.KLASYFIKATOR5 (nolock) on KL5_ROWID = STN_KL5ID
left join dbo.TYP on TYP_CODE = STN_TYPE and TYP_ENTITY = 'STN'
where STN_TYPE = 'SERWIS'
GO