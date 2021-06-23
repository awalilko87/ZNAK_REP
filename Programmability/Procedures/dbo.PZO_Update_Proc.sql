SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[PZO_Update_Proc]    
(    
 @p_FormID nvarchar(50),    
 @p_ID nvarchar(50),    
 @p_ROWID int,    
 @p_STNID int,    
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
 @p_PSP_POSKI nvarchar(30),    
 @p_KOMISJA nvarchar(max),    
 @p_REALIZATOR nvarchar(50),    
 @p_MANAGER nvarchar(30),    
 @p_UserID nvarchar(30),    
 @p_CHK_GU_DZR int,      
 @p_CHK_GU_DZR_USER nvarchar(30),      
 @p_CHK_GU_IT int,      
 @p_CHK_GU_IT_USER nvarchar(30),      
 @p_CHK_GU_RKB int,      
 @p_CHK_GU_RKB_USER nvarchar(30),      
 @p_CHK_GU_UR int,      
 @p_CHK_GU_UR_USER nvarchar(30)      
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
 declare @v_PSP_POSKI_old nvarchar(30)    
 declare @COMMENT nvarchar(max)     
        
 select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID    
 select @v_Rstatus = isnull(STA_RFLAG,0) from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS    
   
 set @COMMENT = 'UWAGI do protokołu:' + cast(@p_NOTE as nvarchar(max))  
    
 if not exists (select * from [dbo].[OBJTECHPROT] (nolock) where POT_ID = @p_ID)    
 begin    
     
  declare @v_prefix nvarchar(100)    
  --select @v_prefix = convert(nvarchar,year(getdate()))+'/'+left(@p_ORG,1)+'/'    
  --select @v_prefix = left(@p_ORG,1)+'_'+convert(nvarchar,year(getdate()))+'_'  --nazwa w formacie C_2012_00011    
  select @v_prefix = 'PZO_'+convert(nvarchar,year(getdate()))  --nazwa w formacie INW201200003    
  exec dbo.VS_GetNumber @Type = 'PZO', @Pref = @v_prefix, @Suff = '', @Number = @p_CODE output    
    
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
    POT_PSP_POSKI,    
    POT_KOMISJA,    
    POT_REALIZATOR,    
    POT_MANAGER,    
	CHK_GU_DZR,      
    CHK_GU_DZR_USER,      
    CHK_GU_IT,      
    CHK_GU_IT_USER,      
    CHK_GU_RKB,      
    CHK_GU_RKB_USER,      
    CHK_GU_UR,      
    CHK_GU_UR_USER    
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
    @p_STNID,    
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
    @p_PSP_POSKI,    
    @p_KOMISJA,    
    @p_REALIZATOR,    
    @p_MANAGER,    
    @p_CHK_GU_DZR,      
    @p_CHK_GU_DZR_USER,      
    @p_CHK_GU_IT,      
    @p_CHK_GU_IT_USER,      
    @p_CHK_GU_RKB,      
    @p_CHK_GU_RKB_USER,      
    @p_CHK_GU_UR,      
    @p_CHK_GU_UR_USER    
   )    
   select @p_ROWID = scope_identity()    
     
   /*Przenoszenie uwag na zakładkę komentarze */  
   
   if @COMMENT is not null
   begin
	exec [dbo].[COMMENTS_PZO_Update] @p_ID, @v_Pref,@COMMENT, @p_UserID  
   end
    
   insert into dbo.OBJTECHPROTLN(POL_POTID, POL_CODE, POL_ORG, POL_CREUSER, POL_CREDATE, POL_RSTATUS, POL_NOTUSED, POL_ID, POL_OBJID, POL_STATUS)    
   select @p_ROWID, '', 'PKN', @p_UserID, getdate(), 0, 0, newid(), OBJ_ROWID, 'PZL_001'    
   from dbo.OBJ    
   inner join dbo.INVTSK_NEW_OBJ on INO_ROWID = OBJ_INOID    
   inner join dbo.PSP on PSP_ROWID = INO_PSPID    
   inner join dbo.INVTSK on ITS_ROWID = PSP_ITSID    
   where ITS_CODE = @p_PSP_POSKI --`and OBJ_ROWID = OBJ_PARENTID
   and INO_STNID = @p_STNID
   and not exists (select 1 from dbo.OBJTECHPROTLN inner join dbo.OBJTECHPROT on POT_ROWID = POL_POTID where POT_TYPE = 'ZDAWCZY' and POL_OBJID = OBJ_ROWID)    
    
   if @@rowcount = 0    
   begin    
    set @v_errorcode = ''    
    set @v_syserrorcode = 'Dla wybranego zadania nie ma składników do ujęcia w protokole.'    
    goto errorlabel    
   end    
    
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
   if @p_STATUS = 'PZO_003' and exists (select 1 from dbo.OBJTECHPROTLN where POL_POTID = @p_ROWID and POL_STATUS = 'PZL_002')    
   begin    
    set @v_errorcode = ''    
    set @v_syserrorcode = 'Nie można zmienić statusu na Potwierdzony. Należy wybrać status Potwierdzony z uwagami.'    
    goto errorlabel    
   end    
    
   select @v_PSP_POSKI_old = POT_PSP_POSKI from dbo.OBJTECHPROT where POT_ROWID = @p_ROWID    
    
   if @v_PSP_POSKI_old <> @p_PSP_POSKI    
   begin    
    if exists (select 1 from dbo.OBJTECHPROTLN where POL_POTID = @p_ROWID and POL_RSTATUS = 1)    
    begin    
     set @v_errorcode = ''    
     set @v_syserrorcode = 'Nie można zmienić zadania inwestycyjnego. Istnieją już składniki odebrane.'    
     goto errorlabel    
    end    
    
    delete from OBJTECHPROTLN where POL_POTID = @p_ROWID    
    
    insert into dbo.OBJTECHPROTLN(POL_POTID, POL_CODE, POL_ORG, POL_CREUSER, POL_CREDATE, POL_RSTATUS, POL_NOTUSED, POL_ID, POL_OBJID, POL_STATUS)    
    select @p_ROWID, '', 'PKN', @p_UserID, getdate(), 0, 0, newid(), OBJ_ROWID, 'PZL_001'    
    from dbo.OBJ    
    inner join dbo.INVTSK_NEW_OBJ on INO_ROWID = OBJ_INOID    
    inner join dbo.PSP on PSP_ROWID = INO_PSPID    
    inner join dbo.INVTSK on ITS_ROWID = PSP_ITSID    
    where ITS_CODE = @p_PSP_POSKI and OBJ_ROWID = OBJ_PARENTID    
    and INO_STNID = @p_STNID
    and not exists (select 1 from dbo.OBJTECHPROTLN inner join dbo.OBJTECHPROT on POT_ROWID = POL_POTID where POT_TYPE = 'ZDAWCZY' and POL_OBJID = OBJ_ROWID)    
    
    if @@rowcount = 0    
    begin    
     set @v_errorcode = ''    
     set @v_syserrorcode = 'Dla wybranego zadania nie ma składników do ujęcia w protokole.'    
     goto errorlabel    
    end    
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
    POT_NOTUSED = @p_NOTUSED,     
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
    POT_PSP_POSKI = @p_PSP_POSKI,    
    POT_KOMISJA = @p_KOMISJA,    
    POT_REALIZATOR = @p_REALIZATOR,    
    POT_MANAGER = @p_MANAGER,    
    CHK_GU_DZR = @p_CHK_GU_DZR,      
    CHK_GU_DZR_USER = @p_CHK_GU_DZR_USER,      
    CHK_GU_IT = @p_CHK_GU_IT,      
    CHK_GU_IT_USER = @p_CHK_GU_IT_USER,      
    CHK_GU_RKB = @p_CHK_GU_RKB,      
    CHK_GU_RKB_USER = @p_CHK_GU_RKB_USER,      
    CHK_GU_UR = @p_CHK_GU_UR,      
    CHK_GU_UR_USER = @p_CHK_GU_UR_USER    
   where POT_ROWID = @p_ROWID    
     
   /*Przenoszenie uwag na zakładkę komentarze */  
   
 if not exists (select 1 from COMMENTS where COM_ID = @p_ID and com_text = @COMMENT) and @COMMENT is not null
  begin  
   exec [dbo].[COMMENTS_PZO_Update] @p_ID, @v_Pref,@COMMENT, @p_UserID  
  end  
  
   if @p_STATUS in ('PZO_003', 'PZO_004') and isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')    
   begin    
    update dbo.OBJ set    
      OBJ_STATUS = 'OBJ_002'    
     ,OBJ_UPDUSER = @p_UserID    
     ,OBJ_UPDDATE = getdate()    
    from dbo.OBJTECHPROTLN    
    where OBJ_ROWID = POL_OBJID and POL_POTID = @p_ROWID and POL_STATUS = 'PZL_001' and isnull(POL_RSTATUS,0) = 0 and OBJ_STATUS = 'OBJ_001'    
    
    update dbo.OBJTECHPROTLN set    
     POL_RSTATUS = 1    
    where POL_POTID = @p_ROWID and POL_STATUS = 'PZL_001' and isnull(POL_RSTATUS,0) = 0    
  
    /*Aktualizacja wartości parametru Uruchomiono dnia':*/
    exec PZO_LN_STATUS_Update @p_ROWID 
   end 
        
   if @p_STATUS <> @p_STATUS_old    
   begin    
    exec dbo.PZO_mail_POT_002_004 @p_ID, @p_STATUS_old    
    exec dbo.PZO_mail_PZO_002 @p_ID    
    
   end    
       
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
    
  return 0    
      
  errorlabel:    
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output    
 raiserror (@v_errortext, 16, 1)     
    return 1    
END 
GO