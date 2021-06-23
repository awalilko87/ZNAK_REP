SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT42LN_Update_Proc]  
( @p_FormID nvarchar(50),   
 @p_ROWID int,  
 @p_OT42ID int,  
 @p_CODE nvarchar(30),   
 @p_ID nvarchar(50),  
 @p_ORG nvarchar(30),  
 @p_RSTATUS int,  
 @p_STATUS nvarchar(30),  
 @p_STATUS_old nvarchar(30),  
 @p_TYPE nvarchar(30),   
 @p_ANLN1_POSKI nvarchar(30),  
 @p_ANLN2 nvarchar(30),   
 @p_KOSTL_POSKI nvarchar(10),   
 @p_GDLGRP_POSKI nvarchar(8),   
 @p_ODZYSK nvarchar(3),   
 @p_LIKWCZESC nvarchar(1),  
 @p_PROC decimal(10,2),  
 @p_ZMT_ROWID int,    
 @p_OBJ nvarchar(30) = null,  
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
  , @v_ITSID int  
  , @v_OTID int  
  , @v_OT nvarchar(30)  
  , @v_OTLID int  
  , @v_OTL_COUNT int =  0  
  , @v_OT_STATUS nvarchar(30)  
  , @v_ANLN1  nvarchar(30)  
  , @v_GDLGRP nvarchar(30)  
  , @v_KOSTL  nvarchar(30)  
  , @v_KOSTL_POSKI nvarchar(40)  
    
 set @v_date = getdate()  
  select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS  
   
  select @v_ITSID = OT_ITSID, @v_OTID = OT_ROWID from ZWFOT (nolock) join SAPO_ZWFOT42 (nolock) on OT42_ZMT_ROWID = OT_ROWID where OT42_ROWID = @p_OT42ID  
  select @v_OTL_COUNT = COUNT(*) from dbo.ZWFOTLN where OTL_OTID = @v_OTID   
  select @v_OT_STATUS = OT_STATUS from dbo.ZWFOT (nolock) where OT_ROWID = @v_OTID --OT42_60  

         
  --rzutowanie zmiennych z SAP (POSKI jest polem jedynie do wyświetlania (zadanie inwestycyjne to wyjątek)  
 select @v_ANLN1 = AST_SAP_ANLN1 from [dbo].[ASSET] (nolock) where AST_CODE = @p_ANLN1_POSKI  
 select @v_GDLGRP = KL5_SAP_GDLGRP from [dbo].[KLASYFIKATOR5] (nolock) where KL5_CODE = @p_GDLGRP_POSKI  
 select @v_KOSTL = CCD_SAP_KOSTL from [dbo].[COSTCODE] (nolock) where CCD_CODE = @p_KOSTL_POSKI  
 select @p_PROC = case when isnull(@p_LIKWCZESC,'') = '0' then 100 else @p_PROC end  
 select @p_LIKWCZESC = case when @p_PROC = 100 then '' else @p_LIKWCZESC end --Vision nie obsługuje w DDL wartości ''  
   
 -- czy klucze niepuste  
 if @p_ID is null OR @p_ORG IS NULL -- ## dopisac klucze  
 begin  
  print @p_org  
  select @v_errorcode = 'SYS_003'  
  goto errorlabel  
 end  
  
 if @p_ANLN2 is null  
 begin  
  raiserror('Podskładnik nie może być pusty.', 16, 1)  
  return 1  
 end  
   
 if not exists (select 1 from ASSET where AST_CODE = @p_ANLN1_POSKI and AST_SUBCODE = @p_ANLN2 and AST_NOTUSED = 0)  
 begin  
  raiserror('%s - %s Składnik nie istnieje.', 16, 1, @p_ANLN1_POSKI, @p_ANLN2)  
  return 1  
 end  
   
 --OBSŁUGA BŁĘDÓW słownikowych  
  --if not exists (select 1 from dbo.KLASYFIKATOR5 (nolock) where KL5_CODE = @p_GDLGRP_POSKI) begin  
  -- select @v_errorcode = 'OT42LN_001' -- Wprowadzono niewłaściwego użytkownika wydania  
  -- goto errorlabel end  
     
  --if not exists (select 1 from dbo.COSTCODE (nolock) where CCD_CODE = @p_KOSTL_POSKI) begin  
  -- select @v_errorcode = 'OT42LN_002' -- Wprowadzono niewłaściwy numer MPK dla wydania  
  -- goto errorlabel end  
     
  set @v_KOSTL_POSKI = @p_KOSTL_POSKI + '%'  
  --if @p_GDLGRP_POSKI not in (select KL5_CODE from KLASYFIKATOR5 where KL5_CODE like @v_KOSTL_POSKI)  
  --begin  
  -- select @v_errorcode = 'OT42LN_003' -- czy użytkownik zgadza sie z mpk wydania  
  -- goto errorlabel  
  --end  
    
  --if exists (select 1 from dbo.SAPO_ZWFOT42LN(nolock) join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT42LN_ZMT_ROWID  where   
  --  OT42LN_OT42ID = @p_OT42ID   
  --  and OT42LN_ROWID <> isnull(@p_ROWID,0)  
  --  and isnull(OTL_NOTUSED,0) = 0  
  --  and (OT42LN_KOSTL_POSKI <> @p_KOSTL_POSKI  
  --  or OT42LN_GDLGRP_POSKI <> @p_GDLGRP_POSKI)) begin  
  -- select @v_errorcode = 'OT42LN_004' -- Dokument PL może zostać wystawiony dla jednego MPK  
  -- goto errorlabel end  
    
  --print @p_ANLN1_POSKI + ' aaaa ' + @p_ANLN2  
    
  if exists (select 1 from dbo.SAPO_ZWFOT42LN(nolock) join [dbo].[ZWFOTLN] (nolock) on OT42LN_ZMT_ROWID = OTL_ROWID where  
    OT42LN_OT42ID = @p_OT42ID   
    and OT42LN_ANLN1_POSKI = @p_ANLN1_POSKI   
    and OT42LN_ANLN2 = @p_ANLN2   
    and OT42LN_ROWID <> isnull(@p_ROWID,0)  
    and isnull(OTL_NOTUSED,0) = 0) begin  
    select @v_errorcode = 'OT42LN_005' -- Dla tego składnika jest już wystawiony inny dokument  
   goto errorlabel end  
     
  --if not exists (select 1 from dbo.ASSETv where AST_CODE = @p_ANLN1_POSKI and AST_CCD = @p_KOSTL_POSKI and AST_SAP_GDLGRP = @p_GDLGRP_POSKI) begin  
  -- select @v_errorcode = 'OT42LN_006' -- MPK/Użytkownik wydania niezgodny z numerem środka trwałego.  
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
   
   select @v_OTLID = SCOPE_IDENTITY()  
     
   --linia protokołu PL do integracji w SAP  
   insert into dbo.SAPO_ZWFOT42LN  
   (    
    OT42LN_BUKRS  
    , OT42LN_ANLN1, OT42LN_ANLN1_POSKI  
    , OT42LN_ANLN2  
    , OT42LN_KOSTL, OT42LN_KOSTL_POSKI  
    , OT42LN_GDLGRP, OT42LN_GDLGRP_POSKI  
    , OT42LN_ODZYSK, OT42LN_LIKWCZESC, OT42LN_PROC, OT42LN_ZMT_ROWID, OT42LN_OT42ID  
   )     
   select distinct  
    OT42_BUKRS  
    , @v_ANLN1, @p_ANLN1_POSKI  
    , @p_ANLN2  
    , @v_KOSTL, @p_KOSTL_POSKI  
    , @v_GDLGRP, @p_GDLGRP_POSKI  
    , @p_ODZYSK, @p_LIKWCZESC, @p_PROC, @v_OTLID, @p_OT42ID  
   from dbo.SAPO_ZWFOT42 (nolock)  
   where OT42_ROWID = @p_OT42ID  
  
   insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OTLID, OTO_OBJID, OTO_ASTCODE, OTO_ASTSUBCODE, OTO_CREUSER, OTO_CREDATE)  
   select @v_OTID, @v_OTLID, OBJ_ROWID, AST_CODE, AST_SUBCODE, @p_UserID, getdate()  
   from dbo.OBJASSETv  
   where AST_CODE = @p_ANLN1_POSKI and AST_SUBCODE = @p_ANLN2 and AST_NOTUSED = 0 and OBJ_CODE = @p_OBJ  
   and not exists (select 1 from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID and OTO_OBJID = OBJ_ROWID)  
    
  END TRY 
  BEGIN CATCH 
  --RaisError ('BŁĄD !!!!!!!',16,1) 
   select @v_syserrorcode = error_message()  
   select @v_errorcode = 'OT42_002' -- blad wstawienia  
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
      
   update [dbo].[SAPO_ZWFOT42LN]  
   set     
    OT42LN_ANLN1 = @v_ANLN1,  
    OT42LN_ANLN1_POSKI = @p_ANLN1_POSKI,  
    OT42LN_ANLN2 = @p_ANLN2,  
    OT42LN_KOSTL = @v_KOSTL,   
    OT42LN_KOSTL_POSKI = @p_KOSTL_POSKI,   
    OT42LN_GDLGRP = @v_GDLGRP,   
    OT42LN_GDLGRP_POSKI = @p_GDLGRP_POSKI,   
    OT42LN_ODZYSK = @p_ODZYSK,   
    OT42LN_LIKWCZESC = @p_LIKWCZESC,   
    OT42LN_PROC = @p_PROC   
   where  
    OT42LN_ROWID = @p_ROWID  
   
   --with a as  
   -- (  
   --  select OT42_ROWID, sum(OT42LN_WART_ELEME) suma  
   --  from [dbo].[SAPO_ZWFOT42LN] (nolock)   
   --   join [dbo].[SAPO_ZWFOT42] (nolock) on OT42_ROWID = OT42LN_OT42ID  
   --  where ot42ln_ot42id = @v_OT42ID  
   --  group by OT42_ROWID  
   -- )  
   --update UPD set UPD.OT42_WART_TOTAL = suma   
   -- from [dbo].[SAPO_ZWFOT42] UPD  
   --  join A on A.OT42_ROWID = UPD.OT42_ROWID  
   -- where UPD.OT42_ROWID = A.OT42_ROWID  
  
  END TRY  
  BEGIN CATCH  
   select @v_syserrorcode = error_message()  
   select @v_errorcode = 'OT42_002' -- blad aktualizacji   
   goto errorlabel  
  END CATCH;  
     
 end  
  
 ---------------------------------------------------------------  
 --------https://jira.eurotronic.net.pl/browse/PKNTA-164--------  
 --Jeśli wskazujemy do likwidacji środek główny (nie likwidacja częściowa), to likwidacja dotyczy wszystkich podskładników  
 ---------------------------------------------------------------  
 if   
  @p_ANLN2 = '0000'   
  and @p_PROC = 100  
  and exists (select * from dbo.ASSET (nolock) where   
   AST_CODE = @p_ANLN1_POSKI     
   and AST_SUBCODE not in (select OT42LN_ANLN2 from ZWFOT42LNv where OT42LN_OT42ID = @p_OT42ID and OT42LN_ANLN1 = @v_ANLN1)  
   and AST_NOTUSED = 0)  
 begin  
  
  declare   
   @c_ANLN1 nvarchar(30),   
   @c_ANLN1_POSKI nvarchar(30),  
   @c_ANLN2 nvarchar(30)   
    
  declare c_remaining_anln2 cursor for  
  select   
   AST_SAP_ANLN1, AST_CODE, AST_SUBCODE   
  from dbo.ASSET (nolock) where   
   AST_CODE = @p_ANLN1_POSKI     
   and AST_SUBCODE not in (select OT42LN_ANLN2 from ZWFOT42LNv where OT42LN_OT42ID = @p_OT42ID and OT42LN_ANLN1 = @v_ANLN1)  
   and AST_NOTUSED = 0  
     
  open c_remaining_anln2  
  
  fetch next from c_remaining_anln2  
  into @c_ANLN1, @c_ANLN1_POSKI, @c_ANLN2   
  
  while @@fetch_status = 0   
  begin  
  
   select @v_OTL_COUNT = COUNT(*) from dbo.ZWFOTLN where OTL_OTID = @v_OTID   
    
   --linia protokołu PL w ZMT  
   insert into dbo.ZWFOTLN   
   (  
    OTL_OTID, OTL_STATUS, OTL_RSTATUS, OTL_ID, OTL_ORG, OTL_CODE, OTL_TYPE, OTL_CREDATE, OTL_CREUSER, OTL_OBJID  
   )  
   select distinct  
    @v_OTID, NULL, 0, @p_ID, @p_ORG, cast(@v_OT as nvarchar)+ '/' + cast(@v_OTL_COUNT+1 as nvarchar), NULL, getdate(), @p_UseriD, NULL  
   from ZWFOT (nolock) where OT_ROWID = @v_OTID  
   
   select @v_OTLID = SCOPE_IDENTITY()  
     
   --linia protokołu PL do integracji w SAP  
   insert into dbo.SAPO_ZWFOT42LN  
   (    
    OT42LN_BUKRS  
    , OT42LN_ANLN1, OT42LN_ANLN1_POSKI  
    , OT42LN_ANLN2  
    , OT42LN_KOSTL, OT42LN_KOSTL_POSKI  
    , OT42LN_GDLGRP, OT42LN_GDLGRP_POSKI  
    , OT42LN_ODZYSK, OT42LN_LIKWCZESC, OT42LN_PROC, OT42LN_ZMT_ROWID, OT42LN_OT42ID  
   )     
   select distinct  
    OT42_BUKRS  
    , @c_ANLN1, @c_ANLN1_POSKI  
    , @c_ANLN2  
    , @v_KOSTL, @p_KOSTL_POSKI  
    , @v_GDLGRP, @p_GDLGRP_POSKI  
    , @p_ODZYSK, @p_LIKWCZESC, @p_PROC, @v_OTLID, @p_OT42ID  
   from dbo.SAPO_ZWFOT42 (nolock)  
   where OT42_ROWID = @p_OT42ID  
  
   insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OBJID, OTO_ASTCODE, OTO_ASTSUBCODE, OTO_CREUSER, OTO_CREDATE)  
   select @v_OTID, OBJ_ROWID, AST_CODE, AST_SUBCODE, @p_UserID, getdate()  
   from dbo.OBJASSETv  
   where AST_CODE = @c_ANLN1_POSKI and AST_SUBCODE = @c_ANLN2 and AST_NOTUSED = 0  
   and not exists (select 1 from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID and OTO_OBJID = OBJ_ROWID)  
     
   fetch next from c_remaining_anln2  
   into @c_ANLN1, @c_ANLN1_POSKI, @c_ANLN2   
  
  end  
  
  close c_remaining_anln2   
  deallocate c_remaining_anln2  
 end  
  
 return 0  
  
 errorlabel:  
  exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output  
  raiserror (@v_errortext, 16, 1)   
  select @p_apperrortext = @v_errortext  
  return 1  
  
end  
GO