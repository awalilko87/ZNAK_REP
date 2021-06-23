SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[STS_Update_Proc]    
(    
 @p_FormID nvarchar(50),    
 @p_ID nvarchar(50),    
 @p_ROWID int,    
 @p_CODE nvarchar(30),    
 @p_ORG nvarchar(30),    
 @p_DESC nvarchar(80),    
 @p_NOTE ntext,    
 @p_DATE datetime,    
 @p_TIME nvarchar(10),    
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
    
 --- tutaj ewentualnie swoje parametry/zmienne/dane    
 @p_GROUP nvarchar (30),    
 @p_SIGNED smallint,    
 @p_SIGNLOC nvarchar(80),    
 @p_SETTYPE nvarchar(30),    
 @p_SAP_CHK int,    
    
 --@p_AUTO_PSP nvarchar(30),    
 @p_STS_DEFAULT_KST nvarchar(30),    
 @p_ROTARY tinyint,    
 @p_PM_TOSEND tinyint,    
     
 @p_UserID nvarchar(30), -- uzytkownik    
 @p_apperrortext nvarchar(4000) output    
)    
as    
begin    
  declare @v_errorcode nvarchar(50)    
  declare @v_syserrorcode nvarchar(4000)    
  declare @v_errortext nvarchar(4000)    
  declare @v_date datetime    
  declare @v_Rstatus int    
  declare @v_Pref nvarchar(10)    
  declare @v_MultiOrg BIT    
  declare @v_GroupID nvarchar(30)    
  declare @v_AUTHGROUP nvarchar(100)    
  declare @v_SIGNED_old int    
      
     
    
  -- czy klucze niepuste    
  if @p_ID is null or @p_CODE is NULL OR @p_ORG IS NULL -- ## dopisac klucze    
  begin    
    select @v_errorcode = 'SYS_003'    
 goto errorlabel    
  end    
    
  select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID    
  select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS    
  select @v_GroupID = UserGroupID from dbo.SYUsers where UserID = @p_UserID    
    
  set @v_date = getdate()    
       
  begin try    
    set @p_TIME = replace(@p_TIME,'_','0')    
    set @p_DATE = @p_DATE+@p_TIME    
  end try    
  begin catch    
 select @v_errorcode = 'SYS_006'    
 goto errorlabel    
  end CATCH    
     
-- obsługa POP-upów -- tutaj na razie nie ma żadnych - to co zostawiłem to "na wzór" ;)    
    
  declare     
 @v_OBGID int    
-- @v_TRADEID int    
     
       
  select @v_OBGID = OBG_ROWID, @v_AUTHGROUP = OBG_AUTHGROUP from dbo.OBJGROUP(nolock) where OBG_CODE = @p_GROUP    
  if @v_OBGID is null and @p_GROUP is not null     
  begin       
    select @v_errorcode = 'POP_013'     
    goto errorlabel     
  end    
    
  if @v_GroupID not in (select value from STRING_SPLIT(@v_AUTHGROUP, ',')) and @v_GroupID <> 'SA'    
  begin    
 raiserror('Dodawanie / Edycja możliwe tylko dla grupy %s', 16, 1, @v_AUTHGROUP)    
 return 1    
  end    
      
