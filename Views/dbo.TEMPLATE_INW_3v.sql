SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[TEMPLATE_INW_3v]        
AS        
        
SELECT distinct SIN_CREUSER_DESC      
, SIN_CODE      
, SIN_TYPE_DESC as SIN_STATUS_DESC      
, STN_KL5      
, STN_KL5_DESC  
, SIN_CREDATE =  case when LEN(DATEPART(DAY, SIN_CREDATE)) = 1 then '0'+ cast(DATEPART(DAY, SIN_CREDATE) as nvarchar(2)) else cast(DATEPART(DAY, SIN_CREDATE) as nvarchar(2)) end   
  +'.' + case when LEN(DATEPART(MONTH, SIN_CREDATE)) = 1 then '0'+ cast(DATEPART(MONTH, SIN_CREDATE) as nvarchar(2)) else cast(DATEPART(MONTH, SIN_CREDATE) as nvarchar(2)) end   
  +'.' + cast(DATEPART(YEAR, SIN_CREDATE) as nvarchar(4))     
--, convert(varchar(10), SIN_CREDATE, 120) SIN_CREDATE    
  
, SIN_DATE =  case when LEN(DATEPART(DAY, SIN_DATE)) = 1 then '0'+ cast(DATEPART(DAY, SIN_DATE) as nvarchar(2)) else cast(DATEPART(DAY, SIN_DATE) as nvarchar(2)) end   
  +'.' + case when LEN(DATEPART(MONTH, SIN_DATE)) = 1 then '0'+ cast(DATEPART(MONTH, SIN_DATE) as nvarchar(2)) else cast(DATEPART(MONTH, SIN_DATE) as nvarchar(2)) end   
  +'.' + cast(DATEPART(YEAR, SIN_DATE) as nvarchar(4))  
  
, SIN_DOD_INDENTY      
, SIN_STNID_VIEW      
, SIN_OS_MAT_ODP     
, SIN_START_DATA = (select convert(date,SIN_SPIS_START, 120))    
, SIN_START_GODZ = replace(cast((select left (CONVERT(time,SIN_SPIS_START),8)) as nvarchar(8)), ':', '.')   
, SIN_END_DATA = (select convert(date,SIN_SPIS_END, 120))    
, SIN_END_GODZ = replace(cast((select left (CONVERT(time,SIN_SPIS_END),8)) as nvarchar(8)), ':', '.')
, SIN_COMMITTEE_MEMBER_1
, SIN_COMMITTEE_MEMBER_2
, SIN_COMMITTEE_MEMBER_3
, SIN_COMMITTEE_MEMBER_4
, SIN_COMMITTEE_MEMBER_5
, SIN_COMMITTEE_MEMBER_6
, SIN_COMMITTEE_MEMBER_7
, SIN_COMMITTEE_MEMBER_8
, SIN_COMMITTEE_MEMBER_9
, SIN_COMMITTEE_MEMBER_10
, SIN_COMMITTEE_MEMBER_11
, SIN_COMMITTEE_MEMBER_12 
FROM              
 dbo.AST_INWv        
   
GO