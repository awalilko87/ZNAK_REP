SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[ASTOBJ_FILTERv] 
as
SELECT [OBJ_USERID]
      ,[OBJ_CODE]
      ,[OBJ_DESC]
      ,[OBJ_GROUP]
      ,[OBJ_STATION]
      ,[OBJ_STATION_VIEW] = (select top 1 STN_FILTER from STATION_FILTERv (nolock) where STN_CODE = [OBJ_STATION] and STN_TYPE in ('STACJA', 'SERWIS')) 
      ,[OBJ_TYPE]
      ,[OBJ_PSP]
      ,[OBJ_ASSET]
      ,[OBJ_ID]
      ,[OBJ_CREUSER]
      ,[OBJ_CREDATE]
      ,[OBJ_NOTUSED]
  FROM [dbo].[ASTOBJ_FILTER]
GO