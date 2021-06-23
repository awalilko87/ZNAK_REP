SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[REQUEST_OT_Create_Proc]  
(  
 @p_FormID nvarchar(50),  
 @p_ROWID int,  
 @p_TYPE nvarchar(3),  
    
 @p_UserID nvarchar(30),   
 @p_apperrortext nvarchar(4000) = null output  
)  
as  
begin   
  
 declare @v_errorcode nvarchar(50)  
 declare @v_syserrorcode nvarchar(4000)  
 declare @v_errortext nvarchar(4000)  
 declare @v_errorid int  
 declare @v_date datetime  
 declare @v_Pref nvarchar(10)  
 declare @v_MultiOrg bit  
  
 declare  
  --zmienne zapytania   
  @c_SRQ_ROWID int,  
  @c_SRQ_OBJID int,  
  @c_SRQ_STNID_FROM int,  
  @c_SRQ_KL5ID_FROM int,  
  @c_SRQ_STNID_TO int,  
  @c_SRQ_KL5ID_TO int,  
  @c_AST_CODE nvarchar(30),  
  @c_AST_SUBCODE nvarchar(30),  
  @c_SRQ_NOTE nvarchar(max),  
  @c_SRQ_TYPE nvarchar(30),  
  @c_OBJ_CODE nvarchar(30),  
  @c_OBJ_OBSZAR nvarchar(30),  
    
  --zmienne do kontrolek  
  @v_FROM_CCD nvarchar(30),  
  @v_FROM_KL5 nvarchar(30),  
  @v_TO_CCD nvarchar(30),  
  @v_TO_KL5 nvarchar(30),  
  @v_IMIE_NAZWISKO nvarchar(30),  
    
  --zmienne nagłówka MT1  
  @v_OT31_ID nvarchar(50),   
  @v_OT31_ORG nvarchar(30),  
  @v_OT31_STATUS  nvarchar(30),    
  @v_OT31ID int,  
  --zmienne linii MT1  
  @v_OT31LN_ID nvarchar(50),  
  @v_DT_WYDANIA datetime,  
    
  --zmienne nagłówka MT3  
   @v_OT33_ID nvarchar(50),  
   @v_OT33_ORG nvarchar(30),  
   @v_OT33_STATUS  nvarchar(30),  
   @v_OT33_MTOPER  nvarchar(1),  
   @v_OT33ID int,  
     
   --zmienne linii MT3  
   @v_OT33LN_ID nvarchar(50),  
  
  --zmienne nagłówka PL  
   @v_OT42_ID nvarchar(50),  
   @v_OT42_ORG nvarchar(30),  
   @v_OT42_STATUS  nvarchar(30),  
   @v_OT42ID int,  
   --zmienne linii PL  
   @v_OT42LN_ID nvarchar(50),  
   @v_OT42LN_LIKWCZESC nvarchar(1),  
   @v_OT42LN_PROC int,  
  
  --zmienne nagłówka LTW  
   @v_OT41_ID nvarchar(50),  
   @v_OT41_ORG nvarchar(30),  
   @v_OT41_STATUS  nvarchar(30),  
   @v_OT41ID int,  
   --zmienne linii LTW  
   @v_OT41LN_ID nvarchar(50)  
    
 select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID  
 select @v_IMIE_NAZWISKO = SAPLogin from SyUsers(nolock) where UserID = @p_UserID       
   
 if @v_IMIE_NAZWISKO is null  
 begin  
  set @v_errorcode = 'OT_SAPUSER'  
  goto errorlabel  
 end    
     
 select   
  @c_SRQ_ROWID = SRQ_ROWID,   
  @c_SRQ_OBJID = SRQ_OBJID,   
  @c_SRQ_STNID_FROM = SRQ_STNID_FROM,   
  @c_SRQ_KL5ID_FROM = SRQ_KL5ID_FROM,   
  @c_SRQ_STNID_TO = SRQ_STNID_TO,   
  @c_SRQ_KL5ID_TO = SRQ_KL5ID_TO,   
  @c_AST_CODE = AST_CODE,   
  @c_AST_SUBCODE = AST_SUBCODE,  
  @c_SRQ_NOTE = SRQ_NOTE,  
  @c_SRQ_TYPE = SRQ_TYPE,  
  @c_OBJ_CODE = OBJ_CODE,  
  @c_OBJ_OBSZAR = GroupID  
 from [dbo].[SP_REQUEST] (nolock)  
 join [dbo].[OBJASSET] (nolock) on SRQ_OBJID = OBA_OBJID   
 join [dbo].[ASSET] (nolock) a on AST_ROWID = OBA_ASTID   
 join dbo.OBJ on OBJ_ROWID = SRQ_OBJID  
 left join dbo.OBJGROUP_RESPONv on OBG_ROWID = OBJ_GROUPID  
 where SRQ_ROWID = @p_ROWID  
    
 select @v_FROM_CCD = STN_CCD from STATIONv where STN_ROWID = @c_SRQ_STNID_FROM  
 select @v_FROM_KL5 = KL5_CODE from KLASYFIKATOR5 where KL5_ROWID = @c_SRQ_KL5ID_FROM  
 select @v_TO_CCD = STN_CCD from STATIONv where STN_ROWID = @c_SRQ_STNID_TO  
 select @v_TO_KL5 = KL5_CODE from KLASYFIKATOR5 where KL5_ROWID = @c_SRQ_KL5ID_TO  
   
     
 --tu sprawdzenie na zablokowane  
 --if exists (select 1 from dbo.GetBlockedAssets () where ANLN1_ANLN2 = @c_AST_CODE + @c_AST_SUBCODE)  
 --begin   
 -- select @v_errorcode = 'SRQ_001'  
 -- goto errorlabel  
 --end  
   
 if (@p_TYPE = 'PL' and @c_AST_SUBCODE is null)  
 begin   
  -- środek trwały nie połączony z SAP  
  select @v_errorcode = 'SRQ_002'  
  goto errorlabel  
 end  
    
 -----------------------------------------------------------------------------------  
 ----------------------------------------MT1----------------------------------------  
 -----------------------------------------------------------------------------------    
 if @p_TYPE = 'MT1'  
 begin    
    
  select @v_OT31_ID = NEWID()  
  select @v_OT31_ORG = dbo.GetOrgDef('OT31_RC',@p_UserID)  
  select @v_OT31_STATUS = dbo.[GetStatusDef]('OT31_RC',NULL,@p_UserID)  
  
  if not exists (  
   select * from SAPO_ZWFOT31LN (nolock) L join dbo.ZWFOT31v (nolock) on OT31_ROWID = L.OT31LN_OT31ID   
   where   
    L.OT31LN_MPK_WYDANIA = @v_FROM_CCD and  
    L.OT31LN_GDLGRP = @v_FROM_KL5 and   
    L.OT31LN_MPK_PRZYJECIA = @v_TO_CCD and    
    L.OT31LN_UZYTKOWNIK = @v_TO_KL5 and   
    OT_STATUS in ('OT31_10') and  
    OT_OBSZAR = @c_OBJ_OBSZAR)  
  begin  
  
   exec [dbo].[ZWFOT31_Update_Proc]   
    @p_FormID  = 'OT31_RC' ,  
    @p_ROWID = NULL,  
    @p_CODE = 'autonumer',  
    @p_ID = @v_OT31_ID,  
    @p_ORG = @v_OT31_ORG,  
    @p_RSTATUS = 0,  
    @p_STATUS = @v_OT31_STATUS,  
    @p_STATUS_old = NULL,  
    @p_TYPE = NULL,  
    @p_BUKRS = 'PPSA',  
    @p_CCD_DEFAULT = @v_FROM_CCD,  
    @p_IF_EQUNR = NULL,  
    @p_IF_SENTDATE = NULL,  
    @p_IF_STATUS = NULL,  
    @p_IMIE_NAZWISKO = @v_IMIE_NAZWISKO,   
    @p_KROK = 1,   
    @p_SAPUSER = '',  
    @p_ZMT_ROWID = NULL,   
    @p_NR_PM = NULL,  
    @p_OBSZAR = @c_OBJ_OBSZAR,  
	@p_COSTCODEID = null,     
    @p_UserID  = @p_UserID;  
  
   select @v_OT31ID = OT31_ROWID from dbo.ZWFOT31v (nolock) where OT_ID = @v_OT31_ID  
    
  end       
  else  
  begin  
     
   select @v_OT31ID = OT31_ROWID from SAPO_ZWFOT31LN (nolock) L join dbo.ZWFOT31v (nolock) on OT31_ROWID = L.OT31LN_OT31ID   
   where   
    L.OT31LN_MPK_WYDANIA = @v_FROM_CCD and  
    L.OT31LN_GDLGRP = @v_FROM_KL5 and   
    L.OT31LN_MPK_PRZYJECIA = @v_TO_CCD and    
    L.OT31LN_UZYTKOWNIK = @v_TO_KL5 and   
    OT_STATUS in ('OT31_10') and  
    OT_OBSZAR = @c_OBJ_OBSZAR  
      
  end  
           
  select @v_OT31LN_ID = NEWID()  
  select @v_DT_WYDANIA = GETDATE()  
     
  if not exists (select 1 from ZWFOT31LNv where OT31LN_OT31ID = @v_OT31ID and OT31LN_ANLN1_POSKI = @c_AST_CODE)  
  begin  
   --print 'MT1 LN'     
   exec [dbo].[ZWFOT31LN_Update_Proc]   
    @p_FormID  = 'OT31_LN' ,  
    @p_ROWID = NULL,  
    @p_OT31ID = @v_OT31ID,  
    @p_CODE = 'autonumer',  
    @p_ID = @v_OT31LN_ID,  
    @p_ORG = @v_OT31_ORG,  
    @p_RSTATUS = 0,  
    @p_STATUS = NULL,  
    @p_STATUS_old = NULL,  
    @p_TYPE = NULL,  
    @p_LP = NULL,  
    @p_BUKRS = 'PPSA',  
    @p_ANLN1_POSKI = @c_AST_CODE,  
    @p_UZASADNIENIE = 'Przeniesiony ze zgłoszenia prowadzących stację',  
    @p_DT_WYDANIA = @v_DT_WYDANIA,  
    @p_MPK_WYDANIA_POSKI = @v_FROM_CCD,  
    @p_GDLGRP_POSKI = @v_FROM_KL5,  
    @p_DT_PRZYJECIA = @v_DT_WYDANIA,  
    @p_MPK_PRZYJECIA_POSKI = @v_TO_CCD,  
    @p_UZYTKOWNIK_POSKI = @v_TO_KL5,  
    @p_ZMT_ROWID = NULL,  
    @p_PRACOWNIK = '',  
    @p_OBJ = @c_OBJ_CODE,  
    @p_UserID  = @p_UserID;  
  end  
    
  if (@v_OT31ID is not null)  
  begin  
   -- zmiana statusu na zgłoszeniu   
   exec [dbo].[SP_REQUEST_Accept_Proc] @p_ID = @p_ROWID,@p_STATUS = 'SRQ_006',@p_TYPE = @c_SRQ_TYPE,@p_NOTE = @c_SRQ_NOTE,@p_UserID = @p_UserID;  
     
     
   update [dbo].[SP_REQUEST] set  
   SRQ_WORKFLOW_USER = @p_UserID,   
   SRQ_WORFKLOW_DATE = GETDATE(),   
   SRQ_WORKFLOW_TYPE = 'MT1',  
   SRQ_WORKFLOW_ID = @v_OT31ID  
   WHERE SRQ_ROWID = @p_ROWID  
     
  end  
    
  update [dbo].[SP_REQUEST] set SRQ_OT31ID = (select OT31_ZMT_ROWID from SAPO_ZWFOT31 where OT31_ROWID = @v_OT31ID) where SRQ_ROWID = @c_SRQ_ROWID  
    
 end  
   
 -----------------------------------------------------------------------------------  
 ----------------------------------------MT3----------------------------------------  
 -----------------------------------------------------------------------------------   
 if @p_TYPE = 'MT3'  
 begin  
    
  select @v_OT33_ID = NEWID()  
  select @v_OT33_ORG = dbo.GetOrgDef('OT33_RC',@p_UserID)  
  select @v_OT33_STATUS = dbo.[GetStatusDef]('OT33_RC',NULL,@p_UserID)  
  select @v_OT33_MTOPER = case when @c_AST_SUBCODE = '0000' then 2 else 4 end --IT używa tylko parzyste, operacje 2 i 4 są częściowe, gdy wartość 100% ustala to po wprowadzeniu pozycji  
  --select OPER, OPER_DESC from [dbo].[GetMT3Type] ()  
  
  --print 'MT3 NAG'  
  exec [dbo].[ZWFOT33_Update_Proc]   
   @p_FormID  = 'OT33_RC',  
   @p_ROWID = NULL,  
   @p_CODE = 'autonumer',  
   @p_ID = @v_OT33_ID,  
   @p_ORG = @v_OT33_ORG,  
   @p_RSTATUS = 0,  
   @p_STATUS = @v_OT33_STATUS,  
   @p_STATUS_old = NULL,  
   @p_TYPE = NULL,  
   @p_BUKRS = 'PPSA',  
   @p_MTOPER = @v_OT33_MTOPER,  
   @p_CZY_BEZ_ZM = 1,  
   @p_CZY_ROZ_OKR = 0,  
   @p_IF_EQUNR = NULL,  
   @p_IF_SENTDATE = NULL,  
   @p_IF_STATUS = NULL,  
   @p_IMIE_NAZWISKO = @v_IMIE_NAZWISKO,   
   @p_KROK = 1,   
   @p_SAPUSER = '',  
   @p_ZMT_ROWID = NULL,   
   @p_OT_NR_PM = NULL,  
   @p_TOSTNID = null,  
   @p_CCDID = null,             
   @p_UserID  = @p_UserID,
   @p_POTID = null;  
     
  
  select @v_OT33ID = OT33_ROWID from dbo.ZWFOT33v (nolock) where OT_ID = @v_OT33_ID  
  select @v_OT33LN_ID = NEWID()  
  select @v_DT_WYDANIA = GETDATE()  
    
  --print 'MT3 LN'  
  exec [dbo].[ZWFOT33LN_Update_Proc]   
   @p_FormID  = 'OT33_LN' ,  
   @p_ROWID = NULL,  
   @p_OT33ID = @v_OT33ID,  
   @p_CODE = NULL,  
   @p_ID = @v_OT33LN_ID,  
   @p_ORG = @v_OT33_ORG,  
   @p_RSTATUS = 0,  
   @p_STATUS = NULL,  
   @p_STATUS_old = NULL,  
   @p_TYPE = NULL,  
   @p_LP = NULL,  
   @p_BUKRS = 'PPSA',  
   @p_ANLN1_POSKI = @c_AST_CODE,  
   @p_DT_WYDANIA = @v_DT_WYDANIA,  
   @p_MPK_WYDANIA_POSKI = @v_FROM_CCD,  
   @p_GDLGRP_POSKI = @v_FROM_KL5,  
   @p_UZASADNIENIE = 'Przeniesiony ze zgłoszenia prowadzących stację',  
   @p_TXT50 = '',  
   @p_ZMT_ROWID = NULL,   
   @p_UserID  = @p_UserID;  
      
  declare @v_WARST_DO decimal  
  declare @v_PRCNT_DO decimal  
    
 -- select top 1 @v_WARST_DO = case when OBJ_VALUE is null then AST_SAP_URWRT else OBJ_VALUE end  
  select top 1 @v_WARST_DO = OBJ_VALUE  
  from dbo.ASSET  
   join dbo.OBJASSET on OBA_ASTID = AST_ROWID  
   join dbo.OBJ on OBA_OBJID = OBJ_ROWID  
  where AST_CODE = @c_AST_CODE and AST_SUBCODE = @c_AST_SUBCODE and OBJ_CODE = @c_OBJ_CODE  
     
  --print 'MT3 DON'  
  exec [dbo].[ZWFOT33DON_Update_Proc]   
   @p_FormID  = 'OT33_DON',  
   @p_ROWID = NULL,  
   @p_OT33ID = @v_OT33ID,  
   @p_CODE = NULL,  
   @p_ID = NULL,  
   @p_ORG = @v_OT33_ORG,  
   @p_RSTATUS = 0,  
   @p_STATUS = NULL,  
   @p_STATUS_old = NULL,  
   @p_TYPE = NULL,  
   @p_TXT50 = 'TXT50',  
   @p_WARST = NULL,  
   @p_NDJARPER = 0,  
   @p_MTOPER = @v_OT33_MTOPER,  
   @p_ANLN1_POSKI = @c_AST_CODE,  
   @p_ANLN2 = @c_AST_SUBCODE,  
   @p_ANLN1_DO_POSKI = NULL,  
   @p_ANLN2_DO = NULL,  
   @p_ANLKL_DO_POSKI = '',  
   @p_KOSTL_DO_POSKI = @v_TO_CCD,  
   @p_UZYTK_DO_POSKI = @v_TO_KL5,  
   @p_PRAC_DO = '',  
   @p_PRCNT_DO = NULL,  
   @p_WARST_DO = @v_WARST_DO,  
   @p_TXT50_DO = '',  
   @p_NDPER_DO = 0,  
   @p_CHAR_DO = '',  
   @p_BELNR = '',  
   @p_ZMT_ROWID = NULL,  
   @p_STNID = NULL,     
   @p_STS = NULL,   
   @p_OT33_OPERATION = NULL,  
   @p_OBJ = @c_OBJ_CODE,  
   @p_UserID  = @p_UserID;  
    
  --ustalenie wartości parametru "Wybierz operację"  
  
  select @v_PRCNT_DO = OT33DON_PRCNT_DO from dbo.SAPO_ZWFOT33DON where OT33DON_OT33ID = @v_OT33ID and OT33DON_MTOPER = 'X'  
  
  if @v_PRCNT_DO = 100  
  begin  
   --if @v_OT33_MTOPER = 2 --2 główny częściowy  
   -- update SAPO_ZWFOT33 set OT33_MTOPER = 0 where OT33_ROWID = @v_OT33ID--0 nie da się wydzielić 100% ze składnika głównego  
   if @v_OT33_MTOPER = 4 --4 podnumer częściowy  
    update SAPO_ZWFOT33 set OT33_MTOPER = 6 where OT33_ROWID = @v_OT33ID--6 podnumer całościowy   
  
  end  
     
    
  if (@v_OT33ID is not null)  
  begin  
   -- zmiana statusu na zgłoszeniu   
   exec [dbo].[SP_REQUEST_Accept_Proc] @p_ID = @p_ROWID,@p_STATUS = 'SRQ_006',@p_TYPE = @c_SRQ_TYPE,@p_NOTE = @c_SRQ_NOTE,@p_UserID = @p_UserID;  
     
     
   update [dbo].[SP_REQUEST] set  
   SRQ_WORKFLOW_USER = @p_UserID,   
   SRQ_WORFKLOW_DATE = GETDATE(),   
   SRQ_WORKFLOW_TYPE = 'MT3',  
   SRQ_WORKFLOW_ID = @v_OT33ID  
   WHERE SRQ_ROWID = @p_ROWID  
  end  
    
  update [dbo].[SP_REQUEST] set SRQ_OT33ID = (select OT33_ZMT_ROWID from SAPO_ZWFOT33 where OT33_ROWID = @v_OT33ID) where SRQ_ROWID = @c_SRQ_ROWID  
      
 end  
   
 -----------------------------------------------------------------------------------  
 ----------------------------------------PL-----------------------------------------  
 -----------------------------------------------------------------------------------   
 if (@p_TYPE = 'PL' and LEFT(@c_AST_CODE,1) != '3')  
 begin  
   
  select @v_OT42_ID = NEWID()  
  select @v_OT42_ORG = dbo.GetOrgDef('OT42_RC',@p_UserID)  
  select @v_OT42_STATUS = dbo.[GetStatusDef]('OT42_RC',NULL,@p_UserID)    
  
  begin  
   --print 'PL NAG'  
   exec [dbo].[ZWFOT42_Update_Proc]   
    @p_FormID  = 'OT42_RC',  
    @p_ROWID = NULL,  
    @p_CODE = 'autonumer',  
    @p_ID = @v_OT42_ID,  
    @p_ORG = @v_OT42_ORG,  
    @p_RSTATUS = 0,  
    @p_STATUS = @v_OT42_STATUS,  
    @p_STATUS_old = NULL,  
    @p_TYPE = NULL,  
    @p_KROK = 1,  
    @p_BUKRS = 'PPSA',  
    @p_UZASADNIENIE = 'Przeniesiony ze zgłoszenia prowadzących stację',  
    @p_KOSZT = NULL,  
    @p_SZAC_WART_ODZYSKU = NULL,  
    @p_SPOSOBLIKW = NULL,  
    @p_PSP_POSKI = NULL,   
    @p_ROK = NULL,  
    @p_MIESIAC = NULL,  
    @p_CZY_UCHWALA = NULL,  
    @p_CZY_DECYZJA = NULL,  
    @p_CZY_ZAKRES = NULL,  
    @p_CZY_OCENA = NULL,  
    @p_CZY_EKSPERTYZY = NULL,  
    @p_UCHWALA_OPIS = '',  
    @p_DECYZJA_OPIS = '',  
    @p_ZAKRES_OPIS = '',  
    @p_OCENA_OPIS = '',  
    @p_EKSPERTYZY_OPIS = '',  
    @p_IF_EQUNR = NULL,  
    @p_IF_SENTDATE = NULL,  
    @p_IF_STATUS = NULL,  
    @p_SAPUSER = '',  
    @p_IMIE_NAZWISKO = @v_IMIE_NAZWISKO,  
    @p_ZMT_ROWID = NULL,   
    @p_OBSZAR = @c_OBJ_OBSZAR, 
	@p_COSTCODEID = null,
	@p_NR_SZKODY = null,         
    @p_UserID  = @p_UserID  
  
   select @v_OT42ID = OT42_ROWID from dbo.ZWFOT42v (nolock) where OT_ID = @v_OT42_ID  
    
  end  
           
  select @v_OT42LN_ID = NEWID()  
  select @v_OT42LN_LIKWCZESC = '0'  
  --case when @c_POL_STATUS = 'POL_003' then 'X' else '0' end  
  select @v_OT42LN_PROC = 100  
  --case when @c_POL_STATUS = 'POL_003' then @c_PARTIAL else 100 end  
    
  begin  
   --print 'PL LN'  
   exec [dbo].[ZWFOT42LN_Update_Proc]   
    @p_FormID  = 'OT42_LN',  
    @p_ROWID = NULL,  
    @p_OT42ID = @v_OT42ID,  
    @p_CODE = NULL,  
    @p_ID = @v_OT42LN_ID,  
    @p_ORG = @v_OT42_ORG,  
    @p_RSTATUS = 0,  
    @p_STATUS = NULL,  
    @p_STATUS_old = NULL,  
    @p_TYPE = NULL,  
    @p_ANLN1_POSKI = @c_AST_CODE,  
    @p_ANLN2 = @c_AST_SUBCODE,  
    @p_KOSTL_POSKI = @v_FROM_CCD,  
    @p_GDLGRP_POSKI = @v_FROM_KL5,  
    @p_ODZYSK = 'Nie',  
    @p_LIKWCZESC = @v_OT42LN_LIKWCZESC,  
    @p_PROC = @v_OT42LN_PROC,  
    @p_ZMT_ROWID = NULL,   
    @p_OBJ = @c_OBJ_CODE,  
    @p_UserID  = @p_UserID;  
  end  
    
  if (@v_OT42ID is not null)  
  begin  
   -- zmiana statusu na zgłoszeniu   
   exec [dbo].[SP_REQUEST_Accept_Proc] @p_ID = @p_ROWID,@p_STATUS = 'SRQ_006',@p_TYPE = @c_SRQ_TYPE,@p_NOTE = @c_SRQ_NOTE,@p_UserID = @p_UserID;  
     
     
   update [dbo].[SP_REQUEST] set  
    SRQ_WORKFLOW_USER = @p_UserID,   
    SRQ_WORFKLOW_DATE = GETDATE(),   
    SRQ_WORKFLOW_TYPE = 'PL',  
    SRQ_WORKFLOW_ID = @v_OT42ID  
   WHERE SRQ_ROWID = @p_ROWID  
     
  end  
    
  update [dbo].[SP_REQUEST] set SRQ_OT42ID = (select OT42_ZMT_ROWID from SAPO_ZWFOT42 where OT42_ROWID = @v_OT42ID) where SRQ_ROWID = @c_SRQ_ROWID  
       
 end  
    
 -----------------------------------------------------------------------------------  
 --------------------------------------LTW------------------------------------------  
 -----------------------------------------------------------------------------------   
 if @p_TYPE = 'PL' and LEFT (@c_AST_CODE,1) = '3'  
 begin   
   
  select @v_OT41_ID = NEWID()  
  select @v_OT41_ORG = dbo.GetOrgDef('OT41_RC',@p_UseriD)  
  select @v_OT41_STATUS = dbo.[GetStatusDef]('OT41_RC',NULL,@p_UseriD)       
  
  if not exists (  
   select * from SAPO_ZWFOT41LN (nolock) join dbo.ZWFOT41v (nolock) on OT41_ROWID = OT41LN_OT41ID   
   where   
    OT41LN_KOSTL_POSKI = @v_FROM_CCD and   
    OT41LN_GDLGRP = @v_FROM_KL5 and   
    OT_STATUS not in ('OT41_50','OT41_60'))  
  begin  
   --print 'W NAG'  
   exec [dbo].[ZWFOT41_Update_Proc]   
    @p_FormID  = 'OT41_RC' ,  
    @p_ROWID = NULL,  
    @p_CODE = 'autonumer',  
    @p_ID = @v_OT41_ID,  
    @p_ORG = @v_OT41_ORG,  
    @p_RSTATUS = 0,  
    @p_STATUS = @v_OT41_STATUS,  
    @p_STATUS_old = NULL,  
    @p_TYPE = NULL,  
    @p_KROK = 1,  
    @p_BUKRS = 'PPSA',  
    @p_IF_EQUNR = NULL,  
    @p_IF_SENTDATE = NULL,  
    @p_IF_STATUS = NULL,  
    @p_SAPUSER = '',  
    @p_IMIE_NAZWISKO = @v_IMIE_NAZWISKO,  
    @p_ZMT_ROWID = NULL,   
    @p_OBSZAR = @c_OBJ_OBSZAR,
	@p_NR_SZKODY = NULL,   
	@p_COSTCODEID = NULL,        
    @p_UserID  = @p_UserID;  
      
   select @v_OT41ID = OT41_ROWID from dbo.ZWFOT41v (nolock) where OT_ID = @v_OT41_ID  
    
  end       
  else  
  begin  
     
   select @v_OT41ID = OT41_ROWID from SAPO_ZWFOT41LN (nolock) join dbo.ZWFOT41v (nolock) on OT41_ROWID = OT41LN_OT41ID   
   where   
    OT41LN_KOSTL_POSKI = @v_FROM_CCD and   
    OT41LN_GDLGRP = @v_FROM_KL5 and   
    OT_STATUS not in ('OT41_50','OT41_60')  
      
  end  
    
  select @v_OT41LN_ID = NEWID()  
  
  if not exists (select * from ZWFOT41LNv where OT41LN_OT41ID = @v_OT41ID and OT41LN_ANLN1_POSKI = @c_AST_CODE )  
  begin  
   --print 'W LN'    
   exec [dbo].[ZWFOT41LN_Update_Proc]   
    @p_FormID  = 'OT41_LN',  
    @p_ROWID = NULL,  
    @p_OT41ID = @v_OT41ID,  
    @p_CODE = NULL,  
    @p_ID = @v_OT41LN_ID,  
    @p_ORG = @v_OT41_ORG,  
    @p_RSTATUS = 0,  
    @p_STATUS = NULL,  
    @p_STATUS_old = NULL,  
    @p_TYPE = NULL,  
    @p_ANLN1_POSKI = @c_AST_CODE,   
    @p_KOSTL_POSKI = @v_FROM_CCD,  
    @p_GDLGRP_POSKI = @v_FROM_KL5,  
    @p_UZASA = 'Przeniesiony ze zgłoszenia prowadzących stację',  
    @p_MENGE = 1,  
    @p_ZMT_ROWID = NULL,   
    @p_OBJ = @c_OBJ_CODE,  
    @p_UserID  = @p_UserID;       
  end     
    
  if (@v_OT41ID is not null)  
  begin  
   -- zmiana statusu na zgłoszeniu   
   exec [dbo].[SP_REQUEST_Accept_Proc] @p_ID = @p_ROWID,@p_STATUS = 'SRQ_006',@p_TYPE = @c_SRQ_TYPE,@p_NOTE = @c_SRQ_NOTE,@p_UserID = @p_UserID;  
     
     
   update [dbo].[SP_REQUEST] set  
    SRQ_WORKFLOW_USER = @p_UserID,   
    SRQ_WORFKLOW_DATE = GETDATE(),   
    SRQ_WORKFLOW_TYPE = 'LTW',  
    SRQ_WORKFLOW_ID = @v_OT41ID  
   WHERE SRQ_ROWID = @p_ROWID  
     
  end  
    
  update [dbo].[SP_REQUEST] set SRQ_OT42ID = (select OT42_ZMT_ROWID from SAPO_ZWFOT42 where OT42_ROWID = @v_OT42ID) where SRQ_ROWID = @c_SRQ_ROWID  
    
 end  
      
 return 0  
        
 errorlabel:  
  exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output  
  raiserror (@v_errortext, 16, 1)   
  select @p_apperrortext = @v_errortext  
  return 1  
      
end  
GO