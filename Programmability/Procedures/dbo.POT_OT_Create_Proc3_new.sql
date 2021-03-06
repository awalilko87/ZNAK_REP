SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[POT_OT_Create_Proc3_new](            
@p_FormID nvarchar(50),            
@p_ROWID int,            
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
 declare @v_Rstatus int            
 declare @v_Pref nvarchar(10)            
 declare @v_MultiOrg bit            
 declare @v_STATUS nvarchar(30)            
 declare @v_IS_GB tinyint
            
 declare            
 --zmienne kursora            
  @c_POL_ROWID int,            
  @c_POT_ROWID int,            
  @c_AST_CODE nvarchar(30),            
  @c_AST_SUBCODE nvarchar(30),            
  @c_FROM_CCDID int,            
  @c_FROM_KL5ID int,            
  @c_TO_STNID int,            
  @c_TO_KL5ID int,            
  @c_POL_STATUS nvarchar(30),            
  @c_PARTIAL int,            
  @v_COUNT_MT1 int,            
  @v_COUNT_MT2 int,            
  @v_COUNT_MT3 int,            
  @v_COUNT_PL int,            
  @v_COUNT_LTW int,            
  @v_OTID int,            
  @v_OTLID int,            
            
  @v_DISTINCT_MT1 int,            
  @v_DISTINCT_MT2 int,            
  @v_DISTINCT_MT3 int,            
  @v_DISTINCT_PL int,            
  @v_DISTINCT_LTW int,            
  @v_DISTINCT_PRZ int,            
            
  @c_CZY_UCHWALA nvarchar(1),            
  @c_CZY_DECYZJA nvarchar(1),            
  @c_CZY_ZAKRES nvarchar(1),            
  @c_CZY_OCENA nvarchar(1),            
  @c_CZY_EKSPERTYZY nvarchar(1),            
  @c_SPOSOBLIKW nvarchar(35),            
  @c_PSP_POSKI nvarchar(30),            
  @c_MIESIAC int,            
  @c_POT_CODE nvarchar(30),            
  @c_OBJ_CODE nvarchar(30),            
  @c_OBJ_RESPON nvarchar(30),            
            
  --zmienne do kontrolek            
  @v_FROM_CCD nvarchar(30),            
  @v_FROM_KL5 nvarchar(30),            
  @v_TO_CCD nvarchar(30),            
  @v_TO_KL5 nvarchar(30),            
  @v_IMIE_NAZWISKO nvarchar(30),            
            
  --zmienne nagłówka MT1            
  @v_OT31_ID nvarchar(50),            
  @v_OT31_ORG nvarchar(30),            
  @v_OT31_STATUS nvarchar(30),            
  @v_OT31ID int,            
  --zmienne linii MT1            
  @v_OT31LN_ID nvarchar(50),            
  @v_DT_WYDANIA datetime,            
            
  --zmienne nagłówka MT3            
  @v_OT33_ID nvarchar(50),            
  @v_OT33_ORG nvarchar(30),            
  @v_OT33_STATUS nvarchar(30),            
  @v_OT33_MTOPER nvarchar(1),            
  @v_OT33ID int,            
  --zmienne linii MT3            
  @v_OT33LN_ID nvarchar(50),            
            
  --zmienne nagłówka PL            
  @v_OT42_ID nvarchar(50),            
  @v_OT42_ORG nvarchar(30),            
  @v_OT42_STATUS nvarchar(30),            
  @v_OT42ID int,            
  --zmienne linii PL            
  @v_OT42LN_ID nvarchar(50),            
  @v_OT42LN_LIKWCZESC nvarchar(1),            
  @v_OT42LN_PROC int,            
            
  --zmienne nagłówka LTW            
  @v_OT41_ID nvarchar(50),            
  @v_OT41_ORG nvarchar(30),            
  @v_OT41_STATUS nvarchar(30),            
  @v_OT41ID int,            
  --zmienne linii LTW            
  @v_OT41LN_ID nvarchar(50) ,          
  @v_data datetime          
            
  select @v_data = getdate()           
            
 select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID            
 select @v_STATUS = POT_STATUS from dbo.OBJTECHPROT (nolock) where POT_ROWID = @p_ROWID            
 select @v_Rstatus = isnull(STA_RFLAG,0) from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @v_STATUS            
 select @v_COUNT_MT1 = 0, @v_COUNT_MT2 = 0, @v_COUNT_MT3 = 0, @v_COUNT_PL = 0, @v_COUNT_LTW = 0       
 select @v_DISTINCT_MT1 = 0, @v_DISTINCT_MT2 = 0, @v_DISTINCT_MT3 = 0, @v_DISTINCT_PL = 0, @v_DISTINCT_LTW = 0, @v_DISTINCT_PRZ = 0            
                      
            
 declare @t_ASSET_BLOCKED table (ANLN1_ANLN2 nvarchar(30))            
            
 insert into @t_ASSET_BLOCKED (ANLN1_ANLN2) select ANLN1_ANLN2 from dbo.GetBlockedAssets ()            
            
 if exists (select * from [dbo].[OBJTECHPROT] (nolock) where POT_ROWID = @p_ROWID)            
 begin            
  declare c_POLLN cursor static for            
  select            
  POL_ROWID,            
  POL_POTID,            
  AST_CODE,            
  AST_SUBCODE,            
  FROM_CCDID = CCD_ROWID,            
  FROM_KL5ID = KL5_ROWID,            
  TO_STNID = POL_TO_STNID,            
  TO_KL5ID = TO_STN.STN_KL5ID,            
  POL_STATUS,            
  POL_PARTIAL,            
  POT_CZY_UCHWALA = isnull(POT_CZY_UCHWALA,'N'),            
  POT_CZY_DECYZJA = isnull(POT_CZY_DECYZJA,'N'),            
  POT_CZY_ZAKRES = isnull(POT_CZY_ZAKRES,'N'),            
  POT_CZY_OCENA = isnull(POT_CZY_OCENA,'N'),            
  POT_CZY_EKSPERTYZY = isnull(POT_CZY_EKSPERTYZY,'N'),            
  POT_SPOSOBLIKW,            
  POT_PSP_POSKI,            
  POT_MIESIAC,            
  POT_CODE,            
  OBJ_CODE,            
  OBJ_RESPON = GroupID            
  --POL_001 Do ustalenia            
  --POL_002 Do likwidacji            
  --POL_003 Do cz. likwidacji            
  --POL_004 Pozostaje            
  --POL_005 Do przeniesienia            
            
  from [dbo].[OBJTECHPROTLN] (nolock)            
  join [dbo].[OBJTECHPROT] (nolock) on POL_POTID = POT_ROWID            
  join [dbo].[OBJASSET] (nolock) on POL_OBJID = OBA_OBJID            
  join [dbo].[OBJ] (nolock) on OBJ_ROWID = OBA_OBJID            
  join [dbo].[ASSET] (nolock) a on AST_ROWID = OBA_ASTID and AST_NOTUSED = 0            
  join [dbo].[STATION] FROM_STN on FROM_STN.STN_ROWID = POT_STNID            
  join [dbo].[KLASYFIKATOR5] KL5_FROM (nolock) on KL5_FROM.KL5_ROWID = FROM_STN.STN_KL5ID            
  join [dbo].[COSTCODE] (nolock) on CCD_SAP_KOSTL = AST_SAP_KOSTL            
  left join [dbo].[STATION] (nolock) TO_STN on TO_STN.STN_ROWID = POL_TO_STNID            
  left join dbo.OBJGROUP_RESPONv on OBG_ROWID = OBJ_GROUPID            
  where POL_POTID = @p_ROWID            
  --and AST_CODE + AST_SUBCODE not in (select isnull(ANLN1_ANLN2,'') from @t_ASSET_BLOCKED)            
  and isnull(POL_OBJID,0) not in (select OBJID from dbo.GetBlockedObj())            
  --and POL_STATUS not in ('POL_001', 'POL_004')            
  and POL_STATUS not in ('POL_001', 'POL_004', 'POL_007')            
  --and KL5_TO.KL5_ROWID <> TO_STN.STN_KL5ID            
  order by POL_TO_STNID,a.AST_CODE, a.AST_SUBCODE            
            
  open c_POLLN            
            
  fetch next from c_POLLN into @c_POL_ROWID, @c_POT_ROWID, @c_AST_CODE, @c_AST_SUBCODE, @c_FROM_CCDID, @c_FROM_KL5ID, @c_TO_STNID, @c_TO_KL5ID,            
         @c_POL_STATUS, @c_PARTIAL, @c_CZY_UCHWALA, @c_CZY_DECYZJA, @c_CZY_ZAKRES, @c_CZY_OCENA, @c_CZY_EKSPERTYZY, @c_SPOSOBLIKW, @c_PSP_POSKI,            
         @c_MIESIAC, @c_POT_CODE, @c_OBJ_CODE, @c_OBJ_RESPON            
            
  begin try            
   declare @v_opis nvarchar(70)            
   declare @CREUSER nvarchar(30)            
   set @v_opis = 'Przeniesiony protokół ZMT: '+@c_POT_CODE;            
            
   while @@FETCH_STATUS = 0            
   begin            
    select @v_OTLID = null, @v_OTID = null            
            
    select @v_FROM_CCD = CCD_CODE from COSTCODE where CCD_ROWID = @c_FROM_CCDID            
    select @v_FROM_KL5 = KL5_CODE from KLASYFIKATOR5 where KL5_ROWID = @c_FROM_KL5ID            
    select @v_TO_CCD = STN_CCD from STATIONv where STN_ROWID = @c_TO_STNID            
    select @v_TO_KL5 = KL5_CODE from KLASYFIKATOR5 where KL5_ROWID = @c_TO_KL5ID        
	select @v_IS_GB = case when exists (select 1 from dbo.STATION where STN_TYPE = 'SERWIS' and STN_KL5ID = @c_FROM_KL5ID) then 1 else 0 end
    select @CREUSER = case when   @c_OBJ_RESPON = 'DZR' then CHK_GU_DZR_USER            
          when  @c_OBJ_RESPON = 'IT' then CHK_GU_IT_USER            
          when  @c_OBJ_RESPON = 'BEZP' then CHK_GU_RKB_USER            
          when  @c_OBJ_RESPON = 'UR' then CHK_GU_UR_USER            
          end            
    from OBJTECHPROTv            
    where POT_ROWID = @c_POT_ROWID      
	      
    select @v_IMIE_NAZWISKO = SAPLogin from SyUsers(nolock) where UserID = @CREUSER            

    if @v_IMIE_NAZWISKO is null            
		 begin            
		  set @v_errorcode = 'OT_SAPUSER'            
		  goto errorlabel            
		 end  
   
            
    if            
    (            
     (            
     not exists (select 1 from dbo.ASSET (nolock) where AST_CODE = @c_AST_CODE and AST_SUBCODE <> isnull(@c_AST_SUBCODE,'')) --jest tylko składnik główny            
     or            
     not exists (select 1 from dbo.ASSET (nolock) where AST_CODE = @c_AST_CODE and AST_ROWID not in            
     (select POL_OBJID from [dbo].[OBJTECHPROTLN] (nolock) join OBJASSET (nolock) on OBA_OBJID = POL_OBJID where POL_POTID = @c_POT_ROWID))--wszystkie podskładniki tego składnika są wysyłane w tym FR (można to zrobić MT1)            
     ) and @c_POL_STATUS in ('POL_005')            
    )            
    or            
    (            
     not exists (select 1 from dbo.ASSET (nolock) where AST_CODE = @c_AST_CODE and AST_SUBCODE <> isnull(@c_AST_SUBCODE,''))            
     and @c_POL_STATUS in ('POL_003')            
    )            
    or            
    (            
     left(@c_AST_CODE,1) = '3' and @c_POL_STATUS in ('POL_003')            
    )            
    -----------------------------------------------------------------------------------            
    ----------------------------------------MT1----------------------------------------            
    -----------------------------------------------------------------------------------            
    begin            
  select @v_COUNT_MT1 = @v_COUNT_MT1 + 1            
     select @v_OT31_ID = NEWID()            
     select @v_OT31_ORG = dbo.GetOrgDef('OT31_RC',@p_UseriD)            
     select @v_OT31_STATUS = dbo.[GetStatusDef]('OT31_RC',NULL,@p_UseriD)            
            
     if not exists (select * from SAPO_ZWFOT31LN (nolock) L             
         join dbo.ZWFOT31v (nolock) on OT31_ROWID = L.OT31LN_OT31ID             
         where            
         L.OT31LN_MPK_WYDANIA = @v_FROM_CCD and            
         L.OT31LN_GDLGRP = @v_FROM_KL5 and            
         L.OT31LN_MPK_PRZYJECIA = @v_TO_CCD and            
         L.OT31LN_UZYTKOWNIK = @v_TO_KL5 and            
         OT_STATUS in ('OT31_10') and             
         OT_OBSZAR = @c_OBJ_RESPON            
        )            
     begin            
      select @v_DISTINCT_MT1 = @v_DISTINCT_MT1 + 1            
            
      --print 'MT1 NAG'            
      exec [dbo].[ZWFOT31_Update_Proc]            
       @p_FormID= 'OT31_RC' ,            
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
       @p_OBSZAR = @c_OBJ_RESPON, 
	   @p_COSTCODEID = NULL,           
       @p_UserID = @CREUSER;            
            
      select @v_OT31ID = OT31_ROWID from dbo.ZWFOT31v (nolock) where OT_ID = @v_OT31_ID            
     end            
     else            
     begin            
      select @v_OT31ID = OT31_ROWID             
      from SAPO_ZWFOT31LN (nolock) L             
      join dbo.ZWFOT31v (nolock) on OT31_ROWID = L.OT31LN_OT31ID            
      where L.OT31LN_MPK_WYDANIA = @v_FROM_CCD and            
      L.OT31LN_GDLGRP = @v_FROM_KL5 and           
      L.OT31LN_MPK_PRZYJECIA = @v_TO_CCD and            
      L.OT31LN_UZYTKOWNIK = @v_TO_KL5 and            
      OT_STATUS in ('OT31_10') and             
      OT_OBSZAR = @c_OBJ_RESPON            
     end            
            
     select @v_OT31LN_ID = NEWID()            
     select @v_DT_WYDANIA = GETDATE()            
            
     if not exists (select * from ZWFOT31LNv where OT31LN_OT31ID = @v_OT31ID and OT31LN_ANLN1_POSKI = @c_AST_CODE)            
     begin            
      --print 'MT1 LN'            
      exec [dbo].[ZWFOT31LN_Update_Proc]            
       @p_FormID= 'OT31_LN' ,            
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
       @p_UZASADNIENIE = @v_opis,            
       @p_DT_WYDANIA = @v_DT_WYDANIA,            
       @p_MPK_WYDANIA_POSKI = @v_FROM_CCD,            
       @p_GDLGRP_POSKI = @v_FROM_KL5,            
       @p_DT_PRZYJECIA = @v_DT_WYDANIA,            
       @p_MPK_PRZYJECIA_POSKI = @v_TO_CCD,            
       @p_UZYTKOWNIK_POSKI = @v_TO_KL5,            
       @p_ZMT_ROWID = NULL,            
       @p_PRACOWNIK = '',            
       @p_OBJ = @c_OBJ_CODE,            
       @p_UserID= @CREUSER;            
     end            
            
     update [dbo].[OBJTECHPROTLN] set POL_OT31ID = (select OT31_ZMT_ROWID from SAPO_ZWFOT31 where OT31_ROWID = @v_OT31ID) where POL_ROWID = @c_POL_ROWID            
    end            
    else if @c_POL_STATUS in ('POL_005', 'POL_003')            
-----------------------------------------------------------------------------------            
    ----------------------------------------MT3----------------------------------------            
    -----------------------------------------------------------------------------------            
    begin 
	           
     if @v_FROM_KL5 = @v_TO_KL5 and @v_IS_GB = 1
     begin            
      select @v_DISTINCT_PRZ = @v_DISTINCT_PRZ + 1             
          
      update dbo.OBJSTATION set            
        OSA_STNID = @c_TO_STNID            
       ,OSA_UPDUSER = @p_UserID            
       ,OSA_UPDDATE = getdate()            
      where OSA_OBJID = (select OBJ_ROWID from dbo.OBJ where OBJ_CODE = @c_OBJ_CODE)            
            
      update dbo.OBJ set            
       OBJ_PARENTID = (select OBJ_ROWID from dbo.OBJ join OBJSTATION on OSA_OBJID = OBJ_ROWID and OSA_STNID = @c_TO_STNID and OBJ_STSID = 23)            
      where OBJ_CODE = @c_OBJ_CODE            
     end            
     else            
     begin              
             
      select @v_OT33_ID = NEWID()            
      select @v_OT33_ORG = dbo.GetOrgDef('OT33_RC',@p_UseriD)            
      select @v_OT33_STATUS = dbo.[GetStatusDef]('OT33_RC',NULL,@p_UseriD)            
      select @v_OT33_MTOPER = case when @c_AST_SUBCODE = '0000' then 2 else 4 end --IT używa tylko parzyste, operacje 2 i 4 są częściowe, gdy wartość 100% ustala to po wprowadzeniu pozycji            
      --select OPER, OPER_DESC from [dbo].[GetMT3Type] ()            
                                  
      if not exists (            
            
        select * from SAPO_ZWFOT33LN (nolock) L             
         join dbo.ZWFOT33v (nolock) on OT33_ROWID = L.OT33LN_OT33ID             
         join dbo.ZWFOT33DONv on OT33DON_OT33ID = OT33_ROWID        
   inner join STATIONv on L.OT33LN_GDLGRP_POSKI = STN_KL5        
         where            
         OT_STATUS = ('OT33_10')             
         and OT33DON_ANLN1_POSKI = @c_AST_CODE            
         and OT33DON_ANLN2 = @c_AST_SUBCODE            
         and OT33DON_MTOPER = 'X'    
	   --and OT_CREUSER = @p_UserID     
		   and OT33_POTID = @c_POT_ROWID 
		   and OT33_TOSTNID = @c_TO_STNID      
	   --and OT_CREDATE > @v_data          
   )             
            
     BEGIN                           
		  select @v_DISTINCT_MT3 = @v_DISTINCT_MT3 + 1            
          
		  --@c_AST_CODE + @c_AST_SUBCODE                  
		  exec [dbo].[ZWFOT33_Update_Proc]            
		   @p_FormID= 'OT33_RC',            
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
		   @p_tostnid = @c_TO_STNID, 
		   @p_CCDID = null,        
		   @p_UserID= @CREUSER,    
		   @p_POTID = @c_POT_ROWID;            
            
	  -- end          
             
	  --declare @OT33ID int          
	  --select @OT33ID = IDENT_CURRENT('SAPO_ZWFOT33')           
		select @v_OT33ID = OT33_ROWID from dbo.ZWFOT33v (nolock) where OT_ID = @v_OT33_ID  and OT33_POTID = @c_POT_ROWID  and OT33_TOSTNID = @c_TO_STNID          
	--      select @v_OT33ID = max(OT_ROWID) from ZWFOT  where OT_STATUS = 'OT33_10' and OT_TYPE = 'SAPO_ZWFOT33' and OT_CREUSER = @p_UserID          
		  select @v_OT33LN_ID = NEWID()           
		  select @v_DT_WYDANIA = GETDATE()            
      

	  ---- RaisError('%i',16,1,@v_OT33ID)          
          
          
		--select @v_COUNT_MT3 = @v_COUNT_MT3 + 1           
		--  --print 'MT3 LN'   
	           
		  exec [dbo].[ZWFOT33LN_Update_Proc]            
		   @p_FormID= 'OT33_LN' ,            
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
		   @p_UZASADNIENIE = @v_opis,            
		   @p_TXT50 = '',            
		   @p_ZMT_ROWID = NULL,            
		   @p_UserID= @CREUSER;            
            
		  --select * from ZWFOT33DONv where            
		  -- OT33DON_OT33ID = @v_OT33ID and            
		  -- OT33DON_ANLN1_POSKI = @c_AST_CODE and            
		  -- OT33DON_ANLN2 = @c_AST_SUBCODE            
  END
  		select @v_COUNT_MT3 = @v_COUNT_MT3 + 1           
		  --print 'MT3 LN' 
            
		  declare @v_WARST_DO decimal            
		  declare @v_PRCNT_DO decimal            
            
		  select top 1             
		   @v_WARST_DO = case when OBJ_VALUE is null then AST_SAP_URWRT else OBJ_VALUE end            
		  from ASSET            
		  join OBJASSET on OBA_ASTID = AST_ROWID            
		  join OBJ on OBA_OBJID = OBJ_ROWID            
		  where AST_CODE = @c_AST_CODE and AST_SUBCODE = @c_AST_SUBCODE and OBJ_CODE = @c_OBJ_CODE     
		  
		         
            
		  --print 'MT3 DON'            
		  exec [dbo].[ZWFOT33DON_Update_Proc]            
		   @p_FormID= 'OT33_DON',            
		   @p_ROWID = NULL,            
		   @p_OT33ID = @v_OT33ID,            
		   @p_CODE = NULL,            
		   @p_ID = NULL,            
		   @p_ORG = @v_OT33_ORG,            
		   @p_RSTATUS = 0,            
		   @p_STATUS = NULL,            
		   @p_STATUS_old = NULL,            
		   @p_TYPE = NULL,            
		   @p_TXT50 = NULL,            
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
		   @p_UserID= @CREUSER;  
		   
		  		    
		  --[DS]update dbo.[OBJTECHPROTLN] set POL_OT33ID = @v_OT33ID where POL_ROWID = @c_POL_ROWID            
		  update [dbo].[OBJTECHPROTLN] set POL_OT33ID = (select OT33_ZMT_ROWID from SAPO_ZWFOT33 where OT33_ROWID = @v_OT33ID) where POL_ROWID = @c_POL_ROWID            
            
		  select @v_PRCNT_DO = OT33DON_PRCNT_DO from dbo.SAPO_ZWFOT33DON where OT33DON_OT33ID = @v_OT33ID and OT33DON_MTOPER = 'X'            
            
		  --ustalenie wartości parametru "Wybierz operację"            
		  if @v_PRCNT_DO = 100            
				begin            
				 --if @v_OT33_MTOPER = 2 --2 główny częściowy            
				 -- update SAPO_ZWFOT33 set OT33_MTOPER = 0 where OT33_ROWID = @v_OT33ID--0 nie da się wydzielić 100% ze składnika głównego            
				 if @v_OT33_MTOPER = 4 --4 podnumer częściowy   	          
				   update SAPO_ZWFOT33 
				   set OT33_MTOPER = 6 
				   where OT33_ROWID = @v_OT33ID--6 podnumer całościowy   
   
			   end 
            
   end            
     end           
           
  --  end            
    else if @c_POL_STATUS in ('POL_002'/*, 'POL_003'*/, 'POL_008') and LEFT (@c_AST_CODE,1) <> '3'            
    -----------------------------------------------------------------------------------            
    ----------------------------------------PL----------------------------------------            
    -----------------------------------------------------------------------------------            
    begin    
	 declare @v_sposob2 nvarchar(30) -- inny sposób generowania dokumentów PL (zgłoszenie PKNTA-751)
     
	 select @v_COUNT_PL = @v_COUNT_PL + 1    
     select @v_OT42_ID = NEWID()    
     select @v_OT42_ORG = dbo.GetOrgDef('OT42_RC',@p_UseriD)    
     select @v_OT42_STATUS = dbo.[GetStatusDef]('OT42_RC',NULL,@p_UserID)    
	 select @v_sposob2 = POT_NTX01 from OBJTECHPROT where POT_ROWID = @c_POT_ROWID
    
     if @c_POL_STATUS = 'POL_008'    
     begin    
      set @c_SPOSOBLIKW = 5    
     end    


	 if @v_sposob2 = '1.000000'

	 begin 
	 declare @v_IMIE_NAZWISKO_INW nvarchar(30)

	 select @v_IMIE_NAZWISKO_INW = SAPLogin from SYUsers where UserID = (select POT_CREUSER from OBJTECHPROT where POT_ROWID = @c_POT_ROWID)
	 declare @CREUSER_INW nvarchar(30) 
	 select @CREUSER_INW = POT_CREUSER from OBJTECHPROT where POT_ROWID = @c_POT_ROWID

	 select @CREUSER  = 	 case when @c_OBJ_RESPON = 'IT' then @CREUSER
								else @CREUSER_INW end 

	 declare @v_OT_OBSZAR nvarchar(20)
	 select @v_OT_OBSZAR = case when @c_OBJ_RESPON = 'IT' then 'IT'
								else 'INW' end 

	select @v_IMIE_NAZWISKO = case when @c_OBJ_RESPON = 'IT' then @v_IMIE_NAZWISKO
								else @v_IMIE_NAZWISKO_INW end  


	  if not exists (    
      select *    
      from SAPO_ZWFOT42LN (nolock)    
      join dbo.ZWFOT42v (nolock) on OT42_ROWID = OT42LN_OT42ID    
      join ASSET asset_exists (nolock) on AST_SAP_ANLN1= OT42LN_ANLN1 and AST_SUBCODE = OT42LN_ANLN2    
      where    
      OT42LN_KOSTL_POSKI = @v_FROM_CCD and    
      OT42LN_GDLGRP = @v_FROM_KL5 and    
      OT_STATUS in ('OT42_10') and     
      isnull(OT42_SPOSOBLIKW,'') = @c_SPOSOBLIKW 
	  and OT_OBSZAR = @v_OT_OBSZAR )

	  begin

      select @v_DISTINCT_PL = @v_DISTINCT_PL + 1    
    
      select @v_opis = [desc] + '. Protokół ZMT: '+@c_POT_CODE from dbo.LIQUIDATION_METHODv where code = @c_SPOSOBLIKW    
    
      --print 'PL NAG'    
      exec [dbo].[ZWFOT42_Update_Proc]    
       @p_FormID= 'OT42_RC',    
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
       @p_UZASADNIENIE = @v_opis,    
       @p_KOSZT = NULL,    
       @p_SZAC_WART_ODZYSKU = NULL,    
       @p_SPOSOBLIKW = @c_SPOSOBLIKW,    
       @p_PSP_POSKI = @c_PSP_POSKI,    
       @p_ROK = NULL,    
       @p_MIESIAC = @c_MIESIAC,    
       @p_CZY_UCHWALA = @c_CZY_UCHWALA,    
       @p_CZY_DECYZJA = @c_CZY_DECYZJA,    
       @p_CZY_ZAKRES = @c_CZY_ZAKRES,    
       @p_CZY_OCENA = @c_CZY_OCENA,    
       @p_CZY_EKSPERTYZY = @c_CZY_EKSPERTYZY,    
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
       @p_OBSZAR = @v_OT_OBSZAR,
	   @p_COSTCODEID = null, 	      
       @p_NR_SZKODY = null,
	   @p_POTID = null,
       @p_UserID= @CREUSER    
    
      select @v_OT42ID = OT42_ROWID, @v_OTID = OT_ROWID from dbo.ZWFOT42v (nolock) where OT_ID = @v_OT42_ID    
     end    
     else    
     begin    
      select     
        @v_OT42ID = OT42_ROWID    
       ,@v_OTID = OT_ROWID    
      from SAPO_ZWFOT42LN (nolock)    
      join dbo.ZWFOT42v (nolock) on OT42_ROWID = OT42LN_OT42ID    
      where OT42LN_KOSTL_POSKI = @v_FROM_CCD and    
      OT42LN_GDLGRP = @v_FROM_KL5 and    
      OT_STATUS in ('OT42_10') and     
      isnull(OT42_SPOSOBLIKW,'') = @c_SPOSOBLIKW and    
      OT_OBSZAR = @v_OT_OBSZAR    
     end    
    
     select @v_OT42LN_ID = NEWID()    
     select @v_OT42LN_LIKWCZESC = 'X'    
     --= case when @c_POL_STATUS = 'POL_003' then 'X' else '0' end    
     select @v_OT42LN_PROC = @c_PARTIAL    
     --case when @c_POL_STATUS = 'POL_003' then @c_PARTIAL else 100 end    
    
     if not exists (select * from ZWFOT42LNv where OT42LN_OT42ID = @v_OT42ID 
	 and OT42LN_ANLN1_POSKI = @c_AST_CODE and OT42LN_ANLN2 = @c_AST_SUBCODE )    
     begin    
      --print 'PL LN'    
      exec [dbo].[ZWFOT42LN_Update_Proc]    
       @p_FormID= 'OT42_LN',    
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
       @p_ODZYSK = 'NIE',    
       @p_LIKWCZESC = @v_OT42LN_LIKWCZESC,    
       @p_PROC = @v_OT42LN_PROC,    
       @p_ZMT_ROWID = NULL,    
       @p_OBJ = @c_OBJ_CODE,    
       @p_UserID= @CREUSER;    
     end    
     else    
     begin    
      select @v_OTLID = OTL_ROWID from ZWFOT42LNv where OT42LN_OT42ID = @v_OT42ID and OT42LN_ANLN1_POSKI = @c_AST_CODE and OT42LN_ANLN2 = @c_AST_SUBCODE    
    
      insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OTLID, OTO_OBJID, OTO_ASTCODE, OTO_ASTSUBCODE, OTO_CREUSER, OTO_CREDATE)    
      select @v_OTID, @v_OTLID, OBJ_ROWID, AST_CODE, AST_SUBCODE, @p_UserID, getdate()    
      from dbo.OBJASSETv    
      where AST_CODE = @c_AST_CODE and AST_SUBCODE = @c_AST_SUBCODE and AST_NOTUSED = 0 and OBJ_CODE = @c_OBJ_CODE    
      and not exists (select 1 from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID and OTO_OBJID = OBJ_ROWID)    
     end    
    
     --[DS]update dbo.[OBJTECHPROTLN] set POL_OT42ID = @v_OT42ID where POL_ROWID = @c_POL_ROWID    
     update [dbo].[OBJTECHPROTLN] set POL_OT42ID = (select OT42_ZMT_ROWID from SAPO_ZWFOT42 where OT42_ROWID = @v_OT42ID) where POL_ROWID = @c_POL_ROWID   

	  end


	 else 

