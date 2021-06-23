SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[STATION_RENSPONV]
AS SELECT 
STR_ROWID
,STR_STNID
,STR_STN_DESC = case  
       when STN_TYPE = 'STACJA' then isnull ( cast ([STN_CODE]  as nvarchar) ,'') + ' - ' + STN_DESC  
       when STN_TYPE = 'SERWIS' then 'Serwis: ' + STN_DESC  
      end  
,STR_GROUP
,STR_GROUPDESC = (select OBG_CODE +' - '+OBG_DESC from  OBJGROUP where OBG_ROWID = STR_GROUP)
,STR_OBSZAR
,STR_RESPONID
FROM STATION_RENSPON
 left join [dbo].[STATION] (nolock) on STN_ROWID = STR_STNID 
GO