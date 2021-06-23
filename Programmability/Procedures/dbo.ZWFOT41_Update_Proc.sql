SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT41_Update_Proc]     
(    
    
 @p_FormID nvarchar(50),     
 @p_ROWID int,    
 @p_CODE nvarchar(30),     
 @p_ID nvarchar(50),    
 @p_ORG nvarchar(30),    
 @p_RSTATUS int,    
 @p_STATUS nvarchar(30),    
 @p_STATUS_old nvarchar(30),    
 @p_TYPE nvarchar(30),    
 @p_KROK nvarchar(10),    
 @p_BUKRS nvarchar(30),    
 @p_IF_EQUNR nvarchar(30),    
 @p_IF_SENTDATE datetime,    
 @p_IF_STATUS int,    
 @p_SAPUSER nvarchar(12),    
 @p_IMIE_NAZWISKO nvarchar(80),    
 @p_ZMT_ROWID int,    
 @p_OBSZAR nvarchar(30),    
 @p_NR_SZKODY nvarchar(30), 
 @p_COSTCODEID int,    
 @p_UserID nvarchar(30) = NULL, -- uzytkownik    
 @p_apperrortext nvarchar(4000) = null output    
     
)    
as    
begin    
     
 declare @v_errorcode nvarchar(50)    
 declare @v_syserrorcode nvarchar(4000)    
 declare @v_errortext nvarchar(4000)    
 declare @v_date datetime     
 declare @v_Pref nvarchar(10)    
 declare @v_MultiOrg BIT    
 declare     
  @v_OTID int,    
  @v_IF_STATUS int,    
  @v_RSTATUS int,     
  @v_MUZYTK nvarchar(30),    
  @v_OT41ID int,
  @v_AKCJA nvarchar(20)   
     
 if @p_STATUS = 'OT41_60'    
  set @p_STATUS = 'OT41_61' --odblokowanie dokumentu (procedura zakłada nowe pozycje do integracji)    
     
 select @v_IF_STATUS = case     
  when @p_STATUS = 'OT41_10' then 0    
  when @p_STATUS = 'OT41_61' then 0    
  when @p_STATUS = 'OT41_20' then 1    
  when @p_STATUS = 'OT40_70' and isnull(@p_IF_EQUNR, '0000000000') <> '0000000000' then 1
  else @p_IF_STATUS    
 end    
    
 if @p_IMIE_NAZWISKO is null    
 begin    
  select @v_errorcode = 'OT_SAPUSER'    
  goto errorlabel    
 end    
    
 if @p_STATUS = 'OT41_20' and not exists (select 1 from dbo.ZWFOT41LNv where OT41LN_OT41ID = @p_ROWID)    
 begin    
  select @v_errorcode = 'OT_NOLINES'    
  goto errorlabel    
 end    
     
 select @p_SAPUSER = @p_IMIE_NAZWISKO     
      
 -- czy klucze niepuste    
 if @p_ID is null or @p_CODE is NULL OR @p_ORG IS NULL -- ## dopisac klucze    
 begin    
  select @v_errorcode = 'SYS_003'    
  goto errorlabel    
 end    
     
 select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID    
 select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS    
    
 set @v_date = getdate()    
            
 --insert    
 if not exists (select * from dbo.ZWFOT (nolock) where OT_ID = @p_ID)    
 begin    
       
  --Nagłówek (jeden dla wszystkich dokumentów do integracji)    
  BEGIN TRY    
   insert into dbo.ZWFOT      
   (     
    OT_STATUS, OT_RSTATUS, OT_ID, OT_ORG, OT_CODE, OT_TYPE, OT_CREDATE, OT_CREUSER, OT_ITSID, OT_PSPID, OT_OBSZAR, OT_COSTCODEID    
   )    
   select     
    @p_STATUS, @v_RSTATUS, @P_ID, @P_ORG, LEFT(NEWID(),5), 'SAPO_ZWFOT41', GETDATE(), @p_UserID, NULL, NULL, @p_OBSZAR, @p_COSTCODEID    
    
   select @v_OTID = IDENT_CURRENT('ZWFOT')    
    
     if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')         
     begin        
    exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = '-', @p_UserID = @p_UserID        
     end      
         
  END TRY    
  BEGIN CATCH    
   select @v_syserrorcode = error_message()    
   select @v_errorcode = 'OT41_001' -- blad wstawienia    
   goto errorlabel    
  END CATCH;    
      
  --Nagłówek dla SAP (Każdy wysłany dokuemnt to jeden wpis)    
  BEGIN TRY    
   --status integracji (inicjowanie) IF_STATUS    
   --0 – nieaktywny (czyli pozycja czeka)    
   --1 – do wysłania (oczekuje na PI)    
   --2 – wysłane (procesowane po stronie PI)    
   --3 – odpowiedź bez błędu    
   --4 - odrzucony (archiwum)    
   --9 – odpowiedź z błędem    
   insert into dbo.SAPO_ZWFOT41    
   (      
    OT41_KROK,OT41_BUKRS,OT41_IMIE_NAZWISKO,OT41_SAPUSER,     
    OT41_IF_STATUS,OT41_IF_SENTDATE,OT41_IF_EQUNR,OT41_ZMT_ROWID , OT41_NR_SZKODY   
   )       
   select      
    @p_KROK,@p_BUKRS,@p_IMIE_NAZWISKO,@p_SAPUSER,     
    0,NULL,NULL,@v_OTID, @p_NR_SZKODY    
    
   select @v_OT41ID = IDENT_CURRENT('SAPO_ZWFOT41')    
       
  END TRY    
  BEGIN CATCH    
   select @v_syserrorcode = error_message()    
   select @v_errorcode = 'OT41_002' -- blad wstawienia    
   goto errorlabel    
  END CATCH;    
  
 end    
 else    
 begin    
    
  if not exists(select * from dbo.ZWFOT (nolock) where OT_ID = @p_ID and ISNULL(OT_STATUS,0) = ISNULL(@p_STATUS_old,0))    
  begin    
   select @v_syserrorcode = error_message()    
   select @v_errorcode = 'SYS_002' -- blad wspoluzytkowania    
   goto errorlabel    
  end       
    
  if exists(select * from dbo.ZWFOT (nolock) where OT_ID = @p_ID AND OT_CODE <> @p_CODE)    
  begin    
   select @v_syserrorcode = error_message()    
   select @v_errorcode = 'SYS_041' -- blad wspoluzytkowania    
   goto errorlabel    
  end       
    
  BEGIN TRY    
       
   --nagłówek    
   update dbo.ZWFOT    
   set     
    OT_STATUS = @P_STATUS,     
    OT_RSTATUS = @v_RSTATUS,     
    OT_ORG = @P_ORG,     
    OT_UPDDATE = getdate(),     
    OT_UPDUSER = @p_UserID,    
    OT_ITSID = NULL,     
    OT_PSPID = NULL    
    
   where OT_ID = @P_ID    
       
     if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')         
     begin        
    exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = '-', @p_UserID = @p_UserID        
     end         
       
   --w takim przypadku wysyła nowy dokument (wraca ze statusu OT41_60 - Anulowany, z SAPa dostał status 9 - błąd)    
   if  @p_STATUS_old = 'OT41_60' and @p_STATUS_old <> @p_STATUS and @p_IF_STATUS in (3,9)    
   begin    
    
    insert into dbo.SAPO_ZWFOT41    
    (      
     OT41_KROK,OT41_BUKRS,OT41_IMIE_NAZWISKO,OT41_SAPUSER,    
     OT41_IF_STATUS,OT41_IF_SENTDATE,OT41_IF_EQUNR,OT41_ZMT_ROWID, OT41_NR_SZKODY    
    )       
    select      
     @p_KROK,@p_BUKRS,@p_IMIE_NAZWISKO,@p_SAPUSER,    
     @v_IF_STATUS,NULL,nullif(@p_IF_EQUNR, 'Brak w SAP'),@p_ZMT_ROWID , @p_NR_SZKODY   
        
    select @v_OT41ID = IDENT_CURRENT('SAPO_ZWFOT41')    
        
    --nowe linie kompletacji OT do integracji w SAP (dane w  ZWFOTLN sie nie zmieniaja!!)    
    insert into dbo.SAPO_ZWFOT41LN    
    (      
        
     OT41LN_BUKRS, OT41LN_ANLN1, OT41LN_KOSTL, OT41LN_GDLGRP, OT41LN_UZASA, OT41LN_MENGE, OT41LN_ZMT_ROWID, OT41LN_OT41ID    
     , OT41LN_ANLN1_POSKI, OT41LN_KOSTL_POSKI, OT41LN_GDLGRP_POSKI    
    )       
    select    
     OT41LN_BUKRS, OT41LN_ANLN1, OT41LN_KOSTL, OT41LN_GDLGRP, OT41LN_UZASA, OT41LN_MENGE, OT41LN_ZMT_ROWID, @v_OT41ID    
     , OT41LN_ANLN1_POSKI, OT41LN_KOSTL_POSKI, OT41LN_GDLGRP_POSKI    
    from dbo.SAPO_ZWFOT41LN (nolock)    
      join dbo.SAPO_ZWFOT41 (nolock) on OT41_ROWID = OT41LN_OT41ID    
      join dbo.ZWFOTLN (nolock) on OTL_ROWID = OT41LN_ZMT_ROWID    
    where     
     OT41_ZMT_ROWID = @p_ZMT_ROWID     
     and OT41_IF_STATUS in (3,9)    
     and isnull(OTL_NOTUSED,0) = 0    
             
    update dbo.SAPO_ZWFOT41 SET    
      OT41_IF_STATUS = 4  --archiwum    
    where     
     OT41_ZMT_ROWID = @p_ZMT_ROWID     
     and OT41_IF_STATUS in (3,9)    
     
    
   end    
   --nagłówek integracji (aktualizacja dla nagłówka integracji)    
   else if     
    (@p_STATUS_old <> 'OT41_61' and @p_STATUS in ('OT41_10','OT41_20'))    
    or (@p_STATUS_old = 'OT41_61' and @p_STATUS in ('OT41_20','OT41_61','OT41_70'))    
   begin    

	set @v_AKCJA = case
					when @p_STATUS = 'OT40_70' then 'ODRZ'
					when @p_IF_EQUNR is not null and @p_IF_EQUNR not in ('Brak w SAP', '0000000000') then 'AKT'
					else null
				end
     
    UPDATE dbo.SAPO_ZWFOT41 SET    
     OT41_KROK = @p_KROK,    
     OT41_BUKRS = @p_BUKRS,    
     OT41_IMIE_NAZWISKO = @p_IMIE_NAZWISKO,    
     OT41_SAPUSER = @p_SAPUSER,    
     OT41_IF_STATUS = @v_IF_STATUS,   
	 OT41_IF_AKCJA = @v_AKCJA,
     OT41_NR_SZKODY = @p_NR_SZKODY      
    where OT41_ZMT_ROWID = @p_ZMT_ROWID and OT41_IF_STATUS not in (3,4)    
    
   end    
    
  END TRY    
  BEGIN CATCH    
   select @v_syserrorcode = error_message()    
   select @v_errorcode = 'OT41_002' -- blad aktualizacji     
   goto errorlabel    
  END CATCH;    
       
 end    
     
 if @p_STATUS = 'OT41_20'    
  update OBJ set OBJ_STATUS = 'OBJ_006' where OBJ_ROWID in --W likwidacji    
 ( select OBJID from dbo.GetBlockedObjOT(@p_ID)    
  /*select OBA_OBJID from dbo.ASSET (nolock)     
   join dbo.OBJASSET (nolock) on OBA_ASTID = AST_ROWID    
  where     
   AST_SAP_ANLN1 in (select OT41LN_ANLN1 from ZWFOT41LNv where OT41LN_OT41ID = @p_ROWID)*/    
 )    
     
 if @p_STATUS = 'OT41_70'    
  update OBJ set OBJ_STATUS = 'OBJ_002' where OBJ_ROWID in --W likwidacji    
 ( select OBJID from dbo.GetBlockedObjOT(@p_ID)    
  /*select OBA_OBJID from dbo.ASSET (nolock)     
   join dbo.OBJASSET (nolock) on OBA_ASTID = AST_ROWID    
  where     
   AST_SAP_ANLN1 in (select OT41LN_ANLN1 from ZWFOT41LNv where OT41LN_OT41ID = @p_ROWID)*/    
 )    
      
 return 0    
    
 errorlabel:    
  exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output    
  raiserror (@v_errortext, 16, 1)     
  select @p_apperrortext = @v_errortext    
  return 1    
    
end 
GO