begin
    
     if not exists (    
      select *    
      from SAPO_ZWFOT42LN (nolock)    
      join dbo.ZWFOT42v (nolock) on OT42_ROWID = OT42LN_OT42ID    
      join ASSET asset_exists (nolock) on AST_SAP_ANLN1= OT42LN_ANLN1 and AST_SUBCODE = OT42LN_ANLN2    
      where    
      OT42LN_KOSTL_POSKI = @v_FROM_CCD and    
      OT42LN_GDLGRP = @v_FROM_KL5 and    
      OT_STATUS in ('OT42_10') and     
      isnull(OT42_SPOSOBLIKW,'') = @c_SPOSOBLIKW 
	  and OT_OBSZAR = @c_OBJ_RESPON)   
	  
	   
     begin    
      select @v_DISTINCT_PL = @v_DISTINCT_PL + 1    
    
      select @v_opis = [desc] + '. Protokół ZMT: '+@c_POT_CODE from dbo.LIQUIDATION_METHODv where code = @c_SPOSOBLIKW    
    
      --print 'PL NAG'    
      exec [dbo].[ZWFOT42_Update_Proc]    
       @p_FormID= 'OT42_RC',    
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
       @p_UZASADNIENIE = @v_opis,    
       @p_KOSZT = NULL,    
       @p_SZAC_WART_ODZYSKU = NULL,    
       @p_SPOSOBLIKW = @c_SPOSOBLIKW,    
       @p_PSP_POSKI = @c_PSP_POSKI,    
       @p_ROK = NULL,    
       @p_MIESIAC = @c_MIESIAC,    
       @p_CZY_UCHWALA = @c_CZY_UCHWALA,    
       @p_CZY_DECYZJA = @c_CZY_DECYZJA,    
       @p_CZY_ZAKRES = @c_CZY_ZAKRES,    
       @p_CZY_OCENA = @c_CZY_OCENA,    
       @p_CZY_EKSPERTYZY = @c_CZY_EKSPERTYZY,    
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
       @p_OBSZAR = @c_OBJ_RESPON,   
	   @p_COSTCODEID = null,
       @p_NR_SZKODY = null,
	   @p_POTID = null,
       @p_UserID= @CREUSER    
    
      select @v_OT42ID = OT42_ROWID, @v_OTID = OT_ROWID from dbo.ZWFOT42v (nolock) where OT_ID = @v_OT42_ID    
     end    
     else    
     begin    
      select     
        @v_OT42ID = OT42_ROWID    
       ,@v_OTID = OT_ROWID    
      from SAPO_ZWFOT42LN (nolock)    
      join dbo.ZWFOT42v (nolock) on OT42_ROWID = OT42LN_OT42ID    
      where OT42LN_KOSTL_POSKI = @v_FROM_CCD and    
      OT42LN_GDLGRP = @v_FROM_KL5 and    
      OT_STATUS in ('OT42_10') and     
      isnull(OT42_SPOSOBLIKW,'') = @c_SPOSOBLIKW and    
      OT_OBSZAR = @c_OBJ_RESPON    
     end    
    
	  declare @STS_TYPE nvarchar(5)    
	  declare @suma_sk numeric(16,2)    
	  declare @wart_pocz numeric(16,2)    
	  select @STS_TYPE = sts_Settype from Stencil where sts_rowid = (select obj_stsid from obj where OBJ_ROWID = @p_ROWID)    
	  select @suma_sk = sum(obj_value) from obj join OBJASSET on obj_rowid = OBA_OBJID join OBJTECHPROTLN on OBA_OBJID = POL_OBJID and POL_POTID = @p_ROWID and POL_STATUS = 'POL_002'
	  where OBA_ASTID = (select AST_ROWID from ASSET where AST_CODE = @c_AST_CODE and AST_SUBCODE = @c_AST_SUBCODE)   
	  select @wart_pocz = AST_SAP_URWRT from ASSET where AST_CODE = @c_AST_CODE and AST_SUBCODE = @c_AST_SUBCODE 


     select @v_OT42LN_ID = NEWID()    
     select @v_OT42LN_LIKWCZESC = 'X'    
     --= case when @c_POL_STATUS = 'POL_003' then 'X' else '0' end    
      select @v_OT42LN_PROC = case when @STS_TYPE in ('EZES', 'ZES') and  @v_OT42LN_LIKWCZESC = 'X' then IsNull((@suma_sk/@wart_pocz),0) * 100  else  @c_PARTIAL  end   
	-- select @v_OT42LN_PROC = @c_PARTIAL    
     --case when @c_POL_STATUS = 'POL_003' then @c_PARTIAL else 100 end   
	 
 
     if not exists (select * from ZWFOT42LNv where OT42LN_OT42ID = @v_OT42ID 
	 and OT42LN_ANLN1_POSKI = @c_AST_CODE and OT42LN_ANLN2 = @c_AST_SUBCODE )    
     begin    
      --print 'PL LN'    
      exec [dbo].[ZWFOT42LN_Update_Proc]    
       @p_FormID= 'OT42_LN',    
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
       @p_UserID= @CREUSER;    
     end    
     else    
     begin    
      select @v_OTLID = OTL_ROWID from ZWFOT42LNv where OT42LN_OT42ID = @v_OT42ID and OT42LN_ANLN1_POSKI = @c_AST_CODE and OT42LN_ANLN2 = @c_AST_SUBCODE    
    
      insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OTLID, OTO_OBJID, OTO_ASTCODE, OTO_ASTSUBCODE, OTO_CREUSER, OTO_CREDATE)    
      select @v_OTID, @v_OTLID, OBJ_ROWID, AST_CODE, AST_SUBCODE, @p_UserID, getdate()    
      from dbo.OBJASSETv    
      where AST_CODE = @c_AST_CODE and AST_SUBCODE = @c_AST_SUBCODE and AST_NOTUSED = 0 and OBJ_CODE = @c_OBJ_CODE    
      and not exists (select 1 from dbo.ZWFOTOBJ where OTO_OTID = @v_OTID and OTO_OBJID = OBJ_ROWID)    
     end    
    
     --[DS]update dbo.[OBJTECHPROTLN] set POL_OT42ID = @v_OT42ID where POL_ROWID = @c_POL_ROWID    
     update [dbo].[OBJTECHPROTLN] set POL_OT42ID = (select OT42_ZMT_ROWID from SAPO_ZWFOT42 where OT42_ROWID = @v_OT42ID) where POL_ROWID = @c_POL_ROWID    
    
    end  
	
