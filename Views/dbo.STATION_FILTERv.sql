SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[STATION_FILTERv]  
as  
SELECT   
 STATION_PLACE.STN_ROWID  
,STN_CODE = isnull(STATION_PLACE.STN_CODE,0)  
,STN_TYPE   
,STN_FILTER = case  
    when STATION_PLACE.STN_TYPE = 'STACJA' then isnull ( cast (STATION_PLACE.STN_CODE  as nvarchar) ,'') + ' - ' + STATION_PLACE.STN_DESC   
    when STATION_PLACE.STN_TYPE = 'ZASTEPCZY' then isnull ( cast (STATION_PLACE.STN_CODE  as nvarchar) ,'') + ' - ' + STATION_PLACE.STN_DESC   
    when STATION_PLACE.STN_TYPE = 'SERWIS' then isnull ( cast (STATION_PLACE.STN_CODE  as nvarchar) ,'') + ' - ' + STATION_PLACE.STN_DESC  
    when STATION_PLACE.STN_TYPE = 'BAR' then isnull ( cast (STATION_PLACE.STN_CODE  as nvarchar) ,'') + ' - ' + STATION_PLACE.STN_DESC    
   end  
FROM   
 dbo.STATION (nolock) STATION_PLACE  
where   
 isnull(STN_NOTUSED,0) = 0  
 and STATION_PLACE.STN_TYPE <> 'BAR'
GO