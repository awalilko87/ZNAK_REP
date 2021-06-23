SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[FZBK_ZWFOT11_Update_Proc]     
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
@p_ANLKL_POSKI nvarchar(8),    
@p_ANLN1_POSKI nvarchar(12),    
@p_ANLN1_INW_POSKI nvarchar(12),    
@p_BRANZA nvarchar(10),    
@p_BUKRS nvarchar(30),    
@p_CZY_BUD nvarchar(1),    
@p_CZY_BUDOWLA nvarchar(1),    
@p_CZY_FUND nvarchar(1),    
@p_CZY_NIEMAT nvarchar(1),    
@p_CZY_SKL_POZW nvarchar(1),    
@p_DATA_DOK datetime,    
@p_DATA_DOST datetime,    
@p_GDLGRP_POSKI nvarchar(30),    
@p_HERST_POSKI nvarchar(30),    
@p_IF_EQUNR nvarchar(30),    
@p_IF_SENTDATE datetime,    
@p_IF_STATUS int,    
@p_IMIE_NAZWISKO nvarchar(80),    
@p_INVNR_NAZWA nvarchar(50),    
@p_KOSTL_POSKI nvarchar(30),    
@p_KROK nvarchar(10),    
@p_LAND1 nvarchar(3),    
@p_MIES_DOST int,    
@p_MUZYTKID int,    
@p_MUZYTK nvarchar(30),    
@p_NAZWA_DOK nvarchar(1),    
@p_NUMER_DOK nvarchar(15),    
@p_POSNR_POSKI nvarchar(30),    
@p_PRZEW_OKRES int,    
@p_ROK_DOST int,    
@p_SAPUSER nvarchar(12),    
@p_SERNR_POSKI nvarchar(30),    
@p_TYP_SKLADNIKA nvarchar(1),    
@p_WART_NAB_PLN numeric(30,2),    
@p_WOJEWODZTWO nvarchar(12),    
@p_PODZ_USL_P int,    
@p_PODZ_USL_S int,    
@p_PODZ_USL_B int,    
@p_PODZ_USL_C int,    
@p_PODZ_USL_U int,    
@p_PODZ_USL_H int,    
@p_CZY_BEZ_ZM nvarchar(1),    
@p_CZY_PLAN_POZW nvarchar(1),    
@p_CZY_POZWOL nvarchar(1),    
@p_CZY_ROZ_OKR nvarchar(1),    
@p_CZY_WYD_POZW nvarchar(1),    
@p_WART_FUND nvarchar(1),    
@p_ZZ_DATA_UPRA_DEC datetime,    
@p_ZZ_DATA_UPRA_ZGL datetime,    
@p_ZZ_DATA_WYD_DEC datetime,    
@p_ZZ_DATA_ZGL datetime,    
@p_ZZ_PLAN_DAT_DEC datetime,    
@p_ZZ_PLAN_DATA_ZGL datetime,    
@p_CHAR nvarchar(max),    
@p_ZMT_ROWID int,    
@p_ZMT_OBJ_CODE nvarchar(30),    
@p_INOID int,    
@p_OBJKEYS nvarchar(max),  
@p_UDF01 nvarchar(100),  
@p_UDF02 nvarchar(100),   
@p_UDF03 nvarchar(100),  
--@p_OT11_RECEIVE_DATE datetime,  
--@p_OT11_INSTALL_DATE datetime,  
--@p_OT11_INVOICE_DATE datetime,
@p_OT11_AKT_OKR_AMORT int,     
@p_NETVALUE numeric(16,2),
@p_ACTVALUEDATE datetime,
@p_UserID nvarchar(30) = NULL, -- uzytkownik    
@p_apperrortext nvarchar(4000) = null output    
)    
as    
begin    
     
	--RaisError (N'KOMUNIKAT BŁĘDU TESTOWY',16,1)


 declare @v_errorcode nvarchar(50)    
 declare @v_syserrorcode nvarchar(4000)    
 declare @v_errortext nvarchar(4000)    
 declare @v_date datetime     
 declare @v_Pref nvarchar(10)    
 declare @v_MultiOrg BIT    
 declare @v_OTID int,    
		  @v_IF_STATUS int,    
		  @v_RSTATUS int,    
		  @v_KL5ID int,    
		  @v_PSPID int, --PSP     
		  @v_POSNR int, --PSP    
		  @v_ITSID int, --ZAD INW    
		  @v_SERNR nvarchar(30), --ZAD INW    
		  @v_ANLKL nvarchar(8),    
		  @v_ANLN1 nvarchar(12),    
		  @v_ANLN1_INW nvarchar(12),    
		  @v_GDLGRP nvarchar(30),    
		  @v_HERST nvarchar(30),    
		  @v_KOSTL nvarchar(30),    
		  @v_OBJID int,    
		  @v_MUZYTK nvarchar(30),    
		  @v_OT11ID int,    
		  @v_KOSTL_POSKI nvarchar(40),
		  @v_PARENT_ID int    
     
 if @p_STATUS = 'OT11_60'    
  set @p_STATUS = 'OT11_61' --odblokowanie dokumentu (procedura zakłada nowe pozycje do integracji)    
     
	 select @v_IF_STATUS = case @p_STATUS     
		   when 'OT11_10' then 0    
		   when 'OT11_61' then 0    
		   when 'OT11_20' then 1    
		   else @p_IF_STATUS    
		  end    

     
 --rzutowanie zmiennych z SAP (POSKI jest polem jedynie do wyświetlania (zadanie inwestycyjne to wyjątek, w HERST idzie text)    
 --select @p_SAPUSER = @p_IMIE_NAZWISKO     
 select @v_PSPID = PSP_ROWID, @v_POSNR = PSP_SAP_PSPNR from [dbo].[PSP] (nolock) where PSP_CODE = @p_POSNR_POSKI -- pole przekazywane do SAP - element PSP    
 select @v_ITSID = ITS_ROWID, @v_SERNR = ITS_SAP_POSKI from [dbo].[INVTSK] (nolock) where ITS_CODE = @p_SERNR_POSKI --pole przekazywane do SAP - Zadanie inw    
 select @v_ANLKL =  CCF_SAP_ANLKL from [dbo].[COSTCLASSIFICATION] (nolock) where CCF_CODE = @p_ANLKL_POSKI    
 select @v_ANLN1 = AST_SAP_ANLN1 from [dbo].[ASSET] where AST_CODE = @p_ANLN1_POSKI    
 select @v_ANLN1_INW = AST_SAP_ANLN1 from [dbo].[ASSET] (nolock) where AST_CODE = @p_ANLN1_INW_POSKI     
 select @v_GDLGRP = KL5_SAP_GDLGRP, @v_KL5ID = KL5_ROWID from [dbo].[KLASYFIKATOR5] (nolock) where KL5_CODE = @p_GDLGRP_POSKI    
 select @v_HERST = VEN_DESC from [dbo].[VENDOR] (nolock) where VEN_CODE = @p_HERST_POSKI    
 select @v_KOSTL = CCD_SAP_KOSTL from [dbo].[COSTCODE] (nolock) where CCD_CODE = @p_KOSTL_POSKI    
 select @v_OBJID = OBJ_ROWID from [dbo].[OBJ] (nolock) where OBJ_CODE = @p_ZMT_OBJ_CODE     
 select @v_MUZYTK = case when STN_TYPE = 'SERWIS' then 'Serwis' else STN_DESC end from [dbo].[STATION] (nolock) where STN_ROWID = @p_MUZYTKID --@p_MUZYTK nieużywane, pobierane z DDLa    
    
 select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID    
 select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS 
 select @v_PARENT_ID = OBJ_ROWID from dbo.OBJ where OBJ_CODE = @p_ZMT_OBJ_CODE
     
 if @p_CZY_SKL_POZW = 0    
 begin    
  set @p_CZY_POZWOL = 0    
 end    
     
 if @p_CZY_POZWOL = 0    
 begin    
  set @p_CZY_PLAN_POZW = 0    
  set @p_CZY_WYD_POZW = 0    
 end    
     
 if @p_CZY_PLAN_POZW = 0    
 begin    
  set @p_ZZ_PLAN_DATA_ZGL = null    
 end    
 else if @p_CZY_PLAN_POZW = 1    
 begin    
  set @p_ZZ_PLAN_DAT_DEC = null    
 end    
     
 if @p_CZY_WYD_POZW = 0    
 begin    
  set @p_ZZ_DATA_ZGL = null    
  set @p_ZZ_DATA_UPRA_ZGL = null    
 end    
 else if @p_CZY_WYD_POZW = 1    
 begin    
  set @p_ZZ_DATA_WYD_DEC = null    
  set @p_ZZ_DATA_UPRA_DEC = null    
 end    
     
 if @p_TYP_SKLADNIKA <> 2    
 begin    
  set @p_CZY_BEZ_ZM = 0    
 end    
     
 if @p_CZY_ROZ_OKR is null    
 begin    
  set @p_CZY_ROZ_OKR = 0    
 end    
    
 if isnull(@p_OBJKEYS,'') <> ''    
 begin    
  select top 1 @p_INOID = INO_ROWID    
  from VS_Split3(@p_OBJKEYS, ';')    
  join dbo.INVTSK_NEW_OBJ on INO_ID = String    
 end    
     
 set @v_date = getdate()    
 select @p_ROK_DOST = YEAR(@p_DATA_DOST), @p_MIES_DOST = MONTH(@p_DATA_DOST)    
     
 --OBSŁUGA BŁĘDÓW TECHNICZNYCH    
 -- czy klucze niepuste    
 if @p_ID is null or @p_CODE is NULL OR @p_ORG IS NULL -- ## dopisac klucze    
 begin    
  select @v_errorcode = 'SYS_003'    
  goto errorlabel    
 end    
       
 -- czy klucze niepuste    
 if @p_PODZ_USL_P+@p_PODZ_USL_S+@p_PODZ_USL_B+@p_PODZ_USL_C+@p_PODZ_USL_U+@p_PODZ_USL_H <> 100    
 begin    
  select @v_errorcode = 'OT_INVALID_PODZ'    
  goto errorlabel    
 end    
    
 --OBSŁUGA BŁĘDÓW słownikowych    
 if not exists (select 1 from dbo.KLASYFIKATOR5 (nolock) where KL5_CODE = @p_GDLGRP_POSKI)  
 begin    
  select @v_errorcode = 'OT11_001' -- Wprowadzono niewłaściwego użytkownika    
  goto errorlabel  
 end    
      
 if not exists (select 1 from dbo.COSTCODE (nolock) where CCD_CODE = @p_KOSTL_POSKI)  
 begin    
  select @v_errorcode = 'OT11_002' -- Wprowadzono niewłaściwy numer MPK    
  goto errorlabel  
 end    
       
 set @v_KOSTL_POSKI = @p_KOSTL_POSKI + '%'    
 if @p_GDLGRP_POSKI not in (select KL5_CODE from KLASYFIKATOR5 where KL5_CODE like @v_KOSTL_POSKI)    
 begin    
  select @v_errorcode = 'OT11_003' -- czy użytkownik zgadza sie z mpk    
  goto errorlabel    
 end    
      
 if not exists (select 1 from STATION (nolock) where STN_KL5ID = @v_KL5ID and STN_ROWID = @p_MUZYTKID)    
 begin    
  select @v_errorcode = 'OT11_005' -- Wybrana stacja paliw (miejsce użytkowania) nie jest powiązana z klasyfikatorem 5 (użytkownikiem)    
  goto errorlabel    
 end    
       
 if ((@p_INVNR_NAZWA is null or @p_INVNR_NAZWA = '') and @v_IF_STATUS = 1)    
 begin    
  select @v_errorcode = 'OT11_006' -- Pusta nazwa składnika - nie można wysłać takiego dok. do SAP    
  goto errorlabel    
 end    
       
 if ((@p_ANLKL_POSKI is null or @p_ANLKL_POSKI = '') and @v_IF_STATUS = 1)    
 begin    
  select @v_errorcode = 'OT11_007' -- Symbol KŚT nie może być pusty    
  goto errorlabel    
 end    
       
 if @p_TYP_SKLADNIKA = '2' and @p_CZY_BEZ_ZM = '0' and @p_CZY_ROZ_OKR = '0'    
 begin    
  print @p_CZY_BEZ_ZM    
  print @p_CZY_ROZ_OKR    
  select @v_errorcode = 'OT11_008' -- Jeżeli 32b jest NIE 32c nie może być NIE    
  goto errorlabel    
 end    
       
 if @p_TYP_SKLADNIKA = '2' and @p_CZY_BEZ_ZM = '1' and @p_CZY_ROZ_OKR = '1'    
 begin    
  print @p_CZY_BEZ_ZM    
  print @p_CZY_ROZ_OKR    
  select @v_errorcode = 'OT11_010' -- Jeżeli 32b jest NIE 32c nie może być NIE    
  goto errorlabel    
 end    
       
 /*if len(@p_CHAR) > 120    
 begin    
  select @v_errorcode = 'OT11_009' -- Ilość znaków w polu "Charakterystyka opisowa składnika" nie może być większa niż 120    
  goto errorlabel    
 end  */  

	if ascii(right(@p_CHAR, 1)) = 10
	begin
		set @p_CHAR = left(@p_CHAR, len(@p_CHAR) - 1)
	end
    
 if not exists (select * from dbo.OBJSTATION (nolock) where OSA_OBJID = @v_OBJID) and @v_OBJID is not null and isnull(@p_OBJKEYS ,'') <> ''    
	 begin
	 --	RaisError (N'KOMUNIKAT BŁĘDU TESTOWY',16,1) 
	  insert into dbo.OBJSTATION (OSA_OBJID, OSA_STNID, OSA_KL5ID, OSA_CREDATE, OSA_CREUSER)    
	  select @v_OBJID, @p_MUZYTKID, @v_KL5ID, GETDATE(), @p_UserID    
	 end    
 else     
	 begin    
	  update dbo.OBJSTATION    
	  set OSA_STNID = @p_MUZYTKID    
	  where OSA_OBJID = @v_OBJID    
	 end    
     
 --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++         
 --+++++++++++++++++++++++++++++++++++++++++INSERT+++++++++++++++++++++++++++++++++++++++++++    
 --++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
 if not exists (select * from dbo.ZWFOT (nolock) where OT_ID = @p_ID)    
 begin    
       
  --//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
  --Nagłówek (jeden dla wszystkich dokumentów do integracji)    
  --//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
  BEGIN TRY    
 --	RaisError (N'KOMUNIKAT BŁĘDU TESTOWY',16,1)
	   insert into dbo.ZWFOT      
	   (     
	   OT_STATUS, OT_RSTATUS, OT_ID, OT_ORG, OT_CODE, OT_TYPE, OT_CREDATE, OT_CREUSER, OT_ITSID, OT_PSPID, OT_INOID    
	   )    
	   select     
	   @p_STATUS, @v_RSTATUS, @p_ID, @p_ORG, LEFT(NEWID(),5), 'SAPO_ZWFOT11', GETDATE(), @p_UserID, @v_ITSID, @v_PSPID, @p_INOID    
    
	   select @v_OTID = IDENT_CURRENT('ZWFOT')    
    
   --aktualizuje OBJ_OTID składnika głównego    
   if isnull(@p_OBJKEYS,'') <> ''    
	   begin    
			declare @v_PARENTID int    
  
			if @p_TYP_SKLADNIKA = '2'  
			begin  
			 select @v_PARENTID = OBJ_ROWID from dbo.OBJ where OBJ_CODE = @p_ZMT_OBJ_CODE and OBJ_PARENTID = OBJ_ROWID    
    
			 if @v_PARENTID is null and dbo.GetSTNTYPE(@p_MUZYTKID) <> 'SERWIS'  
				 begin    
					  set @v_errorcode = ''    
					  set @v_syserrorcode = 'Brak składnika nadrzędnego'    
					  goto errorlabel    
				 end    
			end  
			else  
			begin  
				 if exists (select 1 from dbo.OBJ join dbo.OBJSTATION on OSA_OBJID = OBJ_ROWID where OSA_STNID = @p_MUZYTKID and OBJ_STSID = 23)  
					 begin   
						  set @v_errorcode = ''    
						  set @v_syserrorcode = 'System kasowo-zarządzający już istnieje na stacji. Należy wybrać typ modyfikacja.'    
						  goto errorlabel    
					 end    
			 --	RaisError (N'KOMUNIKAT BŁĘDU TESTOWY',16,1)
 				 exec dbo.GenStsObj 
					 @p_STSID = 23
					,@p_PSPID = @v_PSPID
					,@p_ANOID = null
					,@p_PARENTID = NULL
					,@p_STNID = @p_MUZYTKID
					,@p_UserID = @p_UserID
					,@p_OBJID = @v_PARENTID output
					,@p_ADD_PARAMS = null
					,@p_apperrortext = @p_apperrortext output
			 
					select @p_ZMT_OBJ_CODE = OBJ_CODE from dbo.OBJ where OBJ_ROWID = @v_PARENTID  
			end 
		 --	RaisError (N'KOMUNIKAT BŁĘDU TESTOWY',16,1)
			update OBJ   
			set OBJ_OTID = @v_OTID  
			, OBJ_PARENTID = isnull(@v_PARENTID, OBJ_PARENTID)  
			, OBJ_PSPID = @v_PSPID   
			where OBJ_ROWID   
			in (select String from dbo.VS_Split3(@p_OBJKEYS, ';')   
			where ind%3 = 1 and String <> '' )
			/*dodane na potrzeby testów 950*/

			
			  
      
			insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OBJID, OTO_CREUSER, OTO_CREDATE)    
			select @v_OTID, String, @p_UserID, getdate()    
			from dbo.VS_Split3(@p_OBJKEYS, ';') where ind%3 = 1 and String <> ''   

  
			--/*Aktualizacjia pola "Data gwarancji"*/  
			--exec [dbo].[OT_LN_WARRANTY] @v_OTID, @p_OT11_RECEIVE_DATE,@p_OT11_INSTALL_DATE,@p_OT11_INVOICE_DATE, @p_UDF03  
			--/***********************************/	
			----	RaisError (N'KOMUNIKAT BŁĘDU TESTOWY',16,1)
  
			update dbo.INVTSK_NEW_OBJ set    
			 INO_MULTI = 1    
			where INO_ROWID in 
			(select OBJ_INOID from dbo.OBJ 
			where OBJ_ROWID in (select String from dbo.VS_Split3(@p_OBJKEYS, ';') 
			where ind%3 = 1 and String <> '' ))    
	   end  
   else    
	   begin    


			update OBJ 
			set OBJ_OTID = @v_OTID
			, OBJ_PSPID = @v_PSPID 
			where OBJ_ROWID = @v_OBJID

			insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OBJID, OTO_CREUSER, OTO_CREDATE)    
			values(@v_OTID, @v_OBJID, @p_UserID, getdate())    

			/*Jeżeli istnieją powiązane pozycje z tym składnikiem */
			if exists ((select * from dbo.OBJ 
								left join dbo.ZWFOTOBJ on OTO_OBJID = OBJ_ROWID
								join dbo.INVTSK_NEW_OBJ on obj_INOID = INO_ROWID
								where OBJ_PARENTID = @v_PARENT_ID and OTO_OTID is null 
								and OBJ_OTID is null
								and obj_rowid <> OBJ_PARENTID))

								begin 
	
									update OBJ 
									set OBJ_OTID = @v_OTID
									, OBJ_PSPID = @v_PSPID 
									where OBJ_ROWID in (select OBJ_ROWID from dbo.OBJ 
														left join dbo.ZWFOTOBJ on OTO_OBJID = OBJ_ROWID
														--join dbo.INVTSK_NEW_OBJ on obj_INOID = INO_ROWID
														where OBJ_PARENTID = @v_PARENT_ID and OTO_OTID is null 
														and OBJ_OTID is null
														and obj_rowid <> OBJ_PARENTID)


									insert into dbo.ZWFOTOBJ(OTO_OTID, OTO_OBJID, OTO_CREUSER, OTO_CREDATE)    
									select @v_OTID, OBJ_ROWID, @p_UserID, getdate()
									from dbo.OBJ 
									--left join dbo.ZWFOTOBJ on OTO_OBJID = OBJ_ROWID
									left join dbo.INVTSK_NEW_OBJ on OBJ_INOID = INO_ROWID
									where OBJ_PARENTID = @v_PARENTID and OBJ_ROWID <> OBJ_PARENTID
									and not exists (select * from ZWFOTOBJ where OTO_OBJID = OBJ_ROWID) 

								end

	   end    
       
   if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')         
	   begin        
			exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = '-', @p_UserID = @p_UserID        
	   end      
         
