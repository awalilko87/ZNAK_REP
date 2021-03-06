SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[CPO_Update_Proc]        
(          
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
 --@p_UZASADNIENIE nvarchar(70),          
 @p_UCHWALA_OPIS nvarchar(70),          
 @p_CZY_UCHWALA nvarchar(1),          
 @p_CZY_DECYZJA nvarchar(1),          
 @p_DECYZJA_OPIS nvarchar(70),          
 @p_CZY_ZAKRES nvarchar(1),          
 @p_ZAKRES_OPIS nvarchar(70),          
 @p_OCENA_OPIS nvarchar(70),          
 @p_CZY_OCENA nvarchar(1),          
 @p_CZY_EKSPERTYZY nvarchar(1),          
 @p_EKSPERTYZY_OPIS nvarchar(70),          
 @p_SPOSOBLIKW nvarchar(35),          
 @p_PSP_POSKI nvarchar(30),          
 @p_MIESIAC int,        
 @p_ROK int,
 @p_MODERN_PROFILE int,          
 @p_UserID nvarchar(30),         
 @p_apperrortext nvarchar(4000) output          
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
                 
 select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID          
 select @v_Rstatus = isnull(STA_RFLAG,0) from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS          
             
 if --(exists (select 1 from dbo.ST_INWLN where SIL_POTID = @p_ROWID and SIL_STATUS = 'NINW') and @p_STATUS = 'ZATWIERDZONE' and @p_AST = 0) or          
  (exists (select 1 from dbo.OBJTECHPROTLN (nolock) where POL_POTID = @p_ROWID and POL_STATUS = 'NCHK') and @p_STATUS = 'CPO_003')          
 begin          
  select @v_errorcode = 'POT_001'          
  goto errorlabel          
 end  
 
 
        
     -- CZY ZOSTAWIAMY TO SPRAWDZENIE????????          
 --if exists            
  --(select 1 from OBJTECHPROTLN  (nolock)          
  -- join dbo.OBJ (nolock) on OBJ_ROWID = POL_OBJID          
  -- left join dbo.OBJTECHPROTCHECK (nolock) on POC_POTID = POL_POTID and POC_OBGID = OBJ_GROUPID           
  --where           
  -- POL_STATUS <> 'POL_001' and --do przeniesienia          
  -- POL_POTID = @p_ROWID and --w tym formularzu          
  -- POC_OBGID is null ) --nie ma zatwierdzonej grupy w OBJTECHPROTCHECK            
  --and @p_STATUS = 'POT_003'          
            
 --begin          
 -- select @v_errorcode = 'POT_002' --select * from vs_langmsgs where objectid = 'POT_002'          
 -- goto errorlabel          
 --end           
           
           
 if not exists (select * from [dbo].[OBJTECHPROT] (nolock) where POT_ID = @p_ID)          
 begin          
           
  declare @v_prefix nvarchar(100)          
  --select @v_prefix = convert(nvarchar,year(getdate()))+'/'+left(@p_ORG,1)+'/'          
  --select @v_prefix = left(@p_ORG,1)+'_'+convert(nvarchar,year(getdate()))+'_'  --nazwa w formacie C_2012_00011          
  select @v_prefix = 'CPO_'+convert(nvarchar,year(getdate()))  --nazwa w formacie INW201200003          
  exec dbo.VS_GetNumber @Type = 'CPO', @Pref = @v_prefix, @Suff = '', @Number = @p_CODE output          
          
  begin try          
   insert into [dbo].[OBJTECHPROT](          
    POT_CODE,          
    POT_ORG,           
    POT_DESC,          
    POT_STATUS,           
    POT_TYPE,            
    POT_TYPE2,            
    POT_TYPE3,           
    POT_CREDATE,           
    POT_CREUSER,            
    POT_DATE,             
    POT_NOTE,                     
    POT_ID,                   
    POT_COM01,           
    POT_COM02,           
    POT_DTX01,           
    POT_DTX02,           
    POT_DTX03,           
    POT_DTX04,           
    POT_DTX05,           
    POT_NTX01,           
    POT_NTX02,           
    POT_NTX03,           
    POT_NTX04,           
    POT_NTX05,            
    POT_TXT01,           
    POT_TXT02,           
    POT_TXT03,           
    POT_TXT04,           
    POT_TXT05,           
    POT_TXT06,           
    POT_TXT07,           
    POT_TXT08,           
    POT_TXT09,          
    --POT_UZASADNIENIE,          
    POT_UCHWALA_OPIS,          
    POT_CZY_UCHWALA,          
    POT_CZY_DECYZJA,          
    POT_DECYZJA_OPIS,          
    POT_CZY_ZAKRES,          
    POT_ZAKRES_OPIS,          
    POT_OCENA_OPIS,          
    POT_CZY_OCENA,          
    POT_CZY_EKSPERTYZY,          
    POT_EKSPERTYZY_OPIS,          
    POT_SPOSOBLIKW,          
    POT_PSP_POSKI,          
    POT_MIESIAC,        
    POT_ROK,
	POT_MODERN_PROFILE)          
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
    --@p_UZASADNIENIE,          
    @p_UCHWALA_OPIS,          
    @p_CZY_UCHWALA,          
    @p_CZY_DECYZJA,          
    @p_DECYZJA_OPIS,          
    @p_CZY_ZAKRES,          
    @p_ZAKRES_OPIS,          
    @p_OCENA_OPIS,          
    @p_CZY_OCENA,          
    @p_CZY_EKSPERTYZY,          
    @p_EKSPERTYZY_OPIS,          
    @p_SPOSOBLIKW,          
    @p_PSP_POSKI,          
    @p_MIESIAC,         
    @p_ROK, 
	@P_MODERN_PROFILE         
   )          
   select @p_ROWID = IDENT_CURRENT('[dbo].[OBJTECHPROT]')          
  end try          
  begin catch          
   select @v_syserrorcode = error_message()          
   select @v_errorcode = 'ERR_INS'          
   goto errorlabel          
  end catch          
 end           
 else           
 begin           
  declare @ilosc_gu int          
  select @ilosc_gu = CHK_GU_DZR+CHK_GU_IT+CHK_GU_RKB+CHK_GU_UR from OBJTECHPROT where POT_ROWID = @p_ROWID          
           
  if (@p_STATUS = 'POT_003' and @ilosc_gu != (select COUNT(*) from OBJTECHPROTCHECK_GU where POC_POTID = @p_ROWID))          
  begin          
  select @v_errorcode = 'POT_002' --select * from vs_langmsgs where objectid = 'POT_002'          
  goto errorlabel          
  end           
            
  if @p_STATUS = 'CPO_004'          
  begin          
   exec dbo.CPO_CANCEL_Proc @p_ROWID, @p_UserID          
  end          
        
  if exists (select 1 from OBJTECHPROTLN where POL_POTID = @p_ROWID and POL_STATUS = 'CPO_002') and @p_SPOSOBLIKW is null        
  begin        
 set @v_errorcode = 'POT_005'        
 goto errorlabel        
  end        
            
  begin try   
  
  declare @CREUSER nvarchar(30)
  select @CREUSER = POT_CREUSER from OBJTECHPROT where pot_rowid = @p_ROWID

  if @p_UserID <> @CREUSER and @p_STATUS <> @p_STATUS_old
	  begin 
		RaisError('Nie masz uprawnień do zmiany statusu Protokołu',16,1)
	  end 
         
   update [dbo].[OBJTECHPROT] set          
    POT_COM01 = @p_COM01,           
    POT_COM02 = @p_COM02,           
    POT_DTX01 = @p_DTX01,           
    POT_DTX02 = @p_DTX02,           
    POT_DTX03 = @p_DTX03,          
    POT_DTX04 = @p_DTX04,           
    POT_DTX05 = @p_DTX05,           
    POT_NTX01 = @p_NTX01,           
    POT_NTX02 = @p_NTX02,           
    POT_NTX03 = @p_NTX03,           
    POT_NTX04 = @p_NTX04,           
    POT_NTX05 = @p_NTX05,            
    POT_CODE = @p_CODE,            
    POT_DATE = @p_DATE,           
    POT_DESC = @p_DESC,           
    POT_NOTE = @p_NOTE,                   
    POT_ORG = @p_ORG,           
    POT_STATUS = @p_STATUS,             
    POT_RSTATUS = @v_Rstatus,          
    POT_TYPE = @p_TYPE,            
    POT_TYPE2 = @p_TYPE2,             
    POT_TYPE3 = @p_TYPE3,          
    POT_UPDDATE = getdate(),           
    POT_UPDUSER = @p_UserID,            
    POT_TXT01 = @p_TXT01,           
    POT_TXT02 = @p_TXT02,           
    POT_TXT03 = @p_TXT03,           
    POT_TXT04 = @p_TXT04,           
    POT_TXT05 = @p_TXT05,           
    POT_TXT06 = @p_TXT06,           
    POT_TXT07 = @p_TXT07,           
    POT_TXT08 = @p_TXT08,           
    POT_TXT09 = @p_TXT09,          
    --POT_UZASADNIENIE = @p_UZASADNIENIE,          
    POT_UCHWALA_OPIS = @p_UCHWALA_OPIS,          
    POT_CZY_UCHWALA = @p_CZY_UCHWALA,          
    POT_CZY_DECYZJA = @p_CZY_DECYZJA,          
    POT_DECYZJA_OPIS = @p_DECYZJA_OPIS,          
    POT_CZY_ZAKRES = @p_CZY_ZAKRES,          
    POT_ZAKRES_OPIS = @p_ZAKRES_OPIS,          
    POT_OCENA_OPIS = @p_OCENA_OPIS,          
    POT_CZY_OCENA = @p_CZY_OCENA,          
    POT_CZY_EKSPERTYZY = @p_CZY_EKSPERTYZY,          
    POT_EKSPERTYZY_OPIS = @p_EKSPERTYZY_OPIS,          
    POT_SPOSOBLIKW = @p_SPOSOBLIKW,          
    POT_PSP_POSKI = @p_PSP_POSKI,          
    POT_MIESIAC = @p_MIESIAC,         
    POT_ROK = @p_ROK,           
	POT_MODERN_PROFILE = @p_MODERN_PROFILE          
   where POT_ROWID = @p_ROWID          
              
             
  end try          
  begin catch          
   select @v_syserrorcode = error_message()          
   select @v_errorcode = 'ERR_UPD'          
   goto errorlabel          
  end catch          
 end           
           
 if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')           
 begin          
  exec dbo.STAHIST_Add_Proc @p_Pref = 'CPO', @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = @p_STATUS_old, @p_UserID = @p_UserID          
 end          
                    
   
      
     
       return 0          
            
  errorlabel:          
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output          
 raiserror (@v_errortext, 16, 1)           
    select @p_apperrortext = @v_errortext          
    return 1          
END 
GO