end	               
            
    else if @c_POL_STATUS in ('POL_002'/*, 'POL_003'*/) and LEFT (@c_AST_CODE,1) = '3'            
          
    -----------------------------------------------------------------------------------            
    --------------------------------------LTW------------------------------------------            
    -----------------------------------------------------------------------------------            
    begin            
     select @v_COUNT_LTW = @v_COUNT_LTW + 1            
     select @v_OT41_ID = NEWID()            
     select @v_OT41_ORG = dbo.GetOrgDef('OT41_RC',@p_UseriD)            
     select @v_OT41_STATUS = dbo.[GetStatusDef]('OT41_RC',NULL,@p_UseriD)            
            
     if not exists (select * from SAPO_ZWFOT41LN (nolock)             
         join dbo.ZWFOT41v (nolock) on OT41_ROWID = OT41LN_OT41ID             
         where            
         OT41LN_KOSTL_POSKI = @v_FROM_CCD and            
         OT41LN_GDLGRP = @v_FROM_KL5 and            
         OT_STATUS in ('OT41_10') and             
         OT_OBSZAR = @c_OBJ_RESPON            
        )            
     begin            
      select @v_DISTINCT_LTW = @v_DISTINCT_LTW + 1            
            
      --print 'W NAG'            
      exec [dbo].[ZWFOT41_Update_Proc]            
       @p_FormID= 'OT41_RC' ,            
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
       @p_OBSZAR = @c_OBJ_RESPON,            
       @p_NR_SZKODY = null,
	   @p_COSTCODEID = null,            
       @p_UserID= @CREUSER;            
            
      select @v_OT41ID = OT41_ROWID from dbo.ZWFOT41v (nolock) where OT_ID = @v_OT41_ID            
     end            
     else            
     begin            
      select @v_OT41ID = OT41_ROWID from SAPO_ZWFOT41LN (nolock) join dbo.ZWFOT41v (nolock) on OT41_ROWID = OT41LN_OT41ID            
      where            
      OT41LN_KOSTL_POSKI = @v_FROM_CCD and            
      OT41LN_GDLGRP = @v_FROM_KL5 and            
 OT_STATUS in ('OT41_10') and            
      OT_OBSZAR = @c_OBJ_RESPON            
     end            
            
     select @v_OT41LN_ID = NEWID()            
            
     if not exists (select * from ZWFOT41LNv where OT41LN_OT41ID = @v_OT41ID and OT41LN_ANLN1_POSKI = @c_AST_CODE )            
     begin            
      --print 'W LN'            
      exec [dbo].[ZWFOT41LN_Update_Proc]            
       @p_FormID= 'OT41_LN',            
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
      @p_UZASA = @v_opis,            
       @p_MENGE = 1,            
       @p_ZMT_ROWID = NULL,            
       @p_OBJ = @c_OBJ_CODE,            
       @p_UserID= @CREUSER;            
     end            
            
     --[DS]update dbo.[OBJTECHPROTLN] set POL_OT41ID = @v_OT41ID where POL_ROWID = @c_POL_ROWID            
     update [dbo].[OBJTECHPROTLN] set POL_OT41ID = (select OT41_ZMT_ROWID from SAPO_ZWFOT41 where OT41_ROWID = @v_OT41ID) where POL_ROWID = @c_POL_ROWID            
    end            
            
    fetch next from c_POLLN into @c_POL_ROWID, @c_POT_ROWID, @c_AST_CODE, @c_AST_SUBCODE, @c_FROM_CCDID, @c_FROM_KL5ID, @c_TO_STNID, @c_TO_KL5ID,            
         @c_POL_STATUS, @c_PARTIAL, @c_CZY_UCHWALA, @c_CZY_DECYZJA, @c_CZY_ZAKRES, @c_CZY_OCENA, @c_CZY_EKSPERTYZY, @c_SPOSOBLIKW, @c_PSP_POSKI,            
         @c_MIESIAC, @c_POT_CODE, @c_OBJ_CODE, @c_OBJ_RESPON            
   end            
            
   close c_POLLN            
   deallocate c_POLLN            
            
  end try            
  begin catch            
   select @v_syserrorcode = error_message()            
   goto errorlabel_c            
  end catch            
 end            
            
 select @v_errortext = '<B> Utworzono dokumentów pre MT1 : ' + cast(@v_DISTINCT_MT1 as nvarchar) + ' na podstawie ' + cast(@v_COUNT_MT1 as nvarchar) + ' linii. </B><BR>'            
 --select @v_errortext = @v_errortext + '<B> Utworzono dokumentów MT2: ' + cast(@v_DISTINCT_MT2 as nvarchar) + ' na podstawie ' + cast(@v_COUNT_MT2 as nvarchar) + ' lini. </B><BR>'            
 select @v_errortext = @v_errortext + '<B> Utworzono dokumentów pre MT3: ' + cast(@v_DISTINCT_MT3 as nvarchar) + ' na podstawie ' + cast(@v_COUNT_MT3 as nvarchar) + ' linii. </B><BR>'            
 select @v_errortext = @v_errortext + '<B> Utworzono dokumentów pre PL: ' + cast(@v_DISTINCT_PL as nvarchar) + ' na podstawie ' + cast(@v_COUNT_PL as nvarchar) + ' linii. </B><BR>'            
 select @v_errortext = @v_errortext +' <B> Utworzono dokumentów pre LTW: ' + cast(@v_DISTINCT_LTW as nvarchar) + ' na podstawie ' + cast(@v_COUNT_LTW as nvarchar) + ' linii. </B><BR>'            
 select @v_errortext = @v_errortext +' <B> Przeniesiono: ' + cast(@v_DISTINCT_PRZ as nvarchar) + ' urządzeń w ramach jednego użytkownika</B><BR>'
            
 raiserror(@v_errortext,1,1)            
            
 return 0            
            
errorlabel:            
 exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output            
 raiserror (@v_errortext, 16, 1)            
 select @p_apperrortext = @v_errortext            
 return 1            
            
errorlabel_c:            
 exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output            
 raiserror (@v_errortext, 16, 1)            
 select @p_apperrortext = @v_errortext            
 close c_POLLN            
 deallocate c_POLLN            
 return 1            
            
END 
GO