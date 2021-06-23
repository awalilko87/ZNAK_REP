SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT31_Update_Proc]  
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
 @p_BUKRS nvarchar(30),    
 @p_CCD_DEFAULT nvarchar(30),  
 @p_IF_EQUNR nvarchar(30),   
 @p_IF_SENTDATE datetime,  
 @p_IF_STATUS int,  
 @p_IMIE_NAZWISKO nvarchar(80),   
 @p_KROK nvarchar(10),   
 @p_SAPUSER nvarchar(31),  
 @p_ZMT_ROWID int,   
 @p_NR_PM nvarchar(50),  
 @p_OBSZAR nvarchar(30),  
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
  @v_OT31ID int,  
  @v_IF_STATUS int,  
  @v_RSTATUS int  

  
 if @p_STATUS = 'OT31_60'  
  set @p_STATUS = 'OT31_61' --odblokowanie dokumentu (procedura zakłada nowe pozycje do integracji)  
   
 select @v_IF_STATUS = case @p_STATUS   
  when 'OT31_10' then 0  
  when 'OT31_61' then 0  
  when 'OT31_20' then 1  
  else @p_IF_STATUS  
 end  
    
  
 -- czy klucze niepuste  
 if @p_ID is null or @p_CODE is NULL OR @p_ORG IS NULL -- ## dopisac klucze  
 begin  
  select @v_errorcode = 'SYS_003'  
  goto errorlabel  
 end  
  
 if @p_IMIE_NAZWISKO is null  
 begin  
  select @v_errorcode = 'OT_SAPUSER'  
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
    OT_STATUS, OT_RSTATUS, OT_ID, OT_ORG, OT_CODE, OT_TYPE, OT_CREDATE, OT_CREUSER, OT_NR_PM, OT_OBSZAR, OT_COSTCODEID  
   )  
   select   
    @P_STATUS, @v_RSTATUS, @p_ID, @p_ORG, LEFT(NEWID(),5), 'SAPO_ZWFOT31', GETDATE(), @p_UserID, @p_NR_PM, @p_OBSZAR, @p_COSTCODEID  
  
   select @v_OTID = IDENT_CURRENT('ZWFOT')  
     
   if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')       
   begin      
    exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = '-', @p_UserID = @p_UserID      
   end   
       
  END TRY  
  BEGIN CATCH  
   select @v_syserrorcode = error_message()  
   select @v_errorcode = 'OT31_001' -- blad wstawienia  
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
    
   insert into dbo.SAPO_ZWFOT31  
   (    
    OT31_KROK, OT31_BUKRS, OT31_IMIE_NAZWISKO,   
    OT31_IF_STATUS, OT31_IF_SENTDATE, OT31_IF_EQUNR, OT31_ZMT_ROWID, OT31_SAPUSER,  
    OT31_CCD_DEFAULT  
       
   )     
   select    
    @p_KROK, @p_BUKRS, @p_IMIE_NAZWISKO,  
    0,  NULL, NULL, @v_OTID, @p_SAPUSER,  
    @p_CCD_DEFAULT  
   select @v_OT31ID = SCOPE_IDENTITY()  
  
  END TRY  
  BEGIN CATCH  
   select @v_syserrorcode = error_message()  
   select @v_errorcode = 'OT31_002' -- blad wstawienia  
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
   select @v_errorcode = 'SYS_011' -- Próbujesz zmienić kod systemowy.  
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
    OT_NR_PM = @p_NR_PM  
      
   where OT_ID = @P_ID  
      
   if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')       
   begin      
    exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = '-', @p_UserID = @p_UserID      
   end   
       
     --Sprawdza czy jest przynajmniej jedna pozycja przed wysyłką do SAP  
   if (select COUNT(*) from dbo.SAPO_ZWFOT31LN (nolock) where OT31LN_OT31ID = @p_ROWID) < 1  
    and (@p_STATUS = 'OT31_20')   
   begin  
    select @v_syserrorcode = error_message() --select * from vs_langmsgs where objectid = 'OT31_001'   
    select @v_errorcode = 'OT31_001' -- Dokument MT1 musi mieć przynajmniej jedną pozycję  
   goto errorlabel  
   end  
     
      --Aktualizacja doniesień (przy każdym zapisie musi zapewnić aktualność tych danych  
   exec dbo.ZWFOT31DON_Recalculate @p_OT31ID = @p_ROWID  
     
   --w takim przypadku wysyła nowy dokument (wraca ze statusu OT31_60 - Anulowany, z SAPa dostał status 9)  
   if  @p_STATUS_old = 'OT31_60' and @p_STATUS_old <> @p_STATUS and @p_IF_STATUS in (3,9)  
   begin  
      
    --[NAG]  
    --nowy nagłówek do SAP  
    insert into dbo.SAPO_ZWFOT31  
    (    
     OT31_KROK, OT31_BUKRS, OT31_IMIE_NAZWISKO,       
     OT31_IF_STATUS, OT31_IF_SENTDATE, OT31_IF_EQUNR, OT31_ZMT_ROWID, OT31_SAPUSER  
       
    )        
    select   
     @p_KROK, @p_BUKRS, @p_IMIE_NAZWISKO,  
     @v_IF_STATUS, NULL, NULL, @p_ZMT_ROWID, @p_SAPUSER  
       
       
    select @v_OT31ID = IDENT_CURRENT('SAPO_ZWFOT31')  
  

    insert into dbo.SAPO_ZWFOT31LN  
    (    
     OT31LN_LP, OT31LN_BUKRS, OT31LN_ANLN1, OT31LN_UZASADNIENIE, OT31LN_DT_WYDANIA, OT31LN_MPK_WYDANIA,   
     OT31LN_GDLGRP, OT31LN_DT_PRZYJECIA, OT31LN_MPK_PRZYJECIA, OT31LN_UZYTKOWNIK, OT31LN_ZMT_ROWID, OT31LN_PRACOWNIK,  
     OT31LN_OT31ID,  
     OT31LN_ANLN1_POSKI, OT31LN_MPK_WYDANIA_POSKI, OT31LN_GDLGRP_POSKI,  
     OT31LN_MPK_PRZYJECIA_POSKI, OT31LN_UZYTKOWNIK_POSKI  
    )     
    select  
     OT31LN_LP, OT31LN_BUKRS, OT31LN_ANLN1, OT31LN_UZASADNIENIE, OT31LN_DT_WYDANIA, OT31LN_MPK_WYDANIA,   
     OT31LN_GDLGRP, OT31LN_DT_PRZYJECIA, OT31LN_MPK_PRZYJECIA, OT31LN_UZYTKOWNIK, OT31LN_ZMT_ROWID, OT31LN_PRACOWNIK,  
     @v_OT31ID,  
     OT31LN_ANLN1_POSKI, OT31LN_MPK_WYDANIA_POSKI, OT31LN_GDLGRP_POSKI,  
     OT31LN_MPK_PRZYJECIA_POSKI, OT31LN_UZYTKOWNIK_POSKI        
    from dbo.SAPO_ZWFOT31LN (nolock)  
      join dbo.SAPO_ZWFOT31 (nolock) on OT31_ROWID = OT31LN_OT31ID  
       join dbo.ZWFOTLN (nolock) on OTL_ROWID = OT31LN_ZMT_ROWID  
    where   
     OT31_ZMT_ROWID = @p_ZMT_ROWID   
     and OT31_IF_STATUS in (3,9)  
     and isnull(OTL_NOTUSED,0) = 0     
       
    insert into dbo.SAPO_ZWFOT31DON  
    (    
     OT31DON_LP, OT31DON_BUKRS, OT31DON_ANLN1, OT31DON_ANLN2, OT31DON_ZMT_ROWID, OT31DON_OT31ID  
    )     
    select  
     OT31DON_LP, OT31DON_BUKRS, OT31DON_ANLN1, OT31DON_ANLN2, OT31DON_ZMT_ROWID, @v_OT31ID       
    from dbo.SAPO_ZWFOT31DON (nolock)  
      join dbo.SAPO_ZWFOT31 (nolock) on OT31_ROWID = OT31DON_OT31ID  
       join dbo.ZWFOTDON (nolock) on OTD_ROWID = OT31DON_ZMT_ROWID  
    where   
     OT31_ZMT_ROWID = @p_ZMT_ROWID   
     and OT31_IF_STATUS in (3,9)  
     and isnull(OTD_NOTUSED,0) = 0     
       
    --ustawienie statusu 4 historia  
    update dbo.SAPO_ZWFOT31 SET  
      OT31_IF_STATUS = 4  --archiwum  
    where   
     OT31_ZMT_ROWID = @p_ZMT_ROWID   
     and OT31_IF_STATUS in (3,9)  
     
   end  
   --nagłówek integracji (aktualizacja dla nagłówka integracji)  
   else if   
    (@p_STATUS_old <> 'OT31_61' and @p_STATUS in ('OT31_10','OT31_20'))  
    or (@p_STATUS_old = 'OT31_61' and @p_STATUS in ('OT31_20','OT31_61'))    
   begin  
  
    UPDATE dbo.SAPO_ZWFOT31 SET  
     OT31_KROK = @p_KROK, OT31_BUKRS = @p_BUKRS, OT31_IMIE_NAZWISKO = @p_IMIE_NAZWISKO,       
     OT31_IF_STATUS = @v_IF_STATUS, OT31_IF_SENTDATE = @p_IF_SENTDATE, OT31_IF_EQUNR = @p_IF_EQUNR, OT31_SAPUSER = @p_SAPUSER,  
      OT31_CCD_DEFAULT = @p_CCD_DEFAULT  
    where   
     OT31_ZMT_ROWID = @p_ZMT_ROWID   
     and OT31_IF_STATUS not in (3,4) --nie aktualizuje historycznych (IF_STATUS = 4)  
       
   end  
  
  END TRY  
  BEGIN CATCH  
   select @v_syserrorcode = error_message()  
   select @v_errorcode = 'OT31_002' -- blad aktualizacji   
   goto errorlabel  
  END CATCH;  
     
 end  
  
 if @p_STATUS = 'OT31_20'  
  update OBJ set OBJ_STATUS = 'OBJ_005' where OBJ_ROWID in --Przenoszony  
 ( select OBJID from dbo.GetBlockedObjOT(@p_ID)  
  /*select OBA_OBJID from dbo.ASSET (nolock)   
   join dbo.OBJASSET (nolock) on OBA_ASTID = AST_ROWID  
  where   
   AST_SAP_ANLN1 + AST_SAP_ANLN2 in (select OT31DON_ANLN1 + OT31DON_ANLN2  from ZWFOT31DONv where OT31DON_OT31ID = @p_ROWID)*/  
 )  
  
 if @p_STATUS = 'OT31_70'  
  update OBJ set OBJ_STATUS = 'OBJ_002' where OBJ_ROWID in --Przenoszony  
 ( select OBJID from dbo.GetBlockedObjOT(@p_ID)  
  /*select OBA_OBJID from dbo.ASSET (nolock)   
   join dbo.OBJASSET (nolock) on OBA_ASTID = AST_ROWID  
  where   
   AST_SAP_ANLN1 + AST_SAP_ANLN2 in (select OT31DON_ANLN1 + OT31DON_ANLN2  from ZWFOT31DONv where OT31DON_OT31ID = @p_ROWID)*/  
 )  
  
  
 return 0  
  
 errorlabel:   
  exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output  
  raiserror (@v_errortext, 16, 1)   
  select @p_apperrortext = @v_errortext  
  return 1  
  
end
GO