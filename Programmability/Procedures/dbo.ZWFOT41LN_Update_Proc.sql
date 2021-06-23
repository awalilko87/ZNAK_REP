SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT41LN_Update_Proc]  
(  
 @p_FormID nvarchar(50),   
 @p_ROWID int,  
 @p_OT41ID int,  
 @p_CODE nvarchar(30),   
 @p_ID nvarchar(50),  
 @p_ORG nvarchar(30),  
 @p_RSTATUS int,  
 @p_STATUS nvarchar(30),  
 @p_STATUS_old nvarchar(30),  
 @p_TYPE nvarchar(30),   
 @p_ANLN1_POSKI nvarchar(30),   
 @p_KOSTL_POSKI nvarchar(10),   
 @p_GDLGRP_POSKI nvarchar(8),   
 @p_UZASA nvarchar(50),    
 @p_MENGE decimal(10,2),  
 @p_ZMT_ROWID int,  
 @p_OBJ nvarchar(30),  
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
  , @v_ANLN1 nvarchar(30)  
  , @v_GDLGRP nvarchar(30)  
  , @v_KOSTL nvarchar(30)  
  , @v_KOSTL_POSKI nvarchar(40)  
   
 set @v_date = getdate()  
  select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS  
       
  select @v_ITSID = OT_ITSID, @v_OTID = OT_ROWID from ZWFOT (nolock) join SAPO_ZWFOT41 (nolock) on OT41_ZMT_ROWID = OT_ROWID where OT41_ROWID = @p_OT41ID  
  select @v_OTL_COUNT = COUNT(*) from ZWFOTLN (nolock) where OTL_OTID = @v_OTID   
    
  --rzutowanie zmiennych z SAP (POSKI jest polem jedynie do wyświetlania (zadanie inwestycyjne to wyjątek)  
 select @v_ANLN1 = AST_SAP_ANLN1 from [dbo].[ASSET] (nolock) where AST_CODE = @p_ANLN1_POSKI  
 select @v_GDLGRP = KL5_SAP_GDLGRP from [dbo].[KLASYFIKATOR5] (nolock) where KL5_CODE = @p_GDLGRP_POSKI  
 select @v_KOSTL = CCD_SAP_KOSTL from [dbo].[COSTCODE] (nolock) where CCD_CODE = @p_KOSTL_POSKI  
   
 -- czy klucze niepuste  
 if @p_ID is null OR @p_ORG IS NULL -- ## dopisac klucze  
 begin  
  print @p_org  
  select @v_errorcode = 'SYS_003'  
  goto errorlabel  
 end  
   
 --OBSŁUGA BŁĘDÓW słownikowych  

  if not exists (select 1 from dbo.KLASYFIKATOR5 (nolock) where KL5_CODE = @p_GDLGRP_POSKI) begin  
   select @v_errorcode = 'OT41LN_001' -- Wprowadzono niewłaściwego użytkownika wydania  
   goto errorlabel end  
     
  if not exists (select 1 from dbo.COSTCODE (nolock) where CCD_CODE = @p_KOSTL_POSKI) begin  
   select @v_errorcode = 'OT41LN_002' -- Wprowadzono niewłaściwy numer MPK dla wydania  
   goto errorlabel end  
      
  set @v_KOSTL_POSKI = @p_KOSTL_POSKI + '%'  
  if @p_GDLGRP_POSKI not in (select KL5_CODE from KLASYFIKATOR5 where KL5_CODE like @v_KOSTL_POSKI)  
  begin  
   select @v_errorcode = 'OT41LN_003' -- czy użytkownik zgadza sie z mpk wydania  
   goto errorlabel  
  end  
    
  if exists (select 1 from dbo.SAPO_ZWFOT41LN(nolock) join [dbo].[ZWFOTLN] (nolock) on OTL_ROWID = OT41LN_ZMT_ROWID  where   
    OT41LN_OT41ID = @p_OT41ID   
    and OT41LN_ROWID <> isnull(@p_ROWID,0)  
    and isnull(OTL_NOTUSED,0) = 0  
    and (OT41LN_KOSTL_POSKI <> @p_KOSTL_POSKI  
    or OT41LN_GDLGRP_POSKI <> @p_GDLGRP_POSKI)) begin  
   select @v_errorcode = 'OT41LN_004' -- Dokument PL może zostać wystawiony dla jednego MPK  
   goto errorlabel end  
    
  if exists (select 1,* from dbo.SAPO_ZWFOT41LN(nolock) join [dbo].[ZWFOTLN] (nolock) on OT41LN_ZMT_ROWID = OTL_ROWID where  
    OT41LN_OT41ID = @p_OT41ID   
    and OT41LN_ANLN1_POSKI = @p_ANLN1_POSKI   
    and OT41LN_ROWID <> isnull(@p_ROWID,0)  
    and isnull(OTL_NOTUSED,0) = 0) begin  
    select @v_errorcode = 'OT41LN_005' -- Dla tego składnika jest już wystawiony inny dokument  
   goto errorlabel end  
    

  if not exists (select 1 from dbo.ASSETv where AST_CODE = @p_ANLN1_POSKI and AST_CCD = @p_KOSTL_POSKI and AST_SAP_GDLGRP = @p_GDLGRP_POSKI) begin  
   select @v_errorcode = 'OT41LN_006' -- MPK/Użytkownik wydania niezgodny z numerem środka trwałego.  
   goto errorlabel end  
   
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
   insert into dbo.SAPO_ZWFOT41LN  
   (    
    OT41LN_BUKRS  
    , OT41LN_ANLN1, OT41LN_ANLN1_POSKI  
    , OT41LN_KOSTL, OT41LN_KOSTL_POSKI  
    , OT41LN_GDLGRP, OT41LN_GDLGRP_POSKI  
    , OT41LN_UZASA, OT41LN_MENGE, OT41LN_ZMT_ROWID, OT41LN_OT41ID  
   )     
   select distinct  
    OT41_BUKRS  
    , @v_ANLN1, @p_ANLN1_POSKI  
    , @v_KOSTL, @p_KOSTL_POSKI  
    , @v_GDLGRP, @p_GDLGRP_POSKI  
    , @p_UZASA, @p_MENGE, @v_OTLID, @p_OT41ID  
   from dbo.SAPO_ZWFOT41 (nolock)  
   where OT41_ROWID = @p_OT41ID  
  
   insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OTLID, OTO_OBJID, OTO_ASTCODE, OTO_ASTSUBCODE, OTO_CREUSER, OTO_CREDATE)  
   select @v_OTID, @v_OTLID, OBJ_ROWID, AST_CODE, AST_SUBCODE, @p_UserID, getdate()  
   from dbo.OBJASSETv  
   where AST_CODE = @p_ANLN1_POSKI and AST_NOTUSED = 0 and OBJ_CODE = isnull(@p_OBJ, OBJ_CODE)  
   and not exists (select 1 from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID and OTO_OBJID = OBJ_ROWID)  
    
  END TRY  
  BEGIN CATCH  
   select @v_syserrorcode = error_message()  
   select @v_errorcode = 'OT41LN_002' -- blad wstawienia  
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
     
   update [dbo].[SAPO_ZWFOT41LN]  
   set     
    OT41LN_ANLN1 = @v_ANLN1,  
    OT41LN_ANLN1_POSKI = @p_ANLN1_POSKI,  
    OT41LN_KOSTL = @v_KOSTL,   
    OT41LN_KOSTL_POSKI = @p_KOSTL_POSKI,   
    OT41LN_GDLGRP = @v_GDLGRP,   
    OT41LN_GDLGRP_POSKI = @p_GDLGRP_POSKI,   
    OT41LN_UZASA = @p_UZASA,   
    OT41LN_MENGE = @p_MENGE  
   where  
    OT41LN_ROWID = @p_ROWID  
   
   --with a as  
   -- (  
   --  select OT41_ROWID, sum(OT41LN_WART_ELEME) suma  
   --  from [dbo].[SAPO_ZWFOT41LN] (nolock)   
   --   join [dbo].[SAPO_ZWFOT41] (nolock) on OT41_ROWID = OT41LN_OT41ID  
   --  where ot41ln_ot41id = @v_OT41ID  
   --  group by OT41_ROWID  
   -- )  
   --update UPD set UPD.OT41_WART_TOTAL = suma   
   -- from [dbo].[SAPO_ZWFOT41] UPD  
   --  join A on A.OT41_ROWID = UPD.OT41_ROWID  
   -- where UPD.OT41_ROWID = A.OT41_ROWID  
  
  END TRY  
  BEGIN CATCH  
   select @v_syserrorcode = error_message()  
   select @v_errorcode = 'OT41_002' -- blad aktualizacji   
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