--    
--      
--  select @v_TRADEID = ROWID from dbo.TRADE (nolock) where TRD_CODE = @p_TRADECODE    
--  if  @v_TRADEID is null and @p_TRADECODE is not null     
--  begin       
--    select @v_errorcode = 'POP_014'     
--    goto errorlabel     
--  end    
        
      
 --insert    
 if not exists (select * from dbo.STENCIL (nolock) where STS_ID = @p_ID)    
 begin    
  --numeracja    
  --declare @v_Number nvarchar(50), @v_No int    
  --exec dbo.VS_GetNumber @Type = 'RST_BUK', @Pref = 'ZP/', @Suff = '/09', @Number = @v_Number output, @No = @v_No output    
  --select @v_Number, @v_No    
    
 /*Sprawdzenie, czy szablony z zaznaczoną opcją "Urządzenie w SAP PM" mają odpowiednie paramentry dodatkowe*/    
    
  if @p_PM_TOSEND = 1     
   begin    
    RaisError ('Aby utworzyć szablon, którego składniki będą wysyłane do SAP, utwórz najpierw szablon bez zaznaczonej opcji "Urządzenie w SAP PM", uzupełnij parametry dodatkowe i zapisz ponownie z zaznaczoną opcją.',16,1)    
   end    
    
    
      BEGIN TRY    
  insert into dbo.STENCIL    
  (    
    STS_CODE    
  , STS_ORG    
  , STS_DESC    
  , STS_NOTE    
  , STS_DATE    
  , STS_STATUS    
  , STS_TYPE    
  , STS_TYPE2    
  , STS_TYPE3    
  , STS_RSTATUS    
  , STS_CREUSER    
  , STS_CREDATE    
  , STS_UPDUSER    
  , STS_UPDDATE    
  , STS_NOTUSED    
     
  , STS_ID    
  , STS_TXT01    
  , STS_TXT02    
  , STS_TXT03    
  , STS_TXT04    
  , STS_TXT05    
  , STS_TXT06    
  , STS_TXT07    
  , STS_TXT08    
  , STS_TXT09    
  , STS_NTX01    
  , STS_NTX02    
  , STS_NTX03    
  , STS_NTX04    
  , STS_NTX05    
  , STS_COM01    
  , STS_COM02    
  , STS_DTX01    
  , STS_DTX02    
  , STS_DTX03    
  , STS_DTX04    
  , STS_DTX05    
      
  -- dalej własne pola    
  , STS_GROUPID    
  , STS_SIGNED    
  , STS_SIGNLOC    
  , STS_SETTYPE    
  , STS_SAP_CHK    
  --, STS_AUTO_PSP    
  , STS_DEFAULT_KST    
  , STS_ROTARY    
  , STS_PM_TOSEND    
    
  )    
  values     
  (    
    @p_CODE    
  , @p_ORG    
  , @p_DESC    
  , @p_NOTE    
  , @p_DATE    
  , @p_STATUS    
  , @p_TYPE    
  , @p_TYPE2    
  , @p_TYPE3    
  , @v_Rstatus    
  , @p_UserID    
  , @v_date    
  , null    
  , null    
  , @p_NOTUSED    
     
  , @p_ID    
  , @p_TXT01    
  , @p_TXT02    
  , @p_TXT03    
  , @p_TXT04    
  , @p_TXT05    
  , @p_TXT06    
  , @p_TXT07    
  , @p_TXT08    
  , @p_TXT09    
  , @p_NTX01    
  , @p_NTX02    
  , @p_NTX03    
  , @p_NTX04    
  , @p_NTX05    
  , @p_COM01    
  , @p_COM02    
  , @p_DTX01    
  , @p_DTX02    
  , @p_DTX03    
  , @p_DTX04    
  , @p_DTX05    
      
  -- dalej własne pola    
  , @v_OBGID    
  , @p_SIGNED      
  , @p_SIGNLOC     
  , @p_SETTYPE    
  , @p_SAP_CHK    
  --, @p_AUTO_PSP    
  , @p_STS_DEFAULT_KST    
  , @p_ROTARY    
  , @p_PM_TOSEND    
     
  )    
   END TRY    
   BEGIN CATCH    
  select @v_syserrorcode = error_message()    
  select @v_errorcode = 'STS_001' -- blad wstawienia    
  goto errorlabel    
   END CATCH;    
 end    
    else    
    begin    
    
   if not exists(select * from dbo.STENCIL (nolock) where STS_ID = @p_ID and ISNULL(STS_STATUS,0) = ISNULL(@p_STATUS_old,0))    
   begin    
     select @v_syserrorcode = error_message()    
     select @v_errorcode = 'SYS_002' -- blad wspoluzytkowania    
     goto errorlabel    
      end       
    
   if exists(select * from dbo.STENCIL (nolock) where STS_ID = @p_ID AND STS_CODE <> @p_CODE)    
   begin    
     select @v_syserrorcode = error_message()    
     select @v_errorcode = 'SYS_011' -- blad wspoluzytkowania    
     goto errorlabel    
      end    
       
   select @v_SIGNED_old = STS_SIGNED from dbo.STENCIL where STS_ID = @p_ID    
    
     if @p_PM_TOSEND = 1     
   begin    
    /*    
    32 - SAPPM_LOCATION - Lokalizacja funkcjonalna    
    304 - KIND_TECH_OBJ - Rodzaj obiektu techniczne    
    305 - DIRECT_PROFILE - Profil katalogu urządz.    
    */    
    if not exists (select 1 from ADDSTSPROPERTIES where ASP_STSID = @p_ROWID and ASP_PROID = 32)    
    begin    
     RaisError ('Nie można zmienić danych szablonu! Uzupełnij parametr "Lokalizacja funkcjonalna"',16,1)    
    end    
    
    if not exists (select 1 from ADDSTSPROPERTIES where ASP_STSID = @p_ROWID and ASP_PROID = 304)    
    begin    
     RaisError ('Nie można zmienić danych szablonu! Uzupełnij parametr "Rodzaj obiektu technicznego"',16,1)    
    end    
    
    if not exists (select 1 from ADDSTSPROPERTIES where ASP_STSID = @p_ROWID and ASP_PROID = 305)    
    begin    
     RaisError ('Nie można zmienić danych szablonu! Uzupełnij parametr "Profil katalogu urządz."',16,1)    
    end    
  end    
    
  BEGIN TRY    
    UPDATE dbo.STENCIL SET    
     STS_CODE = @p_CODE    
   , STS_ORG = @p_ORG    
   , STS_DESC = @p_DESC    
   , STS_NOTE = @p_NOTE    
   , STS_DATE = @p_DATE    
   , STS_STATUS = @p_STATUS    
   , STS_TYPE = @p_TYPE    
   , STS_TYPE2 = @p_TYPE2    
   , STS_TYPE3 = @p_TYPE3    
   , STS_RSTATUS = @v_Rstatus    
   , STS_UPDDATE  =  @v_date    
   , STS_UPDUSER  =  @p_UserID    
   , STS_NOTUSED = @p_NOTUSED    
     
   , STS_TXT01 = @p_TXT01    
   , STS_TXT02 = @p_TXT02    
   , STS_TXT03 = @p_TXT03    
   , STS_TXT04 = @p_TXT04    
   , STS_TXT05 = @p_TXT05    
   , STS_TXT06 = @p_TXT06    
   , STS_TXT07 = @p_TXT07    
   , STS_TXT08 = @p_TXT08    
   , STS_TXT09 = @p_TXT09    
   , STS_NTX01 = @p_NTX01    
   , STS_NTX02 = @p_NTX02    
   , STS_NTX03 = @p_NTX03    
   , STS_NTX04 = @p_NTX04    
   , STS_NTX05 = @p_NTX05    
   , STS_COM01 = @p_COM01    
   , STS_COM02 = @p_COM02    
   , STS_DTX01 = @p_DTX01    
   , STS_DTX02 = @p_DTX02    
   , STS_DTX03 = @p_DTX03    
   , STS_DTX04 = @p_DTX04    
   , STS_DTX05 = @p_DTX05    
       
   -- dalej własne pola    
   , STS_GROUPID = @v_OBGID    
   , STS_SIGNED = @p_SIGNED    
   , STS_SIGNLOC = @p_SIGNLOC    
   , STS_SETTYPE = @p_SETTYPE     
   , STS_SAP_CHK = @p_SAP_CHK    
   --, STS_AUTO_PSP = @p_AUTO_PSP    
   , STS_DEFAULT_KST = @p_STS_DEFAULT_KST    
   , STS_ROTARY = @p_ROTARY    
   , STS_PM_TOSEND = @p_PM_TOSEND    
       
    where STS_ID = @p_ID    
    
    if isnull(@v_SIGNED_old,0) <> @p_SIGNED    
    begin    
   update dbo.OBJ set    
    OBJ_SIGNED = @p_SIGNED    
   where OBJ_STSID = @p_ROWID and isnull(OBJ_SIGNED,0) <> @p_SIGNED    
    end    
    
  END TRY    
  BEGIN CATCH    
   select @v_syserrorcode = error_message()    
   select @v_errorcode = 'STS_002' -- blad aktualizacji zgloszenia    
   goto errorlabel    
  END CATCH;    
  end    
  return 0    
  errorlabel:    
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output    
 raiserror (@v_errortext, 16, 1)     
    select @p_apperrortext = @v_errortext    
    return 1    
end 
GO