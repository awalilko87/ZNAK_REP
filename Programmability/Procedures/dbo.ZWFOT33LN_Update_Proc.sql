SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT33LN_Update_Proc]        
(        
 @p_FormID nvarchar(50),         
 @p_ROWID int,        
 @p_OT33ID int,        
 @p_CODE nvarchar(30),         
 @p_ID nvarchar(50),        
 @p_ORG nvarchar(30),        
 @p_RSTATUS int,        
 @p_STATUS nvarchar(30),        
 @p_STATUS_old nvarchar(30),        
 @p_TYPE nvarchar(30),        
  @p_LP int,        
 @p_BUKRS nvarchar(30),         
 @p_ANLN1_POSKI nvarchar(30),          
 @p_DT_WYDANIA datetime,        
 @p_MPK_WYDANIA_POSKI nvarchar(30),         
 @p_GDLGRP_POSKI nvarchar(30),         
 @p_UZASADNIENIE nvarchar(50),         
 @p_TXT50  nvarchar(50),          
 @p_ZMT_ROWID int,         
        
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
 declare @v_Rstatus int         
  --, @v_ITSID int        
  , @v_OTID int        
  , @v_OT nvarchar(30)        
  , @v_OTLID int        
  , @v_OTL_COUNT int =  0        
  , @v_ANLN1 nvarchar(30)          
  , @v_GDLGRP nvarchar(30)        
  , @v_MPK_WYDANIA nvarchar(30)        
  , @v_KOSTL_POSKI nvarchar(40)        
  , @v_TXT50 nvarchar(50)        
         
 set @v_date = getdate()        
  select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS        
             
  select @v_OTID = OT_ROWID from ZWFOT (nolock) join SAPO_ZWFOT33 (nolock) on OT33_ZMT_ROWID = OT_ROWID where OT33_ROWID = @p_OT33ID        
  select @v_OTL_COUNT = COUNT(*) from ZWFOTLN where OTL_OTID = @v_OTID         
          
 --rzutowanie zmiennych z SAP (POSKI jest polem jedynie do wyświetlania (zadanie inwestycyjne to wyjątek)        
 select @v_ANLN1 = AST_SAP_ANLN1, @v_TXT50 = AST_DESC from [dbo].[ASSET] where AST_CODE = @p_ANLN1_POSKI and AST_SUBCODE = '0000'        
 select @v_GDLGRP = KL5_SAP_GDLGRP from [dbo].[KLASYFIKATOR5] (nolock) where KL5_CODE = @p_GDLGRP_POSKI        
 select @v_MPK_WYDANIA = CCD_SAP_KOSTL from [dbo].[COSTCODE] (nolock) where CCD_CODE = @p_MPK_WYDANIA_POSKI        
         
        
 -- czy klucze niepuste        
 if @p_ID is null or @v_OTID is null or @p_OT33ID is null-- ## dopisac klucze        
 begin      
 --RaisError('%i',16,1,@p_OT33ID)    
  select @v_errorcode = 'SYS_003'        
  goto errorlabel        
 end        
         
  --OBSŁUGA BŁĘDÓW słownikowych        
  --if not exists (select 1 from dbo.KLASYFIKATOR5 (nolock) where KL5_CODE = @p_GDLGRP_POSKI) begin        
  -- select @v_errorcode = 'OT33LN_001' -- Wprowadzono niewłaściwego użytkownika wydania        
  -- goto errorlabel end        
          
  --if not exists (select 1 from dbo.COSTCODE (nolock) where CCD_CODE = @p_MPK_WYDANIA_POSKI) begin        
  -- select @v_errorcode = 'OT33LN_003' -- Wprowadzono niewłaściwy numer MPK dla wydania        
  -- goto errorlabel end        
           
  set @v_KOSTL_POSKI = @p_MPK_WYDANIA_POSKI + '%'        
  --if @p_GDLGRP_POSKI not in (select KL5_CODE from KLASYFIKATOR5 where KL5_CODE like @v_KOSTL_POSKI)        
  --begin        
  -- select @v_errorcode = 'OT33LN_005' -- czy użytkownik zgadza sie z mpk wydania        
  -- goto errorlabel        
  --end        
      
      
    /*      
  if exists (select 1 from dbo.SAPO_ZWFOT33LN(nolock) join [dbo].[ZWFOTLN] (nolock) on OT33LN_ZMT_ROWID = OTL_ROWID where        
    OT33LN_OT33ID = @p_OT33ID         
    and OT33LN_ANLN1_POSKI = @p_ANLN1_POSKI         
    and OT33LN_ROWID <> isnull(@p_ROWID,0)        
    and isnull(OTL_NOTUSED,0) = 0)       
 begin        
   -- select @v_errorcode = 'OT33LN_008' -- Dla tego składnika jest już wystawiony inny dokument        
   --goto errorlabel   
   Print 'Dla tego składnika jest już wystawiony inny dokument '  
  end        
 --   */   
 -- wykomentowane na potrzeby zgłsozenia 394       
      
      
  --if not exists (select 1 from dbo.ASSET (nolock) join COSTCODE (nolock) on CCD_ROWID = AST_CCDID where AST_CODE = @p_ANLN1_POSKI         
  ----and CCD_ROWID = @p_MPK_WYDANIA_POSKI         
  --and AST_SAP_GDLGRP = @p_GDLGRP_POSKI) begin        
  -- select @v_errorcode = 'OT33LN_009' -- MPK/Użytkownik wydania niezgodny z numerem środka trwałego.        
  -- goto errorlabel end        
          
 --insert        
 if not exists (select * from dbo.ZWFOTLN (nolock) where OTL_ID = @p_ID)        
 begin          
  BEGIN TRY        
        
   --linia protokołu PL w ZMT        
   insert into dbo.ZWFOTLN         
   (        
    OTL_OTID, OTL_STATUS, OTL_RSTATUS, OTL_ID, OTL_ORG, OTL_CODE, OTL_TYPE, OTL_CREDATE, OTL_CREUSER, OTL_OBJID        
   )        
   select distinct        
    @v_OTID, NULL, 0, @p_ID, @p_ORG, cast(@v_OT as nvarchar)+ '/' + cast(@v_OTL_COUNT+1 as nvarchar), NULL, getdate(), @p_UseriD, NULL        
   from ZWFOT (nolock) where OT_ROWID = @v_OTID        
          
   select @v_OTLID = IDENT_CURRENT('ZWFOTLN')        
           
   --linia protokołu PL do integracji w SAP        
   insert into dbo.SAPO_ZWFOT33LN        
   (          
    OT33LN_LP, OT33LN_BUKRS        
    , OT33LN_ANLN1, OT33LN_ANLN1_POSKI        
    , OT33LN_DT_WYDANIA        
    , OT33LN_MPK_WYDANIA, OT33LN_MPK_WYDANIA_POSKI        
    , OT33LN_GDLGRP, OT33LN_GDLGRP_POSKI        
    , OT33LN_UZASADNIENIE        
    , OT33LN_TXT50         
    , OT33LN_ZMT_ROWID, OT33LN_OT33ID        
   )           
   select distinct        
    @v_OTL_COUNT+1, OT33_BUKRS        
    , @v_ANLN1, @p_ANLN1_POSKI        
    , @p_DT_WYDANIA        
    , @v_MPK_WYDANIA, @p_MPK_WYDANIA_POSKI        
    , @v_GDLGRP, @p_GDLGRP_POSKI        
    , @p_UZASADNIENIE        
    , @v_TXT50             
    , @v_OTLID, @p_OT33ID        
   from dbo.SAPO_ZWFOT33 (nolock)        
   where OT33_ROWID = @p_OT33ID        
          
  END TRY        
  BEGIN CATCH        
   select @v_syserrorcode = error_message()        
   select @v_errorcode = 'OT33LN_002' -- blad wstawienia        
   goto errorlabel        
  END CATCH;          
           
 end        
 else        
 begin        
           
  BEGIN TRY        
           
   --nagłówek        
   update [dbo].[ZWFOTLN]        
   set         
    OTL_OTID = @v_OTID,         
    OTL_STATUS = @P_STATUS,         
    OTL_RSTATUS = @v_RSTATUS,          
    OTL_ORG = @P_ORG,         
    OTL_CODE = @P_CODE,         
    OTL_TYPE = @p_TYPE,         
    OTL_UPDDATE = @v_date,         
    OTL_UPDUSER = @p_UserID        
         
   where OTL_ID = @P_ID        
           
   update [dbo].[SAPO_ZWFOT33LN]        
   set           
    OT33LN_LP = @v_OTL_COUNT+1,          
    OT33LN_ANLN1 = @v_ANLN1,          
    OT33LN_ANLN1_POSKI = @p_ANLN1_POSKI,          
    OT33LN_DT_WYDANIA = @p_DT_WYDANIA,         
    OT33LN_MPK_WYDANIA = @v_MPK_WYDANIA,        
    OT33LN_MPK_WYDANIA_POSKI = @p_MPK_WYDANIA_POSKI,        
    OT33LN_GDLGRP = @v_GDLGRP,         
    OT33LN_GDLGRP_POSKI = @p_GDLGRP_POSKI,         
    OT33LN_UZASADNIENIE = @p_UZASADNIENIE,          
    OT33LN_TXT50 = @v_TXT50         
   where        
    OT33LN_ROWID = @p_ROWID        
           
   --with a as        
   -- (        
   --  select OT33_ROWID, sum(OT33LN_WART_ELEME) suma        
   --  from [dbo].[SAPO_ZWFOT33LN] (nolock)         
   --   join [dbo].[SAPO_ZWFOT33] (nolock) on OT33_ROWID = OT33LN_OT33ID        
   --  where ot33ln_ot33id = @v_OT33ID        
   --  group by OT33_ROWID        
   -- )        
   --update UPD set UPD.OT33_WART_TOTAL = suma         
   -- from [dbo].[SAPO_ZWFOT33] UPD        
   --  join A on A.OT33_ROWID = UPD.OT33_ROWID        
   -- where UPD.OT33_ROWID = A.OT33_ROWID        
        
  END TRY        
  BEGIN CATCH        
   select @v_syserrorcode = error_message()        
   select @v_errorcode = 'OT33_002' -- blad aktualizacji         
   goto errorlabel        
  END CATCH;        
           
 end        
        
    --Aktualizacja doniesień (przy każdym zapisie musi zapewnić aktualność tych danych z SAP        
 exec dbo.ZWFOT33DON_Recalculate @p_OT33ID = @p_OT33ID        
          
 return 0        
        
 errorlabel:        
  exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output        
  raiserror (@v_errortext, 16, 1)         
  select @p_apperrortext = @v_errortext        
  return 1        
        
end        
        
        
GO