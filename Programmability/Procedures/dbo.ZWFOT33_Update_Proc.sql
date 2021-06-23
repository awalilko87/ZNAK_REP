SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT33_Update_Proc]          
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
 @p_MTOPER nvarchar(30),            
 @p_CZY_BEZ_ZM nvarchar(1),          
 @p_CZY_ROZ_OKR nvarchar(1),          
 @p_IF_EQUNR nvarchar(30),           
 @p_IF_SENTDATE datetime,          
 @p_IF_STATUS int,          
 @p_IMIE_NAZWISKO nvarchar(80),           
 @p_KROK nvarchar(10),           
 @p_SAPUSER nvarchar(33),          
 @p_ZMT_ROWID int,           
 @p_OT_NR_PM nvarchar(50),          
 @p_TOSTNID INT,
 @p_CCDID int,           
 @p_UserID nvarchar(30) = NULL, -- uzytkownik      
 @p_POTID int,        
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
  @v_OT33ID int,          
  @v_IF_STATUS int,          
  @v_RSTATUS int,          
  @v_OLD_MTOPER nvarchar(30)          
  --@v_PSPID int, --PSP           
  --@v_POSNR int, --PSP          
  --@v_ITSID int, --ZAD INW          
  --@v_SERNR nvarchar(30), --ZAD INW          
  --@v_OBJID int,          
  --@v_MUZYTK nvarchar(30)
  
  
  --RaisError ('%i',16,1, @p_POTID)
  --RaisError ('%i',16,1, @p_RSTATUS)
  --RaisError ('%i',16,1, @p_IF_STATUS)           
  --RaisError ('%i',16,1, @p_TOSTNID)
               
 if @p_STATUS = 'OT33_60'          
  set @p_STATUS = 'OT33_61' --odblokowanie dokumentu (procedura zakłada nowe pozycje do integracji)          
           
 select @v_IF_STATUS = case @p_STATUS           
  when 'OT33_10' then 0          
  when 'OT33_61' then 0          
  when 'OT33_20' then 1 --do wysłania          
  else @p_IF_STATUS          
 end          
           
 if @v_IF_STATUS = 1 and (select count(*) from dbo.SAPO_ZWFOT33DON (nolock) where OT33DON_OT33ID = @p_ROWID and OT33DON_MTOPER = 'X') <> 1          
 begin          
  select @v_errorcode = 'OT33_002'          
  goto errorlabel          
 end          
           
 select @p_SAPUSER = @p_IMIE_NAZWISKO           
 select @v_OLD_MTOPER = OT33_MTOPER from SAPO_ZWFOT33 (nolock) where OT33_ROWID = @p_ROWID          
 --select @v_PSPID = PSP_ROWID, @v_POSNR = PSP_SAP_PSPNR from PSP (nolock) where PSP_CODE = @p_POSNR_ZMT          
 --select @v_ITSID = ITS_ROWID, @v_SERNR = ITS_SAP_POSID from INVTSK (nolock) where ITS_CODE = @p_SERNR_ZMT          
 --select @v_OBJID = OBJ_ROWID from OBJ (nolock) where OBJ_CODE = @p_ZMT_OBJ_CODE           
 --select @v_MUZYTK = STN_DESC from STATION (nolock) where STN_ROWID = @p_MUZYTKID          
 --@p_MUZYTK nieużywane, pobierane z DDLa          
          
 -- czy klucze niepuste          
 if @p_ID is null or @p_CODE is NULL OR @p_ORG IS NULL -- ## dopisac klucze          
 begin          
        
 --RaisError (@p_ID,16,1)        
 --RaisError (@p_CODE,16,1)        
 RaisError (@p_ORG,16,1)        
  --select @v_errorcode = 'SYS_003'          
  --goto errorlabel          
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
    OT_STATUS, OT_RSTATUS, OT_ID, OT_ORG, OT_CODE, OT_TYPE, OT_CREDATE, OT_CREUSER, OT_NR_PM, OT_COSTCODEID          
   )          
   select           
    @P_STATUS, @v_RSTATUS, @p_ID, @p_ORG, LEFT(NEWID(),5), 'SAPO_ZWFOT33', GETDATE(), @p_UserID, @p_OT_NR_PM , @p_CCDID         
          
   select @v_OTID = IDENT_CURRENT('ZWFOT')          
         
   if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')               
   begin              
    exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = '-', @p_UserID = @p_UserID              
   end           
               
  END TRY          
  BEGIN CATCH          
   select @v_syserrorcode = error_message()          
   select @v_errorcode = 'OT33_001' -- blad wstawienia          
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
   insert into dbo.SAPO_ZWFOT33          
   (            
    OT33_KROK, OT33_BUKRS, OT33_IMIE_NAZWISKO, OT33_MTOPER,           
    OT33_CZY_BEZ_ZM, OT33_CZY_ROZ_OKR,          
    OT33_IF_STATUS, OT33_IF_SENTDATE, OT33_IF_EQUNR, OT33_ZMT_ROWID, OT33_SAPUSER , OT33_POTID , OT33_TOSTNID)  
   select            
    @p_KROK, @p_BUKRS, @p_IMIE_NAZWISKO, @p_MTOPER,            
    @p_CZY_BEZ_ZM, @p_CZY_ROZ_OKR,          
    0,  NULL, NULL, @v_OTID, @p_SAPUSER, @p_POTID , @p_TOSTNID         
               
   select @v_OT33ID = SCOPE_IDENTITY()          
          
  END TRY          
  BEGIN CATCH          
   select @v_syserrorcode = error_message()          
   select @v_errorcode = 'OT33_002' -- blad wstawienia          
   goto errorlabel          
  END CATCH;          
