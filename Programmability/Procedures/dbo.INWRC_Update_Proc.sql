SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INWRC_Update_Proc](    
 @p_FormID nvarchar(50),    
 @p_ID nvarchar(50),    
 @p_ROWID int,    
 @p_CODE nvarchar(30),    
 @p_ORG nvarchar(30),    
 @p_DESC nvarchar(80),    
 @p_NOTE ntext,    
 @p_DATE datetime,    
 @p_STATUS nvarchar(30),    
 @p_STATUS_old nvarchar(30),    
 @p_TYPE nvarchar(30),    
 @p_TYPE2 nvarchar(30),    
 @p_TYPE3 nvarchar(30),    
 @p_NOTUSED int,    
 @p_TXT01 nvarchar(30),    
 @p_TXT02 nvarchar(30),    
 @p_TXT03 nvarchar(30),    
 @p_TXT04 nvarchar(30),    
 @p_TXT05 nvarchar(30),    
 @p_TXT06 nvarchar(80),    
 @p_TXT07 nvarchar(80),    
 @p_TXT08 nvarchar(255),    
 @p_TXT09 nvarchar(255),    
 @p_NTX01 numeric(24,6),    
 @p_NTX02 numeric(24,6),    
 @p_NTX03 numeric(24,6),    
 @p_NTX04 numeric(24,6),    
 @p_NTX05 numeric(24,6),    
 @p_COM01 ntext,    
 @p_COM02 ntext,    
 @p_DTX01 datetime,    
 @p_DTX02 datetime,    
 @p_DTX03 datetime,    
 @p_DTX04 datetime,    
 @p_DTX05 datetime,    
 @p_RESPON nvarchar(30),    
 @p_MAG nvarchar(80),    
 @p_AST smallint = NULL,    
 @p_CCD nvarchar(30),    
 @p_STNID int,  
 @p_SIN_OS_MAT_ODP nvarchar(30),  
 @p_SIN_WG_STAN_DZIEN datetime,  
 @p_SIN_DOD_INDENTY nvarchar(30), 
 @p_SIN_SPIS_START datetime,
 @p_SIN_SPIS_END datetime,   
 @p_SIN_DEVICE_USER nvarchar(30), 
 @p_UserID nvarchar(30),     
 @p_apperrortext nvarchar(4000) output,
 @p_SIN_COMMITTEE_MEMBER_1 nvarchar(80),
 @p_SIN_COMMITTEE_MEMBER_2 nvarchar(80),
 @p_SIN_COMMITTEE_MEMBER_3 nvarchar(80),
 @p_SIN_COMMITTEE_MEMBER_4 nvarchar(80),
 @p_SIN_COMMITTEE_MEMBER_5 nvarchar(80),
 @p_SIN_COMMITTEE_MEMBER_6 nvarchar(80),
 @p_SIN_COMMITTEE_MEMBER_7 nvarchar(80),
 @p_SIN_COMMITTEE_MEMBER_8 nvarchar(80),
 @p_SIN_COMMITTEE_MEMBER_9 nvarchar(80),
 @p_SIN_COMMITTEE_MEMBER_10 nvarchar(80),
 @p_SIN_COMMITTEE_MEMBER_11 nvarchar(80),
 @p_SIN_COMMITTEE_MEMBER_12 nvarchar(80)    
)    
as    
begin      
    
 declare @v_errorcode nvarchar(50)    
 declare @v_syserrorcode nvarchar(4000)    
 declare @v_errortext nvarchar(4000)    
 declare @v_errorid int    
 declare @v_date datetime    
 declare @v_Rstatus int    
 declare @v_Pref nvarchar(10)    
 declare @v_MultiOrg bit    
 declare @v_MAGID int    
 declare @v_AUTH nvarchar(30)    
 declare @v_CCDID int     
 declare @v_KL5ID int    
    
 select @p_AST = isnull(@p_AST,0)    
 select top 1 @v_MAGID = ROWID from dbo.ST_MAG(nolock) where name = @p_MAG    
 select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID    
 select @v_Rstatus = isnull(STA_RFLAG,0) from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS    
 select @v_AUTH = dbo.GetEmpFromUser(@p_UserID,@p_ORG, @p_FormID)     
      
 if @p_STNID is not null    
 begin    
  select @v_CCDID = STN_CCDID, @v_KL5ID = STN_KL5ID    
  from STATION (nolock)    
  where STN_ROWID = @p_STNID and STN_ORG = @p_ORG    
 end    
 else    
 begin    
  select @v_CCDID = CCD_ROWID from COSTCODE (nolock) where CCD_CODE = @p_CCD and CCD_ORG = @p_ORG    
      
  set @v_KL5ID = null    
 end    
     
 if --(exists (select 1 from dbo.ST_INWLN where SIL_SINID = @p_ROWID and SIL_STATUS = 'NINW') and @p_STATUS = 'ZATWIERDZONE' and @p_AST = 0) or    
  (exists (select 1 from dbo.AST_INWLN where SIA_SINID = @p_ROWID and SIA_STATUS = 'NINW') and @p_STATUS = 'ZATWIERDZONE' and @p_AST = 1)    
 begin    
  select @v_errorcode = 'INW_001'    
  goto errorlabel    
 end      
    
 if not exists (select * from dbo.ST_INW (nolock) where SIN_ID = @p_ID)    
 begin    
  declare @v_prefix nvarchar(100)    
  --select @v_prefix = convert(nvarchar,year(getdate()))+'/'+left(@p_ORG,1)+'/'    
  --select @v_prefix = left(@p_ORG,1)+'_'+convert(nvarchar,year(getdate()))+'_'  --nazwa w formacie C_2012_00011    
  select @v_prefix = 'INW_'+convert(nvarchar,year(getdate()))  --nazwa w formacie INW201200003    
  exec dbo.VS_GetNumber @Type = 'SIN', @Pref = @v_prefix, @Suff = '', @Number = @p_CODE output    
    
  begin try    
   insert into dbo.ST_INW(    
    SIN_CODE,    
    SIN_ORG,     
    SIN_DESC,    
    SIN_STATUS,     
    SIN_TYPE,      
    SIN_TYPE2,      
    SIN_TYPE3,     
    SIN_CREDATE,     
    SIN_CREUSER,      
    SIN_DATE,       
    SIN_NOTE,     
    SIN_NOTUSED,     
    SIN_ID,    
    SIN_COM01,     
    SIN_COM02,     
    SIN_DTX01,     
    SIN_DTX02,     
    SIN_DTX03,     
    SIN_DTX04,     
    SIN_DTX05,     
    SIN_NTX01,     
    SIN_NTX02,     
    SIN_NTX03,     
    SIN_NTX04,     
    SIN_NTX05,      
    SIN_TXT01,     
    SIN_TXT02,     
    SIN_TXT03,     
    SIN_TXT04,     
    SIN_TXT05,     
    SIN_TXT06,     
    SIN_TXT07,     
    SIN_TXT08,     
    SIN_TXT09,    
    SIN_MAGID,    
	SIN_AST,    
    SIN_RESPON,    
    SIN_BTN_ENABLE,    
    SIN_CCDID,    
    SIN_STNID,    
    SIN_KL5ID,  
    SIN_OS_MAT_ODP,  
    SIN_WG_STAN_DZIEN,  
    SIN_DOD_INDENTY ,
    SIN_SPIS_START,
    SIN_SPIS_END,
	SIN_DEVICE_USER,
	SIN_COMMITTEE_MEMBER_1,
	SIN_COMMITTEE_MEMBER_2,
	SIN_COMMITTEE_MEMBER_3,
	SIN_COMMITTEE_MEMBER_4,
	SIN_COMMITTEE_MEMBER_5,
	SIN_COMMITTEE_MEMBER_6,
	SIN_COMMITTEE_MEMBER_7,
	SIN_COMMITTEE_MEMBER_8,
	SIN_COMMITTEE_MEMBER_9,
	SIN_COMMITTEE_MEMBER_10,
	SIN_COMMITTEE_MEMBER_11,
	SIN_COMMITTEE_MEMBER_12
    )    
   values (    
    @p_CODE,     
    @p_ORG,     
    @p_DESC,    
    @p_STATUS,       
    @p_TYPE,      
    @p_TYPE2,       
    @p_TYPE3,     
    getdate(),    
    @p_UserID,      
    @p_DATE,      
    @p_NOTE,     
    @p_NOTUSED,    
    @p_ID,    
    @p_COM01,     
    @p_COM02,     
    @p_DTX01,         
    @p_DTX02,     
    @p_DTX03,     
    @p_DTX04,    
    @p_DTX05,     
    @p_NTX01,     
    @p_NTX02,     
    @p_NTX03,     
    @p_NTX04,     
    @p_NTX05,       
    @p_TXT01,     
    @p_TXT02,     
    @p_TXT03,     
    @p_TXT04,     
    @p_TXT05,     
    @p_TXT06,     
    @p_TXT07,     
    @p_TXT08,     
    @p_TXT09,    
    @v_MAGID,    
    @p_AST,    
    @p_RESPON,    
    0,    
    @v_CCDID,    
    @p_STNID,    
    @v_KL5ID,  
    @p_SIN_OS_MAT_ODP,  
    @p_SIN_WG_STAN_DZIEN,  
    @p_SIN_DOD_INDENTY ,
    @p_SIN_SPIS_START,
    @p_SIN_SPIS_END,
	@p_SIN_DEVICE_USER,
	@p_SIN_COMMITTEE_MEMBER_1,
	@p_SIN_COMMITTEE_MEMBER_2,
	@p_SIN_COMMITTEE_MEMBER_3,
	@p_SIN_COMMITTEE_MEMBER_4,
	@p_SIN_COMMITTEE_MEMBER_5,
	@p_SIN_COMMITTEE_MEMBER_6,
	@p_SIN_COMMITTEE_MEMBER_7,
	@p_SIN_COMMITTEE_MEMBER_8,
	@p_SIN_COMMITTEE_MEMBER_9,
	@p_SIN_COMMITTEE_MEMBER_10,
	@p_SIN_COMMITTEE_MEMBER_11,
	@p_SIN_COMMITTEE_MEMBER_12     
    )    
        
   select @p_ROWID = IDENT_CURRENT('dbo.ST_INW')    
       
  end try    
  begin catch    
   select @v_syserrorcode = error_message()    
   select @v_errorcode = 'ERR_INS'    
   goto errorlabel    
  end catch    
 end     
 else     
 begin     
  begin try    
   update dbo.ST_INW set    
    SIN_MAGID = @v_MAGID,    
    SIN_AST = @p_AST,    
    SIN_RESPON = @p_RESPON,    
    SIN_COM01 = @p_COM01,     
    SIN_COM02 = @p_COM02,     
    SIN_DTX01 = @p_DTX01,     
    SIN_DTX02 = @p_DTX02,     
    SIN_DTX03 = @p_DTX03,    
    SIN_DTX04 = @p_DTX04,     
    SIN_DTX05 = @p_DTX05,     
    SIN_NTX01 = @p_NTX01,     
    SIN_NTX02 = @p_NTX02,     
    SIN_NTX03 = @p_NTX03,     
    SIN_NTX04 = @p_NTX04,     
    SIN_NTX05 = @p_NTX05,      
    SIN_CODE = @p_CODE,      
    SIN_DATE = @p_DATE,     
    SIN_DESC = @p_DESC,     
    SIN_NOTE = @p_NOTE,     
    SIN_NOTUSED = @p_NOTUSED,     
    SIN_ORG = @p_ORG,     
    SIN_STATUS = @p_STATUS,       
    SIN_RSTATUS = @v_Rstatus,    
    SIN_TYPE = @p_TYPE,      
    SIN_TYPE2 = @p_TYPE2,       
    SIN_TYPE3 = @p_TYPE3,       
    SIN_UPDDATE = getdate(),     
    SIN_UPDUSER = @p_UserID,      
    SIN_TXT01 = @p_TXT01,     
    SIN_TXT02 = @p_TXT02,     
    SIN_TXT03 = @p_TXT03,     
    SIN_TXT04 = @p_TXT04,     
    SIN_TXT05 = @p_TXT05,     
    SIN_TXT06 = @p_TXT06,     
    SIN_TXT07 = @p_TXT07,     
    SIN_TXT08 = @p_TXT08,     
    SIN_TXT09 = @p_TXT09,    
    SIN_CCDID = @v_CCDID,    
    SIN_STNID = @p_STNID,    
    SIN_KL5ID = @v_KL5ID,  
    SIN_OS_MAT_ODP  =  @p_SIN_OS_MAT_ODP,  
    SIN_WG_STAN_DZIEN = @p_SIN_WG_STAN_DZIEN ,  
    SIN_DOD_INDENTY = @p_SIN_DOD_INDENTY ,
    SIN_SPIS_START =  @p_SIN_SPIS_START, 
    SIN_SPIS_END = @p_SIN_SPIS_END,
	SIN_DEVICE_USER = @p_SIN_DEVICE_USER,
	SIN_COMMITTEE_MEMBER_1 = @p_SIN_COMMITTEE_MEMBER_1,
	SIN_COMMITTEE_MEMBER_2 = @p_SIN_COMMITTEE_MEMBER_2,
	SIN_COMMITTEE_MEMBER_3 = @p_SIN_COMMITTEE_MEMBER_3,
	SIN_COMMITTEE_MEMBER_4 = @p_SIN_COMMITTEE_MEMBER_4,
	SIN_COMMITTEE_MEMBER_5 = @p_SIN_COMMITTEE_MEMBER_5,
	SIN_COMMITTEE_MEMBER_6 = @p_SIN_COMMITTEE_MEMBER_6,
	SIN_COMMITTEE_MEMBER_7 = @p_SIN_COMMITTEE_MEMBER_7,
	SIN_COMMITTEE_MEMBER_8 = @p_SIN_COMMITTEE_MEMBER_8,
	SIN_COMMITTEE_MEMBER_9 = @p_SIN_COMMITTEE_MEMBER_9,
	SIN_COMMITTEE_MEMBER_10 = @p_SIN_COMMITTEE_MEMBER_10,
	SIN_COMMITTEE_MEMBER_11 = @p_SIN_COMMITTEE_MEMBER_11,
	SIN_COMMITTEE_MEMBER_12 = @p_SIN_COMMITTEE_MEMBER_12         
   where SIN_ROWID = @p_ROWID    
       
       
  end try    
  begin catch    
   select @v_syserrorcode = error_message()    
   select @v_errorcode = 'ERR_UPD'    
   goto errorlabel    
  end catch    
 end     
     
 if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')     
 begin    
  exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = @p_STATUS_old, @p_UserID = @p_UserID    
 end    
    
 /* teraz tylko ST    
 if @p_STATUS = 'ZATWIERDZONE' and isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')    
 begin    
  declare @sil_rowid int,     
   @sil_assortid int,    
   @sil_newqty decimal(30,6),    
   @sil_price decimal(30,6),    
   @sil_code nvarchar(30),    
   @sil_lp int,    
   @sil_mag nvarchar(30),    
   @sil_place nvarchar(30)    
    
  declare  pozycje cursor for    
  select     
   ROWID SIL_ROWID,     
   SIL_ASSORTID,     
   SIL_NEWQTY,     
   SIL_PRICE,    
   SIL_CODE,     
   SIL_LP,--row_number() over (partition by SIL_SINID order by ROWID) SIL_LP,    
   SIL_MAG,    
   SIL_PLACE    
  from dbo.ST_INWLNv(nolock)    
  where SIL_SINID = @p_ROWID    
        
  open pozycje    
  fetch next from pozycje into @sil_rowid, @sil_assortid, @sil_newqty, @sil_price, @sil_code, @sil_lp, @sil_mag, @sil_place    
  while @@fetch_status = 0    
  begin     
   exec @v_errorid = dbo.ST_IN_Proc    
    @sil_assortid,--@p_ASSORTID int,    
    @sil_newqty,--@p_QTY numeric(30,6),    
    @sil_price,--@p_PRICE    
    @sil_code,--@p_DOCNUMBER nvarchar(30),    
    @sil_lp,--@p_DOCLN int,    
    @sil_rowid,--@p_DOCLNID int,    
    @sil_mag,--@p_MAG nvarchar(80),    
    @sil_place,--@p_PLACE nvarchar(80),    
    @p_UserID,    
    null,--@p_AXAID numeric(32,0) = null,    
    @p_apperrortext output    
   if @v_errorid <> 0    
   begin    
    close pozycje    
    deallocate pozycje    
    select @v_errorcode = ''    
    goto errorlabel    
   end    
       
   fetch next from pozycje into @sil_rowid, @sil_assortid, @sil_newqty, @sil_price, @sil_code, @sil_lp, @sil_mag, @sil_place    
  end    
    
  close pozycje    
  deallocate pozycje     
    
  begin try    
   if @v_AUTH is null    
   begin    
    select @v_errorcode = 'USR_EMP'    
    goto errorlabel    
   end    
   update dbo.ST_INW set    
     SIN_AUTH = @v_AUTH    
    ,SIN_AUTHDATE = getdate()    
   where SIN_ROWID = @p_ROWID    
  end try    
  begin catch    
   select @v_syserrorcode = error_message()    
   select @v_errorcode = 'ERR_UPD'    
   goto errorlabel    
  end catch    
 end    
 */    
    
 exec [dbo].[INWAST_ADD_MULTI_BY_CCD_Proc]    
  'INWAST_RC',    
  @p_ID,     
  @p_UserID,     
  @p_apperrortext output    
         
  return 0    
      
  errorlabel:    
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output    
 raiserror (@v_errortext, 16, 1)     
    select @p_apperrortext = @v_errortext    
    return 1    
END 
GO