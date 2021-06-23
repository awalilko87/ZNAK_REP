SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE view [dbo].[AST_INWv]          
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
 , SIN_NOTE          
 , SIN_DATE          
 , SIN_STATUS          
 , SIN_STATUS_DESC = (select STA_DESC from STA where STA_CODE = SIN_STATUS and STA_ENTITY = 'SIN')
 , SIN_RESPON          
 , SIN_RESPON_DESC = dbo.EmpDesc(SIN_RESPON, SIN_ORG)          
 , SIN_ICONSTATUS = dbo.GetStatusImage ('SIN', SIN_STATUS)          
 , SIN_TYPE          
 , SIN_TYPE_DESC = (select TYP_DESC from TYP where typ_code = SIN_TYPE and typ_entity = 'SIN')            
 , SIN_TYPE2          
 , SIN_TYPE2_DESC = (select TYP_DESC from TYP where typ_code = Upper(SIN_TYPE)+'#'+upper(SIN_TYPE2) and typ_entity = 'SIN')           
 , SIN_TYPE3          
 , SIN_TYPE3_DESC = (select TYP_DESC from typ where typ_code = Upper(SIN_TYPE)+'#'+Upper(SIN_TYPE2)+'#'+upper(SIN_TYPE3) and typ_entity = 'SIN')           
 , SIN_RSTATUS           
 , SIN_CREUSER          
 , SIN_CREUSER_DESC = dbo.UserName(SIN_CREUSER)          
 , SIN_CREDATE          
 , SIN_UPDUSER          
 , SIN_UPDUSER_DESC = dbo.UserName(SIN_UPDUSER)          
 , SIN_UPDDATE          
 , SIN_NOTUSED          
 , SIN_ID          
 , SIN_TXT01, SIN_TXT02, SIN_TXT03, SIN_TXT04, SIN_TXT05, SIN_TXT06,SIN_TXT07,SIN_TXT08,SIN_TXT09          
 , SIN_NTX01, SIN_NTX02, SIN_NTX03, SIN_NTX04, SIN_NTX05          
 , SIN_COM01 = ISNULL(
	 reverse(stuff(reverse(   
	   CASE WHEN SIN_COMMITTEE_MEMBER_1  IS NOT NULL THEN SIN_COMMITTEE_MEMBER_1  + ', ' ELSE '' end
	 + CASE WHEN SIN_COMMITTEE_MEMBER_2  IS NOT NULL THEN SIN_COMMITTEE_MEMBER_2  + ', ' ELSE '' END
	 + CASE WHEN SIN_COMMITTEE_MEMBER_3  IS NOT NULL THEN SIN_COMMITTEE_MEMBER_3  + ', ' ELSE '' END
	 + CASE WHEN SIN_COMMITTEE_MEMBER_4  IS NOT NULL THEN SIN_COMMITTEE_MEMBER_4  + ', ' ELSE '' END
	 + CASE WHEN SIN_COMMITTEE_MEMBER_5  IS NOT NULL THEN SIN_COMMITTEE_MEMBER_5  + ', ' ELSE '' END
	 + CASE WHEN SIN_COMMITTEE_MEMBER_6  IS NOT NULL THEN SIN_COMMITTEE_MEMBER_6  + ', ' ELSE '' END
	 + CASE WHEN SIN_COMMITTEE_MEMBER_7  IS NOT NULL THEN SIN_COMMITTEE_MEMBER_7  + ', ' ELSE '' END
	 + CASE WHEN SIN_COMMITTEE_MEMBER_8  IS NOT NULL THEN SIN_COMMITTEE_MEMBER_8  + ', ' ELSE '' END
	 + CASE WHEN SIN_COMMITTEE_MEMBER_9  IS NOT NULL THEN SIN_COMMITTEE_MEMBER_9  + ', ' ELSE '' END
	 + CASE WHEN SIN_COMMITTEE_MEMBER_10 IS NOT NULL THEN SIN_COMMITTEE_MEMBER_10 + ', ' ELSE '' END
	 + CASE WHEN SIN_COMMITTEE_MEMBER_11 IS NOT NULL THEN SIN_COMMITTEE_MEMBER_11 + ', ' ELSE '' END
	 + CASE WHEN SIN_COMMITTEE_MEMBER_12 IS NOT NULL THEN SIN_COMMITTEE_MEMBER_12 + ', ' ELSE '' END
	 ), 1, 2, '')),SIN_COM01) -- SIN_COM01 dodane na potrzeby starych wpisów klienta na prodzie, które dotyczą zespołu spisowego
 , SIN_COM02    
 , SIN_DTX01, SIN_DTX02, SIN_DTX03, SIN_DTX04, SIN_DTX05          
 , SIN_AXAID          
 , SIN_MAGID          
 , SIN_MAG = (select name from st_mag where st_mag.rowid = SIN_MAGID)          
 , SIN_AUTH          
 , SIN_AUTH_DESC = dbo.EmpDesc(SIN_AUTH, SIN_ORG)          
 , SIN_AUTHDATE          
 , SIN_BTN_ENABLE        
 , SIN_ROWGUID          
 , SIN_OS_MAT_ODP     
 , SIN_WG_STAN_DZIEN    
 , SIN_DOD_INDENTY        
 ,[STN_FILTER_ID] as SIN_STNID_VIEW          
 , SIN_STS = STN_DESC          
 , STN_KL5          
 , STN_KL5_DESC  
 , SIN_SPIS_START  
 , SIN_SPIS_END
 , SIN_DEVICE_USER
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
           
FROM dbo.ST_INW(nolock)          
left join dbo.STATIONv (nolock) on STN_ROWID = SIN_STNID          
left join dbo.COSTCODE (nolock) on CCD_ROWID = SIN_CCDID          
where [SIN_AST] = 1


GO