/*          
  --pozycje z kompletu ZMT (uzupełnianie tylko podczas wprowadzania nowego OT33, aktualizacja poprzez inne formatki)          
  BEGIN TRY          
          
   --linia kompltacji OT w ZMT          
   insert into dbo.ZWFOTLN           
   (          
    OTL_OTID, OTL_STATUS, OTL_RSTATUS, OTL_ID, OTL_ORG, OTL_CODE, OTL_TYPE, OTL_CREDATE, OTL_CREUSER, OTL_OBJID          
   )          
   select distinct          
    @v_OTID, NULL, 0, newid(), @p_ORG, OT_CODE + '/' + cast(ROW_NUMBER() OVER(PARTITION BY OT_CODE ORDER BY OBJ_DESC ASC) as nvarchar(50)) , NULL, getdate(), @p_UseriD, OBJ_ROWID          
   from OBJ (nolock)           
    join ZWFOT (nolock) on OT_ROWID = @v_OTID          
   where OBJ_PARENTID = @v_OBJID          
          
   --linia kompletacji OT do integracji w SAP          
   insert into dbo.SAPO_ZWFOT33LN          
   (            
    OT33LN_INVNR_NAZWA, OT33LN_CHAR_SKLAD, OT33LN_WART_ELEME, OT33LN_ANLN1, OT33LN_ANLN2, OT33LN_ZMT_ROWID, OT33LN_OT33ID, OT33LN_ZMT_OBJ_CODE          
   )             
   select distinct          
    OBJ_DESC, OBJ_NOTE, 0.0, NULL, NULL, NULL, @v_OT33ID, OBJ_CODE          
   from OBJ (nolock)           
   where OBJ_PARENTID = @v_OBJID          
          
   --uzupełnia OT33LN_ZMT_ROWID (takie trochę przesadzone, generalnie można by to ogarnąć kursorem ale to wydaje mi się jest wydajniejsze - 3 operacje na zbiorach zamiast 2 operacji x ilość przejść kursora)          
   update SAP           
    set SAP.OT33LN_ZMT_ROWID = ZMT.OTL_ROWID          
   from dbo.ZWFOTLN ZMT  (nolock)          
    join dbo.OBJ (nolock) on OBJ.OBJ_ROWID = ZMT.OTL_OBJID          
    join dbo.SAPO_ZWFOT33LN SAP(nolock) on SAP.OT33LN_ZMT_OBJ_CODE = OBJ.OBJ_CODE          
   where           
    SAP.OT33LN_OT33ID = @v_OT33ID          
    and ZMT.OTL_OTID = @v_OTID          
              
          
  END TRY          
  BEGIN CATCH          
   select @v_syserrorcode = error_message()          
   select @v_errorcode = 'OT33_002' -- blad wstawienia          
   goto errorlabel          
  END CATCH;          
*/             
 end          
 else           begin          
          
  if not exists(select * from dbo.ZWFOT (nolock) where OT_ID = @p_ID and ISNULL(OT_STATUS,0) = ISNULL(@p_STATUS_old,0))          
  begin          
   select @v_syserrorcode = error_message()          
   select @v_errorcode = 'SYS_002' -- blad wspoluzytkowania          
   goto errorlabel          
  end             
          
  if exists(select * from dbo.ZWFOT (nolock) where OT_ID = @p_ID AND OT_CODE <> @p_CODE)          
  begin          
   select @v_syserrorcode = error_message()          
   select @v_errorcode = 'SYS_011' -- blad wspoluzytkowania          
   goto errorlabel          
  end             
          
  BEGIN TRY          
            
   if @p_MTOPER = '1'          
   begin          
    update SAPO_ZWFOT33DON set           
     OT33DON_MTOPER = 'X'           
    where           
     OT33DON_ANLN2 = '0000'           
     and OT33DON_OT33ID = @p_ROWID          
   end          
      
   if @p_STATUS <> isnull(@p_STATUS_old,'') and @p_STATUS = 'OT33_20'          
    and exists (select 1 from dbo.ZWFOT33DONv where OT33DON_OT33ID = @p_ROWID and OT33DON_MTOPER = 'X' and isnull(OT33DON_ANLN1_DO_POSKI,'') = '')          
   begin          
    select @v_errorcode = 'OT33_005' -- Nie można zmienić statusu. Składnik docelowy nie został wybrany.          
    goto errorlabel          
   end          
             
   --nagłówek          
   update dbo.ZWFOT          
   set           
    OT_STATUS = @P_STATUS,           
    OT_RSTATUS = @v_RSTATUS,           
    OT_ORG = @P_ORG,           
    OT_UPDDATE = getdate(),           
    OT_UPDUSER = @p_UserID,          
    OT_NR_PM = @p_OT_NR_PM          
              
   where OT_ID = @P_ID          
                
   if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')               
   begin              
    exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = '-', @p_UserID = @p_UserID              
   end           
              
     --Sprawdza czy jest przynajmniej jedna pozycja przed wysyłką do SAP          
   if (select COUNT(*) from dbo.SAPO_ZWFOT33LN (nolock) where OT33LN_OT33ID = @p_ROWID) < 1          
    and (@p_STATUS = 'OT33_20')           
   begin          
    select @v_syserrorcode = error_message() --select * from vs_langmsgs where objectid = 'OT31_001'           
    select @v_errorcode = 'OT33_001' -- Dokument MT1 musi mieć przynajmniej jedną pozycję          
    goto errorlabel          
   end          
             
   --zmiana typu dokuementu          
   if @v_OLD_MTOPER in ('1', '2', '3') and @p_MTOPER not in ('1', '2', '3')          
   begin          
    select @v_errorcode = 'OT33_001' -- Dokument MT1 musi mieć przynajmniej jedną pozycję          
    goto errorlabel          
   end          
             
   if @v_OLD_MTOPER in ('4', '5', '6', '7') and @p_MTOPER not in ('4', '5', '6', '7')          
   begin          
    select @v_errorcode = 'OT33_001' -- Dokument MT1 musi mieć przynajmniej jedną pozycję          
    goto errorlabel          
   end          
             
   if isnull(@v_OLD_MTOPER,'') <> @p_MTOPER          
   begin          
    /*delete from SAPO_ZWFOT33DON where OT33DON_OT33ID = isnull(@p_ROWID,0)          
          
    declare @v_OTD_ROWID int          
    select @v_OTD_ROWID = OTD_ROWID from [dbo].[ZWFOTDON]          
    where OTD_OTID = @p_ZMT_ROWID          
    and OTD_ROWID in (select OBJ_OT33ID from OBJ)          
          
    delete from [dbo].[ZWFOTDON] where OTD_OTID = isnull(@p_ZMT_ROWID,0)          
          
    -- usuwanie wcześniej założonego składnika          
    declare @v_OBJID int          
    select @v_OBJID = OBJ_ROWID from [dbo].[OBJ] where OBJ_OT33ID = @v_OTD_ROWID          
          
    delete from [dbo].[PROPERTYVALUES] where PRV_ENT = 'OBJ' and PRV_PKID = @v_OBJID          
          
    delete from [dbo].[OBJSTATION] where OSA_OBJID = @v_OBJID          
          
    delete from [dbo].[OBJ] where OBJ_ROWID = @v_OBJID*/          
              
    if @v_OLD_MTOPER = 4 and @p_MTOPER = 6          
    begin          
     update dbo.SAPO_ZWFOT33DON set          
      OT33DON_WARST_DO = AST_SAP_URWRT          
      ,OT33DON_PRCNT_DO = 100          
     from dbo.SAPO_ZWFOT33LN          
     inner join dbo.ASSET on AST_CODE = OT33LN_ANLN1_POSKI          
     where OT33DON_OT33ID = @p_ROWID and OT33LN_OT33ID = OT33DON_OT33ID and AST_SUBCODE = OT33DON_ANLN2          
     and OT33DON_MTOPER = 'X'          
    end          
   end          
             
      --Aktualizacja doniesień (przy każdym zapisie musi zapewnić aktualność tych danych          
   exec dbo.ZWFOT33DON_Recalculate @p_OT33ID = @p_ROWID          
             
   --w takim przypadku wysyła nowy dokument (wraca ze statusu OT33_60 - Anulowany, z SAPa dostał status 9)          
   if  @p_STATUS_old = 'OT33_60' and @p_STATUS_old <> @p_STATUS and @p_IF_STATUS in (3,9)          
   begin          
              
    --[NAG]          
    --nowy nagłówek do SAP          
    insert into dbo.SAPO_ZWFOT33          
    (            
     OT33_KROK, OT33_BUKRS, OT33_IMIE_NAZWISKO, OT33_MTOPER,              
     OT33_CZY_BEZ_ZM, OT33_CZY_ROZ_OKR,          
     OT33_IF_STATUS, OT33_IF_SENTDATE, OT33_IF_EQUNR, OT33_ZMT_ROWID, OT33_SAPUSER          
               
    )                
    select           
     @p_KROK, @p_BUKRS, @p_IMIE_NAZWISKO, @p_MTOPER,            
     @p_CZY_BEZ_ZM, @p_CZY_ROZ_OKR,          
     @v_IF_STATUS, NULL, NULL, @p_ZMT_ROWID, @p_SAPUSER          
               
               
    select @v_OT33ID = IDENT_CURRENT('SAPO_ZWFOT33')          
          
    --[LN]          
    --nowe linie kompletacji OT do integracji w SAP (dane w  ZWFOTLN sie nie zmieniaja!!)          
    insert into dbo.SAPO_ZWFOT33LN          
    (            
     OT33LN_LP, OT33LN_BUKRS, OT33LN_ANLN1, OT33LN_DT_WYDANIA, OT33LN_MPK_WYDANIA,           
     OT33LN_GDLGRP, OT33LN_TXT50, OT33LN_UZASADNIENIE, OT33LN_ZMT_ROWID,           
     OT33LN_OT33ID,          
     OT33LN_ANLN1_POSKI, OT33LN_MPK_WYDANIA_POSKI, OT33LN_GDLGRP_POSKI          
    )             
    select          
     OT33LN_LP, OT33LN_BUKRS, OT33LN_ANLN1, OT33LN_DT_WYDANIA, OT33LN_MPK_WYDANIA,           
     OT33LN_GDLGRP, OT33LN_TXT50, OT33LN_UZASADNIENIE, OT33LN_ZMT_ROWID,          
     @v_OT33ID,          
     OT33LN_ANLN1_POSKI, OT33LN_MPK_WYDANIA_POSKI, OT33LN_GDLGRP_POSKI          
                
    from dbo.SAPO_ZWFOT33LN (nolock)          
      join dbo.SAPO_ZWFOT33 (nolock) on OT33_ROWID = OT33LN_OT33ID          
         join dbo.ZWFOTLN (nolock) on OTL_ROWID = OT33LN_ZMT_ROWID          
    where           
     OT33_ZMT_ROWID = @p_ZMT_ROWID           
      and OT33_IF_STATUS in (3,9)          
        and isnull(OTL_NOTUSED,0) = 0            
          
    --[DON]          
    --nowe linie kompletacji OT do integracji w SAP (dane w  ZWFOTLN sie nie zmieniaja!!)          
    insert into dbo.SAPO_ZWFOT33DON          
    (            
     OT33DON_ANLN2, OT33DON_TXT50, OT33DON_WARST, OT33DON_NDJARPER, OT33DON_MTOPER,           
     OT33DON_ANLN1_DO, OT33DON_ANLN2_DO, OT33DON_ANLKL_DO, OT33DON_KOSTL_DO, OT33DON_UZYTK_DO,          
     OT33DON_PRAC_DO, OT33DON_PRCNT_DO, OT33DON_WARST_DO, OT33DON_TXT50_DO, OT33DON_NDPER_DO, OT33DON_CHAR_DO,          
     OT33DON_BELNR, OT33DON_ZMT_ROWID, OT33DON_OT33ID,          
     OT33DON_ANLN1_DO_POSKI, OT33DON_ANLKL_DO_POSKI, OT33DON_KOSTL_DO_POSKI, OT33DON_UZYTK_DO_POSKI          
    )             
    select          
     OT33DON_ANLN2, OT33DON_TXT50, OT33DON_WARST, OT33DON_NDJARPER, OT33DON_MTOPER,           
     OT33DON_ANLN1_DO, OT33DON_ANLN2_DO, OT33DON_ANLKL_DO, OT33DON_KOSTL_DO, OT33DON_UZYTK_DO,          
     OT33DON_PRAC_DO, OT33DON_PRCNT_DO, OT33DON_WARST_DO, OT33DON_TXT50_DO, OT33DON_NDPER_DO, OT33DON_CHAR_DO,          
     OT33DON_BELNR, OT33DON_ZMT_ROWID, @v_OT33ID,          
     OT33DON_ANLN1_DO_POSKI, OT33DON_ANLKL_DO_POSKI, OT33DON_KOSTL_DO_POSKI, OT33DON_UZYTK_DO_POSKI                
    from dbo.SAPO_ZWFOT33DON (nolock)          
      join dbo.SAPO_ZWFOT33 (nolock) on OT33_ROWID = OT33DON_OT33ID          
         join dbo.ZWFOTDON (nolock) on OTD_ROWID = OT33DON_ZMT_ROWID          
    where           
     OT33_ZMT_ROWID = @p_ZMT_ROWID           
      and OT33_IF_STATUS in (3,9)          
        and isnull(OTD_NOTUSED,0) = 0            
                          
    --ustawienie statusu 4 historia          
    update dbo.SAPO_ZWFOT33 SET          
      OT33_IF_STATUS = 4  --archiwum          
    where           
     OT33_ZMT_ROWID = @p_ZMT_ROWID           
     and OT33_IF_STATUS in (3,9)          
            
   end          
   --nagłówek integracji (aktualizacja dla nagłówka integracji)          
   else if           
    (@p_STATUS_old <> 'OT33_61' and @p_STATUS in ('OT33_10','OT33_20'))          
    or (@p_STATUS_old = 'OT33_61' and @p_STATUS in ('OT33_20','OT33_61'))            
   begin          
          
    UPDATE dbo.SAPO_ZWFOT33 SET          
     OT33_KROK = @p_KROK, OT33_BUKRS = @p_BUKRS, OT33_IMIE_NAZWISKO = @p_IMIE_NAZWISKO, OT33_MTOPER = @p_MTOPER,             
     OT33_CZY_BEZ_ZM = @p_CZY_BEZ_ZM, OT33_CZY_ROZ_OKR = @p_CZY_ROZ_OKR,              
     OT33_IF_STATUS = @v_IF_STATUS, OT33_IF_SENTDATE = @p_IF_SENTDATE, OT33_IF_EQUNR = @p_IF_EQUNR, OT33_SAPUSER = @p_SAPUSER          
                
    where           
     OT33_ZMT_ROWID = @p_ZMT_ROWID           
     and OT33_IF_STATUS not in (3,4) --nie aktualizuje historycznych (IF_STATUS = 4)          
          
   end          
          
  END TRY          
  BEGIN CATCH          
   select @v_syserrorcode = error_message()          
   select @v_errorcode = 'OT33_002' -- blad aktualizacji           
   goto errorlabel          
  END CATCH;          
             
 end          
           
 if @p_STATUS = 'OT33_20'          
  update OBJ set OBJ_STATUS = 'OBJ_005' where OBJ_ROWID in --Przenoszony          
 ( select OBJID from dbo.GetBlockedObjOT(@p_ID)          
  /*select OBA_OBJID from dbo.ASSET (nolock)           
   join dbo.OBJASSET (nolock) on OBA_ASTID = AST_ROWID          
  where           
   AST_SAP_ANLN1 + AST_SAP_ANLN2 in (select OT33DON_ANLN1 + OT33DON_ANLN2  from ZWFOT33DONv where OT33DON_OT33ID = @p_ROWID)*/          
 )          
           
 if @p_STATUS = 'OT33_70'          
  update OBJ set OBJ_STATUS = 'OBJ_002' where OBJ_ROWID in --Przenoszony          
 ( select OBJID from dbo.GetBlockedObjOT(@p_ID)          
  /*select OBA_OBJID from dbo.ASSET (nolock)           
   join dbo.OBJASSET (nolock) on OBA_ASTID = AST_ROWID          
  where           
   AST_SAP_ANLN1 + AST_SAP_ANLN2 in (select OT33DON_ANLN1 + OT33DON_ANLN2  from ZWFOT33DONv where OT33DON_OT33ID = @p_ROWID)*/          
 )          
          
 return 0          
          
 errorlabel:          
  exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output          
  raiserror (@v_errortext, 16, 1)           
  select @p_apperrortext = @v_errortext          
  return 1          
          
end 
GO