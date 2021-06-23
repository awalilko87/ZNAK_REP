SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[OBJTECHPROT_PZOV_InsUpd]    
(    
@POT_ROWID int      
,@POT_CODE nvarchar(30)     
,@POT_ORG  nvarchar(30)    
,@POT_DESC nvarchar(80)    
,@POT_DATE datetime     
,@POT_TYPE nvarchar(30)     
,@POT_TXT02 nvarchar(30)     
,@POT_STNID int      
,@POT_KOMISJA  nvarchar(max)    
,@POT_REALIZATOR nvarchar(30)     
,@POT_MANAGER  nvarchar(30)    
,@POT_CREUSER  nvarchar(30)    
,@POT_CREDATE  datetime    
,@POT_UPDUSER  nvarchar(30)    
,@POT_UPDDATE datetime    
,@_UserID nvarchar(30)    
)    
as     
begin    
    
/*Czy istnieje już taki protokół*/    
    
if not exists (select 1 from OBJTECHPROT where POT_ROWID = @POT_ROWID)    
    
begiN     
    
  declare @v_prefix nvarchar(100)       
  select @v_prefix = 'PZO_'+convert(nvarchar,year(getdate()))  --nazwa w formacie INW201200003      
  exec dbo.VS_GetNumber @Type = 'PZO', @Pref = @v_prefix, @Suff = '', @Number = @POT_CODE output     
      
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
   POT_NOTUSED,       
   POT_ID,      
   POT_STNID,      
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
   CHK_GU_DZR,      
   CHK_GU_DZR_USER,      
   CHK_GU_IT,      
   CHK_GU_IT_USER,      
   CHK_GU_RKB,      
   CHK_GU_RKB_USER,      
   CHK_GU_UR,      
   CHK_GU_UR_USER,    
   POT_KOMISJA,    
   POT_MANAGER,    
   POT_REALIZATOR)      
      values (      
    @POT_CODE,       
    @POT_ORG,       
    @POT_DESC,      
    NULL,         
    @POT_TYPE,        
    NULL,         
    NULL,       
    getdate(),      
    @_UserID,        
    @POT_DATE,        
    NULL,       
    NULL,      
    NEWID(),      
    @POT_STNID,      
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,      
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,         
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,       
    NULL,      
    --@p_UZASADNIENIE,      
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    @POT_TXT02,      
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    NULL,      
    NULL,    
    @POT_KOMISJA,    
    @POT_MANAGER,    
    @POT_REALIZATOR      
      )      
       
    SELECT @POT_ROWID = MAX (POT_ROWID) FROM OBJTECHPROT WHERE POT_TYPE = 'PZO'    
    
    /*Sprawdzamy,czy istnieją jakies składniki na zadaniu inwestycyjnym */    
    
    if exists (select 1 from  [INVTSK_NEW_OBJ] (nolock)       
     join dbo.STENCIL (nolock) on STS_ROWID = INO_STSID      
     join dbo.PSP (nolock) on PSP_ROWID = INO_PSPID      
     join dbo.INVTSK (nolock) on ITS_ROWID = PSP_ITSID  where ITS_ROWID = @POT_TXT02 )    
         
     begin     
         
     /*Sprawdzamy, czy te składniki nie isnieją w jakimkolwiek protokole. Jeżeli nie istnieją to wrzucamy wszystkie pod ten protokół*/    
     if not exists ( select 1 from OBJTECHPROTLN where POL_POTID = @POT_ROWID)    
      begin    
          
  insert into OBJTECHPROTLN (POL_CODE,POL_DESC,POL_POTID,POL_TYPE,POL_DATE,POL_ORG,POL_CREDATE,POL_CREUSER)      
      select OBJ_CODE, OBJ_DESC, @POT_ROWID, 'PZO', GETDATE(),@POT_ORG, getdate(), @_UserID    
             
      from [INVTSK_NEW_OBJ] (nolock)       
        join dbo.STENCIL (nolock) on STS_ROWID = INO_STSID      
        join dbo.PSP (nolock) on PSP_ROWID = INO_PSPID      
        join dbo.INVTSK (nolock) on ITS_ROWID = PSP_ITSID      
        left join dbo.OBJ (nolock) on INO_ROWID = OBJ_INOID    
        where ITS_ROWID = @POT_TXT02     
      end    
       
     end    
       
   end    
     
     
  ELSE  
    
  BEGIN  
    
  UPDATE OBJTECHPROT  
    
  SET POT_CODE = @POT_CODE,      
   POT_ORG = @POT_ORG,       
   POT_DESC = @POT_DESC,      
       
   POT_TYPE = @POT_TYPE,            
   POT_STNID = @POT_STNID,          
   POT_TXT02 = @POT_TXT02,         
   POT_KOMISJA = @POT_KOMISJA,    
   POT_MANAGER = @POT_MANAGER,    
   POT_REALIZATOR = @POT_REALIZATOR  
     
  WHERE POT_ROWID = @POT_ROWID  
    
  END  
    
  end    
GO