--	RaisError (N'KOMUNIKAT BŁĘDU TESTOWY',16,1)
  END TRY    
  BEGIN CATCH    
   select @v_syserrorcode = error_message()    
   select @v_errorcode = 'OT11_ERRINS' -- blad wstawienia    
   goto errorlabel    
  END CATCH;    
      
  --Nagłówek dla SAP (Każdy wysłany dokuemnt to jeden wpis)    
  BEGIN TRY    
	  --	RaisError (N'KOMUNIKAT BŁĘDU TESTOWY',16,1)
	   --status integracji (inicjowanie) IF_STATUS    
	   --0 – nieaktywny (czyli pozycja czeka)    
	   --1 – do wysłania (oczekuje na PI)    
	   --2 – wysłane (procesowane po stronie PI)    
	   --3 – odpowiedź bez błędu    
	   --4 - odrzucony (archiwum)    
	   --9 – odpowiedź z błędem    
	   insert into dbo.SAPO_ZWFOT11    
	   (      
	   OT11_KROK,    
	   OT11_BUKRS,    
	   OT11_IMIE_NAZWISKO,    
	   OT11_TYP_SKLADNIKA,    
	   OT11_CZY_BUD,    
	   OT11_SERNR_POSKI,    
	   OT11_SERNR,    
	   OT11_POSNR_POSKI,    
	   OT11_POSNR,    
	   OT11_ANLKL_POSKI,    
	   OT11_ANLKL,    
	   OT11_ANLN1_POSKI,    
	   OT11_ANLN1,    
	   OT11_ANLN1_INW_POSKI,    
	   OT11_ANLN1_INW,    
	   OT11_GDLGRP_POSKI,    
	   OT11_GDLGRP,    
	   OT11_HERST_POSKI,    
	   OT11_HERST,    
	   OT11_KOSTL_POSKI,    
	   OT11_KOSTL,    
	   OT11_INVNR_NAZWA,    
	   OT11_CZY_FUND,    
	   OT11_CZY_SKL_POZW,    
	   OT11_CZY_NIEMAT,    
	   OT11_LAND1,    
	   OT11_MUZYTKID,    
	   OT11_MUZYTK,    
	   OT11_NAZWA_DOK,    
	   OT11_NUMER_DOK,    
	   OT11_DATA_DOK,    
	   OT11_WART_NAB_PLN,    
	   OT11_PRZEW_OKRES,    
	   OT11_WOJEWODZTWO,    
	   OT11_BRANZA,    
	   OT11_CZY_BUDOWLA,    
	   OT11_IF_STATUS,    
	   OT11_IF_SENTDATE,    
	   OT11_IF_EQUNR,    
	   OT11_ZMT_ROWID,    
	   OT11_SAPUSER,    
	   OT11_MIES_DOST,    
	   OT11_ROK_DOST,    
	   ZMT_OBJ_CODE,    
	   OT11_PODZ_USL_P,    
	   OT11_PODZ_USL_S,    
	   OT11_PODZ_USL_B,    
	   OT11_PODZ_USL_C,    
	   OT11_PODZ_USL_U,    
	   OT11_PODZ_USL_H,    
	   OT11_CHAR,    
	   OT11_CZY_BEZ_ZM,    
	   OT11_CZY_PLAN_POZW,    
	   OT11_CZY_POZWOL,    
	   OT11_CZY_ROZ_OKR,    
	   OT11_CZY_WYD_POZW,    
	   OT11_WART_FUND,    
	   OT11_ZZ_DATA_UPRA_DEC,    
	   OT11_ZZ_DATA_UPRA_ZGL,    
	   OT11_ZZ_DATA_WYD_DEC,    
	   OT11_ZZ_DATA_ZGL,    
	   OT11_ZZ_PLAN_DAT_DEC,    
	   OT11_ZZ_PLAN_DATA_ZGL,  
	   OT11_UDF01,  
	   OT11_UDF02,  
	   OT11_UDF03,  
	   --OT11_RECEIVE_DATE,  
	   --OT11_INSTALL_DATE,  
	   --OT11_INVOICE_DATE,  
	   OT11_AKT_OKR_AMORT,
	   OT11_NETVALUE,
	   OT11_ACTVALUEDATE     
	   )       
	   values    
	   (      
	   @p_KROK,    
	   @p_BUKRS,    
	   @p_IMIE_NAZWISKO,    
	   @p_TYP_SKLADNIKA,    
	   @p_CZY_BUD,    
	   @p_SERNR_POSKI,    
	   @v_SERNR,    
	   @p_POSNR_POSKI,    
	   @v_POSNR,    
	   @p_ANLKL_POSKI,    
	   @v_ANLKL,    
	   @p_ANLN1_POSKI,    
	   @v_ANLN1,    
	   @p_ANLN1_INW_POSKI,    
	   @v_ANLN1_INW,    
	   @p_GDLGRP_POSKI,    
	   @v_GDLGRP,    
	   @p_HERST_POSKI,    
	   @v_HERST,    
	   @p_KOSTL_POSKI,    
	   @v_KOSTL,    
	   @p_INVNR_NAZWA,    
	   @p_CZY_FUND,    
	   @p_CZY_SKL_POZW,    
	   @p_CZY_NIEMAT,    
	   @p_LAND1,    
	   @p_MUZYTKID,    
	   @v_MUZYTK,    
	   @p_NAZWA_DOK,    
	   @p_NUMER_DOK,    
	   @p_DATA_DOK,    
	   @p_WART_NAB_PLN,    
	   @p_PRZEW_OKRES,    
	   @p_WOJEWODZTWO,    
	   @p_BRANZA,    
	   @p_CZY_BUDOWLA,    
	   0,    
	   NULL,    
	   NULL,    
	   @v_OTID,    
	   @p_SAPUSER,    
	   @p_MIES_DOST,    
	   @p_ROK_DOST,    
	   @p_ZMT_OBJ_CODE,    
	   @p_PODZ_USL_P,    
	   @p_PODZ_USL_S,    
	   @p_PODZ_USL_B,    
	   @p_PODZ_USL_C,    
	   @p_PODZ_USL_U,    
	   @p_PODZ_USL_H,    
	   @p_CHAR,    
	   @p_CZY_BEZ_ZM,    
	   @p_CZY_PLAN_POZW,    
	   @p_CZY_POZWOL,    
	   @p_CZY_ROZ_OKR,    
	   @p_CZY_WYD_POZW,    
	   @p_WART_FUND,    
	   @p_ZZ_DATA_UPRA_DEC,    
	   @p_ZZ_DATA_UPRA_ZGL,    
	   @p_ZZ_DATA_WYD_DEC,    
	   @p_ZZ_DATA_ZGL,    
	   @p_ZZ_PLAN_DAT_DEC,    
	   @p_ZZ_PLAN_DATA_ZGL,  
	   @p_UDF01,  
	   @p_UDF02,  
	   @p_UDF03,  
	   --@p_OT11_RECEIVE_DATE,  
	   --@p_OT11_INSTALL_DATE,  
	   --@p_OT11_INVOICE_DATE,
	   @p_OT11_AKT_OKR_AMORT,    
	   @p_NETVALUE,
	   @p_ACTVALUEDATE
	   )    
       
	  select @v_OT11ID = IDENT_CURRENT('SAPO_ZWFOT11')    
       
  END TRY    
  BEGIN CATCH    
	   select @v_syserrorcode = error_message()    
	   select @v_errorcode = 'OT11_ERRINS' -- blad wstawienia    
	   goto errorlabel    
  END CATCH;    
    
 end    
 else    
 begin    
	 if not exists(select * from dbo.ZWFOT (nolock) where OT_ID = @p_ID and ISNULL(OT_STATUS,0) = ISNULL(@p_STATUS_old,0))    
		  begin    
			  --RaisError (N'KOMUNIKAT BŁĘDU TESTOWY',16,1)
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
   --nagłówek    
   --	RaisError (N'KOMUNIKAT BŁĘDU TESTOWY',16,1)
   update dbo.ZWFOT    
   set     
   OT_STATUS = @P_STATUS,     
   OT_RSTATUS = @v_RSTATUS,     
   --OT_ORG = @P_ORG,     
   OT_UPDDATE = getdate(),     
   OT_UPDUSER = @p_UserID    
   --OT_ITSID = @v_ITSID,     
   --OT_PSPID = @v_PSPID,    
   --OT_INOID = @p_INOID    
   where OT_ID = @P_ID    
        
   --update OBJ set OBJ_OTID = @p_ZMT_ROWID where OBJ_ROWID = @v_OBJID    
       
   if isnull(@p_STATUS,'') <> isnull(@p_STATUS_old,'')         
   begin   
   --	RaisError (N'KOMUNIKAT BŁĘDU TESTOWY',16,1)       
    exec dbo.STAHIST_Add_Proc @p_Pref = @v_Pref, @p_ID = @p_ID, @p_STATUS = @p_STATUS, @p_STATUS_old = '-', @p_UserID = @p_UserID        
   end         
      
   --w takim przypadku wysyła nowy dokument (wraca ze statusu OT11_60 - Anulowany, z SAPa dostał status 9)    
   if  @p_STATUS_old = 'OT11_60' and @p_STATUS_old <> @p_STATUS and @p_IF_STATUS in (3,9)    
	   begin    
	   --	RaisError (N'KOMUNIKAT BŁĘDU TESTOWY',16,1)
			insert into dbo.SAPO_ZWFOT11    
			(      
			OT11_KROK, OT11_BUKRS, OT11_IMIE_NAZWISKO, OT11_TYP_SKLADNIKA, OT11_CZY_BUD,     
			OT11_SERNR_POSKI, OT11_SERNR,     
			OT11_POSNR_POSKI, OT11_POSNR,    
			OT11_ANLKL_POSKI, OT11_ANLKL,    
			OT11_ANLN1_POSKI, OT11_ANLN1,    
			OT11_ANLN1_INW_POSKI, OT11_ANLN1_INW,    
			OT11_GDLGRP_POSKI, OT11_GDLGRP,    
			OT11_HERST_POSKI, OT11_HERST,    
			OT11_KOSTL_POSKI, OT11_KOSTL,    
			OT11_INVNR_NAZWA, OT11_CZY_FUND, OT11_CZY_SKL_POZW, OT11_CZY_NIEMAT, OT11_LAND1, OT11_MUZYTKID, OT11_MUZYTK, OT11_NAZWA_DOK, OT11_NUMER_DOK, OT11_DATA_DOK, OT11_WART_NAB_PLN, OT11_PRZEW_OKRES, OT11_WOJEWODZTWO, OT11_BRANZA, OT11_CZY_BUDOWLA  
			, OT11_IF_STATUS, OT11_IF_SENTDATE, OT11_IF_EQUNR, OT11_ZMT_ROWID, OT11_SAPUSER, OT11_MIES_DOST, OT11_ROK_DOST, ZMT_OBJ_CODE    
			, OT11_PODZ_USL_P, OT11_PODZ_USL_S, OT11_PODZ_USL_B, OT11_PODZ_USL_C, OT11_PODZ_USL_U, OT11_PODZ_USL_H, OT11_CHAR, OT11_CZY_BEZ_ZM, OT11_CZY_ROZ_OKR, OT11_UDF01, OT11_UDF02,  
			OT11_UDF03,  
			--OT11_RECEIVE_DATE,  
			--OT11_INSTALL_DATE,  
			--OT11_INVOICE_DATE,
			OT11_AKT_OKR_AMORT, OT11_NETVALUE, OT11_ACTVALUEDATE 
			)          
			select     
			@p_KROK, @p_BUKRS, @p_IMIE_NAZWISKO, @p_TYP_SKLADNIKA, @p_CZY_BUD,     
			@p_SERNR_POSKI, @v_SERNR,    
			@p_POSNR_POSKI, @v_POSNR,    
			@p_ANLKL_POSKI, @v_ANLKL,    
			@p_ANLN1_POSKI, @v_ANLN1,    
			@p_ANLN1_INW_POSKI, @v_ANLN1_INW,    
			@p_GDLGRP_POSKI, @v_GDLGRP,    
			@p_HERST_POSKI, @v_HERST,    
			@p_KOSTL_POSKI, @v_KOSTL,    
			@p_INVNR_NAZWA, @p_CZY_FUND, @p_CZY_SKL_POZW, @p_CZY_NIEMAT, @p_LAND1, @p_MUZYTKID, @v_MUZYTK, @p_NAZWA_DOK, @p_NUMER_DOK, @p_DATA_DOK, @p_WART_NAB_PLN, @p_PRZEW_OKRES, @p_WOJEWODZTWO, @p_BRANZA, @p_CZY_BUDOWLA  
			, @v_IF_STATUS, NULL, NULL, @p_ZMT_ROWID, @p_SAPUSER, @p_MIES_DOST, @p_ROK_DOST, @p_ZMT_OBJ_CODE     
			, @p_PODZ_USL_P, @p_PODZ_USL_S, @p_PODZ_USL_B, @p_PODZ_USL_C, @p_PODZ_USL_U, @p_PODZ_USL_H, @p_CHAR, @p_CZY_BEZ_ZM, @p_CZY_ROZ_OKR, @p_UDF01, @p_UDF02,  
			@p_UDF03,  
			--@p_OT11_RECEIVE_DATE,  
			--@p_OT11_INSTALL_DATE,  
			--@p_OT11_INVOICE_DATE,
			@p_OT11_AKT_OKR_AMORT, @p_NETVALUE, @p_ACTVALUEDATE
         
			select @v_OT11ID = IDENT_CURRENT('SAPO_ZWFOT11')    

			--	RaisError (N'KOMUNIKAT BŁĘDU TESTOWY',16,1)
			--ustawienie statusu 4 historia    
			update dbo.SAPO_ZWFOT11 SET    
			 OT11_IF_STATUS = 4  --archiwum    
			where     
			OT11_ZMT_ROWID = @p_ZMT_ROWID     
			and OT11_IF_STATUS in (3,9)    
     
		 end    
   --nagłówek integracji (aktualizacja dla nagłówka integracji)    
	   else 
			if (@p_STATUS_old <> 'OT11_61' and @p_STATUS in ('OT11_10','OT11_20'))    
			or (@p_STATUS_old = 'OT11_61' and @p_STATUS in ('OT11_20','OT11_61'))    
   begin    
	   --	RaisError (N'KOMUNIKAT BŁĘDU TESTOWY',16,1)
		UPDATE dbo.SAPO_ZWFOT11 SET    
		 OT11_KROK = @p_KROK, OT11_BUKRS = @p_BUKRS, OT11_IMIE_NAZWISKO = @p_IMIE_NAZWISKO,     
		 OT11_TYP_SKLADNIKA = @p_TYP_SKLADNIKA, OT11_CZY_BUD = @p_CZY_BUD,    
		 OT11_SERNR_POSKI = @p_SERNR_POSKI, OT11_SERNR = @v_SERNR,     
		 OT11_POSNR_POSKI = @p_POSNR_POSKI, OT11_POSNR = @v_POSNR,    
		 OT11_ANLKL_POSKI = @p_ANLKL_POSKI, OT11_ANLKL = @v_ANLKL,    
		 OT11_ANLN1_POSKI = @p_ANLN1_POSKI, OT11_ANLN1 = @v_ANLN1,    
		 OT11_ANLN1_INW_POSKI = @p_ANLN1_INW_POSKI, OT11_ANLN1_INW = @v_ANLN1_INW,    
		 OT11_GDLGRP_POSKI = @p_GDLGRP_POSKI, OT11_GDLGRP = @v_GDLGRP,    
		 OT11_HERST_POSKI = @p_HERST_POSKI, OT11_HERST = @v_HERST,    
		 OT11_KOSTL_POSKI = @p_KOSTL_POSKI, OT11_KOSTL = @v_KOSTL,     
		 OT11_INVNR_NAZWA = @p_INVNR_NAZWA, OT11_CZY_FUND = @p_CZY_FUND,     
		 OT11_CZY_SKL_POZW = @p_CZY_SKL_POZW, OT11_CZY_NIEMAT = @p_CZY_NIEMAT,     
		 OT11_LAND1 = @p_LAND1, OT11_MUZYTKID = @p_MUZYTKID,     
		 OT11_MUZYTK = @v_MUZYTK, OT11_NAZWA_DOK = @p_NAZWA_DOK,     
		 OT11_NUMER_DOK = @p_NUMER_DOK, OT11_DATA_DOK = @p_DATA_DOK,     
		 OT11_WART_NAB_PLN = @p_WART_NAB_PLN, OT11_PRZEW_OKRES = @p_PRZEW_OKRES,     
		 OT11_WOJEWODZTWO = @p_WOJEWODZTWO, OT11_BRANZA = @p_BRANZA,     
		 OT11_CZY_BUDOWLA = @p_CZY_BUDOWLA, OT11_IF_STATUS = @v_IF_STATUS,     
		 OT11_IF_SENTDATE = @p_IF_SENTDATE, OT11_IF_EQUNR = @p_IF_EQUNR,     
		 OT11_SAPUSER = @p_SAPUSER, OT11_MIES_DOST = @p_MIES_DOST,     
		 OT11_ROK_DOST = @p_ROK_DOST, ZMT_OBJ_CODE = @p_ZMT_OBJ_CODE,    
		 OT11_PODZ_USL_P = @p_PODZ_USL_P, OT11_PODZ_USL_S = @p_PODZ_USL_S,     
		 OT11_PODZ_USL_B = @p_PODZ_USL_B, OT11_PODZ_USL_C = @p_PODZ_USL_C,     
		 OT11_PODZ_USL_U = @p_PODZ_USL_U, OT11_PODZ_USL_H = @p_PODZ_USL_H,    
		 OT11_CHAR = @p_CHAR, OT11_CZY_BEZ_ZM = @p_CZY_BEZ_ZM,    
		 OT11_CZY_ROZ_OKR = @p_CZY_ROZ_OKR ,  
		 OT11_UDF01 = @p_UDF01, OT11_UDF02 = @p_UDF02,  
		 OT11_UDF03 = @p_UDF03,  
		 --OT11_RECEIVE_DATE = @p_OT11_RECEIVE_DATE,  
		 --OT11_INSTALL_DATE = @p_OT11_INSTALL_DATE,  
		 --OT11_INVOICE_DATE = @p_OT11_INVOICE_DATE,
		 OT11_AKT_OKR_AMORT = @p_OT11_AKT_OKR_AMORT         
		where OT11_ZMT_ROWID = @p_ZMT_ROWID and OT11_IF_STATUS not in (3,4)    
       
		select @v_OT11ID = @p_ROWID    
   end    
       
   /*if @v_OT11ID is not null    
   begin    
    if not exists (select * from SAPO_ZWFOT11CHAR (nolock) where OT11CHAR_OT11ID = @v_OT11ID and isnull(OT11CHAR_TDLINE,'') = isnull(@p_CHAR,''))    
    begin    
     insert into dbo.SAPO_ZWFOT11CHAR (OT11CHAR_TDFORMAT, OT11CHAR_TDLINE, OT11CHAR_OT11ID, OT11CHAR_CREUSER)    
     select 'T', @p_CHAR, @v_OT11ID, @p_UserID    
    end    
    --else    
    --begin    
    -- update dbo.SAPO_ZWFOT11CHAR set     
    --  OT11CHAR_TDFORMAT = 'T',    
    --  OT11CHAR_TDLINE = @p_CHAR    
    -- where OT11CHAR_OT11ID = @v_OT11ID    
    --end    
   end*/   
  END TRY    
  BEGIN CATCH    
   select @v_syserrorcode = error_message()    
   select @v_errorcode = 'OT11_ERRUPD' -- blad aktualizacji     
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