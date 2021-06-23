﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[STATIONv]
as
SELECT 
STATION_PLACE.STN_ROWID
 
,STATION_PLACE.STN_PARENTID --wypełaniane przy stacjach - użytkownikach zastępczych (np IT oraz UR)
,STN_PARENT = STATION_MAIN.STN_CODE
,STN_PARENT_DESC = STATION_MAIN.STN_DESC

,STN_CODE = isnull(STATION_PLACE.STN_CODE,0) --0 dla serwisów, NULL nie może być przez filtr na formatce STN_LSRC
,STATION_PLACE.STN_ORG
,STATION_PLACE.STN_ID
,STN_STATUS_DESC = (select STA_DESC from dbo.STA (nolock) where STA_CODE = STATION_PLACE.STN_STATUS and STA_ENTITY = 'STN')
,STATION_PLACE.STN_STATUS
,STATION_PLACE.STN_TYPE
,STN_TYPE_DESC= TYP_DESC
,STATION_PLACE.STN_STREET
,STATION_PLACE.STN_CITY
,STATION_PLACE.STN_VOIVODESHIP
,STN_VOIVODESHIP_DESC = (select [desc] from dbo.VOIVODESHIPv (nolock) where code = STATION_PLACE.STN_VOIVODESHIP)
,STATION_PLACE.STN_CCDID
,STN_CCD = CCD_CODE
,STN_CCD_DESC = CCD_DESC
,STATION_PLACE.STN_KL5ID
,STN_KL5 = KL5_CODE
,STN_KL5_DESC = KL5_DESC
,STATION_PLACE.STN_DESC
,STN_FILTER = case
		when STATION_PLACE.STN_TYPE = 'STACJA' then isnull ( cast (STATION_PLACE.STN_CODE  as nvarchar) ,'') + ' - ' + STATION_PLACE.STN_DESC 
		when STATION_PLACE.STN_TYPE = 'ZASTEPCZY' then isnull ( cast (STATION_PLACE.STN_CODE  as nvarchar) ,'') + ' - ' + STATION_PLACE.STN_DESC 
		--when STATION_PLACE.STN_TYPE = 'SERWIS' then 'Zabranie do serwisu: ' + STATION_PLACE.STN_DESC 
		when STATION_PLACE.STN_TYPE = 'SERWIS' then isnull ( cast (STATION_PLACE.STN_CODE  as nvarchar) ,'') + ' - ' + STATION_PLACE.STN_DESC
		when STATION_PLACE.STN_TYPE = 'BAR' then isnull ( cast (STATION_PLACE.STN_CODE  as nvarchar) ,'') + ' - ' + STATION_PLACE.STN_DESC
	end
,STN_FILTER_ID = case
		when STATION_PLACE.STN_TYPE = 'STACJA' then isnull ( cast (STATION_PLACE.STN_CODE  as nvarchar) ,'') + ' - ' + STATION_PLACE.STN_DESC + ' - ' + right(KL5_CODE, 1)
		when STATION_PLACE.STN_TYPE = 'ZASTEPCZY' then isnull ( cast (STATION_PLACE.STN_CODE  as nvarchar) ,'') + ' - ' + STATION_PLACE.STN_DESC + ' - ' + right(KL5_CODE, 1)
		--when STATION_PLACE.STN_TYPE = 'SERWIS' then 'Zabranie do serwisu: ' + STATION_PLACE.STN_DESC + ' - ' + right(KL5_CODE, 1)
		when STATION_PLACE.STN_TYPE = 'SERWIS' then isnull ( cast (STATION_PLACE.STN_CODE  as nvarchar) ,'') + ' - ' + STATION_PLACE.STN_DESC + ' - ' + right(KL5_CODE, 1)
		when STATION_PLACE.STN_TYPE = 'BAR' then isnull ( cast (STATION_PLACE.STN_CODE  as nvarchar) ,'') + ' - ' + STATION_PLACE.STN_DESC + ' - ' + right(KL5_CODE, 1)
	end
,STATION_PLACE.STN_NOTUSED
,STATION_PLACE.STN_CREDATE
,STATION_PLACE.STN_CREUSER
,STN_CREUSER_DESC = dbo.UserName(STATION_PLACE.STN_CREUSER)
,STATION_PLACE.STN_UPDDATE
,STATION_PLACE.STN_UPDUSER
,STN_UPDUSER_DESC = dbo.UserName(STATION_PLACE.STN_UPDUSER)
FROM dbo.STATION (nolock) STATION_PLACE
left join dbo.STATION (nolock) STATION_MAIN on STATION_MAIN.STN_ROWID = STATION_PLACE.STN_PARENTID
join dbo.COSTCODE (nolock) on CCD_ROWID = STATION_PLACE.STN_CCDID
join dbo.KLASYFIKATOR5 (nolock) on KL5_ROWID = STATION_PLACE.STN_KL5ID
left join dbo.TYP on TYP_CODE = STATION_PLACE.STN_TYPE and TYP_ENTITY = 'STN'
GO