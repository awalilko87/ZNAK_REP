SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT42_Update_Proc]         
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
 @p_UZASADNIENIE nvarchar(70),        
 @p_KOSZT nvarchar(15),        
 @p_SZAC_WART_ODZYSKU nvarchar(15),        
 @p_SPOSOBLIKW  nvarchar(35),         
 @p_PSP_POSKI nvarchar(30),        
 @p_ROK int,        
 @p_MIESIAC int,        
 @p_CZY_UCHWALA nvarchar(1),        
 @p_CZY_DECYZJA nvarchar(1),        
 @p_CZY_ZAKRES nvarchar(1),        
 @p_CZY_OCENA nvarchar(1),        
 @p_CZY_EKSPERTYZY nvarchar(1),        
 @p_UCHWALA_OPIS nvarchar(70),        
 @p_DECYZJA_OPIS nvarchar(70),        
 @p_ZAKRES_OPIS nvarchar(70),        
 @p_OCENA_OPIS nvarchar(70),        
 @p_EKSPERTYZY_OPIS nvarchar(70),        
 @p_IF_EQUNR nvarchar(30),        
 @p_IF_SENTDATE datetime,        
 @p_IF_STATUS int,        
 @p_SAPUSER nvarchar(12),        
 @p_IMIE_NAZWISKO nvarchar(80),        
 @p_ZMT_ROWID int,        
 @p_OBSZAR nvarchar(30),    
 @p_COSTCODEID int,      
 @p_NR_SZKODY nvarchar(30), 
 @p_POTID int,       
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
  @v_ITSID int,        
  @v_OBJID int,        
  @v_MUZYTK nvarchar(30),        
  @v_PSP nvarchar(30),        
  @v_OT42ID int,
  @v_AKCJA nvarchar(20)
         
 if @p_STATUS = 'OT42_60'        
  set @p_STATUS = 'OT42_61' --odblokowanie dokumentu (procedura zakłada nowe pozycje do integracji)        
         
 select @v_IF_STATUS = case
  when @p_STATUS = 'OT42_10' then 0        
  when @p_STATUS = 'OT42_61' then 0        
  when @p_STATUS = 'OT42_20' then 1        
  when @p_STATUS = 'OT40_70' and isnull(@p_IF_EQUNR, '0000000000') <> '0000000000' then 1
  else @p_IF_STATUS        
 end
 --   RaisError ('%s',16,1,@p_ID) 
 --   RaisError ('%s',16,1,@p_CODE) 
	--RaisError ('%s',16,1,@p_ORG) 
         
 select @p_SAPUSER = @p_IMIE_NAZWISKO          
 select @v_ITSID = ITS_ROWID, @v_PSP = ITS_SAP_POSKI from [dbo].[INVTSK] (nolock) where ITS_CODE = @p_PSP_POSKI --pole przekazywane do SAP - Zadanie inw        
         
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
               
 select @p_UCHWALA_OPIS = case when @p_CZY_UCHWALA = 'N' then 'n/d' else @p_UCHWALA_OPIS end        
 select @p_DECYZJA_OPIS = case when @p_CZY_DECYZJA = 'N' then 'n/d' else @p_DECYZJA_OPIS end        
 select @p_ZAKRES_OPIS = case when @p_CZY_ZAKRES = 'N' then 'n/d' else @p_ZAKRES_OPIS end        
 select @p_OCENA_OPIS = case when @p_CZY_OCENA = 'N' then 'n/d' else @p_OCENA_OPIS end        
 select @p_EKSPERTYZY_OPIS = case when @p_CZY_EKSPERTYZY = 'N' then 'n/d' else @p_EKSPERTYZY_OPIS end        
           
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
    @p_STATUS, @v_RSTATUS, @P_ID, @P_ORG, LEFT(NEWID(),5), 'SAPO_ZWFOT42', GETDATE(), @p_UserID, @v_ITSID, NULL, @p_OBSZAR, @p_COSTCODEID        
        
   select @v_OTID = IDENT_CURRENT('ZWFOT')  
   
     
        
     if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')             
     begin            
    exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = '-', @p_UserID = @p_UserID            
     end          
             
  END TRY        
  BEGIN CATCH        
   select @v_syserrorcode = error_message()        
   select @v_errorcode = 'OT42_001' -- blad wstawienia        
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
   insert into dbo.SAPO_ZWFOT42        
   (          
    OT42_KROK,OT42_BUKRS,OT42_IMIE_NAZWISKO,OT42_SAPUSER,        
    OT42_UZASADNIENIE,OT42_KOSZT,OT42_SZAC_WART_ODZYSKU,OT42_SPOSOBLIKW,        
    OT42_PSP,OT42_PSP_POSKI,        
    OT42_MIESIAC,OT42_ROK,        
    OT42_CZY_UCHWALA,        
    OT42_CZY_DECYZJA,        
    OT42_CZY_ZAKRES,        
    OT42_CZY_OCENA,        
    OT42_CZY_EKSPERTYZY,        
    OT42_UCHWALA_OPIS,        
    OT42_DECYZJA_OPIS,        
    OT42_ZAKRES_OPIS,        
    OT42_OCENA_OPIS,        
    OT42_EKSPERTYZY_OPIS,       
    OT42_NR_SZKODY,       
    OT42_IF_STATUS,OT42_IF_SENTDATE,OT42_IF_EQUNR,OT42_ZMT_ROWID, OT42_POTID        
   )           
   select          
    @p_KROK,@p_BUKRS,@p_IMIE_NAZWISKO,@p_SAPUSER,        
    @p_UZASADNIENIE,@p_KOSZT,@p_SZAC_WART_ODZYSKU,@p_SPOSOBLIKW,        
    @v_PSP,@p_PSP_POSKI,        
    @p_MIESIAC,@p_ROK,        
    @p_CZY_UCHWALA,        
    @p_CZY_DECYZJA,        
    @p_CZY_ZAKRES,        
    @p_CZY_OCENA,        
    @p_CZY_EKSPERTYZY,        
    @p_UCHWALA_OPIS,        
    @p_DECYZJA_OPIS,        
    @p_ZAKRES_OPIS,        
    @p_OCENA_OPIS,        
    @p_EKSPERTYZY_OPIS,       
    @p_NR_SZKODY,        
    0,NULL,NULL,@v_OTID, @p_POTID        
        
   select @v_OT42ID = IDENT_CURRENT('SAPO_ZWFOT42')        
        
  END TRY        
  BEGIN CATCH        
   select @v_syserrorcode = error_message()        
   select @v_errorcode = 'OT42_002' -- blad wstawienia        
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
   select @v_errorcode = 'SYS_042' -- blad wspoluzytkowania        
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
    OT_ITSID = @v_ITSID,         
    OT_PSPID = NULL        
            
   where OT_ID = @P_ID        
           
     if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')             
     begin            
    exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = '-', @p_UserID = @p_UserID            
     end       
                 
           
   --w takim przypadku wysyła nowy dokument (wraca ze statusu OT42_60 - Anulowany, z SAPa dostał status 9 - błąd)        
   if  @p_STATUS_old = 'OT42_60' and @p_STATUS_old <> @p_STATUS and @p_IF_STATUS in (3,9)        
   begin        
        
    insert into dbo.SAPO_ZWFOT42        
    (          
     OT42_KROK,OT42_BUKRS,OT42_IMIE_NAZWISKO,OT42_SAPUSER,        
     OT42_UZASADNIENIE,OT42_KOSZT,OT42_SZAC_WART_ODZYSKU,OT42_SPOSOBLIKW,        
     OT42_PSP,OT42_PSP_POSKI,        
     OT42_MIESIAC,OT42_ROK,        
     OT42_CZY_UCHWALA,        
     OT42_CZY_DECYZJA,        
     OT42_CZY_ZAKRES,        
     OT42_CZY_OCENA,        
     OT42_CZY_EKSPERTYZY,        
     OT42_UCHWALA_OPIS,        
     OT42_DECYZJA_OPIS,        
     OT42_ZAKRES_OPIS,        
     OT42_OCENA_OPIS,        
     OT42_EKSPERTYZY_OPIS,        
     OT42_NR_SZKODY,       
     OT42_IF_STATUS,OT42_IF_SENTDATE,OT42_IF_EQUNR,OT42_ZMT_ROWID        
    )           
    select          
     @p_KROK,@p_BUKRS,@p_IMIE_NAZWISKO,@p_SAPUSER,        
     @p_UZASADNIENIE,@p_KOSZT,@p_SZAC_WART_ODZYSKU,@p_SPOSOBLIKW,        
     @v_PSP,@p_PSP_POSKI,        
     @p_MIESIAC,@p_ROK,        
     @p_CZY_UCHWALA,        
     @p_CZY_DECYZJA,        
     @p_CZY_ZAKRES,        
     @p_CZY_OCENA,        
     @p_CZY_EKSPERTYZY,        
     @p_UCHWALA_OPIS,        
     @p_DECYZJA_OPIS,        
     @p_ZAKRES_OPIS,        
     @p_OCENA_OPIS,        
     @p_EKSPERTYZY_OPIS,       
     @p_NR_SZKODY,        
     @v_IF_STATUS,NULL,nullif(@p_IF_EQUNR, 'Brak w SAP'),@p_ZMT_ROWID        
            
    select @v_OT42ID = IDENT_CURRENT('SAPO_ZWFOT42')        
        
    --nowe linie kompletacji OT do integracji w SAP (dane w  ZWFOTLN sie nie zmieniaja!!)        
    insert into dbo.SAPO_ZWFOT42LN        
    (          
     OT42LN_BUKRS, OT42LN_ANLN1, OT42LN_ANLN2, OT42LN_KOSTL, OT42LN_GDLGRP, OT42LN_ODZYSK, OT42LN_LIKWCZESC, OT42LN_PROC,        
     OT42LN_ZMT_ROWID, OT42LN_OT42ID,        
     OT42LN_ANLN1_POSKI, OT42LN_KOSTL_POSKI, OT42LN_GDLGRP_POSKI        
             
    )           
    select         
     OT42LN_BUKRS, OT42LN_ANLN1, OT42LN_ANLN2, OT42LN_KOSTL, OT42LN_GDLGRP, OT42LN_ODZYSK, OT42LN_LIKWCZESC, OT42LN_PROC,        
     OT42LN_ZMT_ROWID, @v_OT42ID,        
     OT42LN_ANLN1_POSKI, OT42LN_KOSTL_POSKI, OT42LN_GDLGRP_POSKI        
    from dbo.SAPO_ZWFOT42LN (nolock)        
      join dbo.SAPO_ZWFOT42 (nolock) on OT42_ROWID = OT42LN_OT42ID        
      join dbo.ZWFOTLN (nolock) on OTL_ROWID = OT42LN_ZMT_ROWID        
    where         
     OT42_ZMT_ROWID = @p_ZMT_ROWID         
     and OT42_IF_STATUS in (3,9)        
     and isnull(OTL_NOTUSED,0) = 0        
            
    --ustawienie statusu 4 historia        
    update dbo.SAPO_ZWFOT42 SET        
      OT42_IF_STATUS = 4          
    where         
     OT42_ZMT_ROWID = @p_ZMT_ROWID         
     and OT42_IF_STATUS in (3,9)        
         
   end        
   --nagłówek integracji (aktualizacja dla nagłówka integracji)        
   else if         
    (@p_STATUS_old <> 'OT42_61' and @p_STATUS in ('OT42_10','OT42_20'))        
    or (@p_STATUS_old = 'OT42_61' and @p_STATUS in ('OT42_20','OT42_61','OT42_70'))        
   begin        

	set @v_AKCJA = case
					when @p_STATUS = 'OT40_70' then 'ODRZ'
					when @p_IF_EQUNR is not null then 'AKT'
					else null
				end
        
    UPDATE dbo.SAPO_ZWFOT42 SET        
     OT42_KROK = @p_KROK,        
     OT42_BUKRS = @p_BUKRS,        
     OT42_IMIE_NAZWISKO = @p_IMIE_NAZWISKO,        
     OT42_SAPUSER = @p_SAPUSER,        
     OT42_UZASADNIENIE = @p_UZASADNIENIE,        
     OT42_KOSZT = @p_KOSZT,        
     OT42_SZAC_WART_ODZYSKU = @p_SZAC_WART_ODZYSKU,        
     OT42_SPOSOBLIKW = @p_SPOSOBLIKW,        
     OT42_PSP = @v_PSP,        
     OT42_PSP_POSKI = @p_PSP_POSKI,        
     OT42_MIESIAC = @p_MIESIAC,        
     OT42_ROK = @p_ROK,        
     OT42_CZY_UCHWALA = @p_CZY_UCHWALA,        
     OT42_CZY_DECYZJA = @p_CZY_DECYZJA,        
     OT42_CZY_ZAKRES = @p_CZY_ZAKRES,        
     OT42_CZY_OCENA = @p_CZY_OCENA,        
     OT42_CZY_EKSPERTYZY = @p_CZY_EKSPERTYZY,        
     OT42_UCHWALA_OPIS = @p_UCHWALA_OPIS,        
     OT42_DECYZJA_OPIS = @p_DECYZJA_OPIS,        
     OT42_ZAKRES_OPIS = @p_ZAKRES_OPIS,        
     OT42_OCENA_OPIS = @p_OCENA_OPIS,        
     OT42_EKSPERTYZY_OPIS = @p_EKSPERTYZY_OPIS,      
     OT42_NR_SZKODY = @p_NR_SZKODY,         
     OT42_IF_STATUS = @v_IF_STATUS,        
	 OT42_IF_AKCJA = @v_AKCJA
    where OT42_ZMT_ROWID = @p_ZMT_ROWID and OT42_IF_STATUS not in (3,4)        
         
   end        
        
  END TRY        
  BEGIN CATCH        
   select @v_syserrorcode = error_message()        
   select @v_errorcode = 'OT42_002' -- blad aktualizacji         
   goto errorlabel        
  END CATCH;        
           
 end        
         
 if @p_STATUS = 'OT42_20'        
  update OBJ set OBJ_STATUS = 'OBJ_006' where OBJ_ROWID in --W likwidacji        
 ( select OBJID from dbo.GetBlockedObjOT(@p_ID)        
  /*select OBA_OBJID from dbo.ASSET (nolock)         
   join dbo.OBJASSET (nolock) on OBA_ASTID = AST_ROWID        
  where         
   AST_SAP_ANLN1 + AST_SAP_ANLN2 in (select OT42LN_ANLN1 + OT42LN_ANLN2  from ZWFOT42LNv where OT42LN_OT42ID = @p_ROWID)*/        
 )        
         
 if @p_STATUS = 'OT42_70'        
  update OBJ set OBJ_STATUS = 'OBJ_002' where OBJ_ROWID in --W likwidacji        
 ( select OBJID from dbo.GetBlockedObjOT(@p_ID)        
  /*select OBA_OBJID from dbo.ASSET (nolock)         
   join dbo.OBJASSET (nolock) on OBA_ASTID = AST_ROWID        
  where         
   AST_SAP_ANLN1 + AST_SAP_ANLN2 in (select OT42LN_ANLN1 + OT42LN_ANLN2  from ZWFOT42LNv where OT42LN_OT42ID = @p_ROWID)*/        
 )        
          
 return 0        
        
 errorlabel:        
  exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output        
  raiserror (@v_errortext, 16, 1)         
  select @p_apperrortext = @v_errortext        
  return 1        
        
end 
GO