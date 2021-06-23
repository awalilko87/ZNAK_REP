SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[CSVIMPORT_ASTOBJ_proc] 
(
  @p_UserID nvarchar(30), -- uzytkownik
  @p_apperrortext nvarchar(4000)='Jest OK' output
)
as
begin
  declare @v_errorcode nvarchar(50)
  declare @v_syserrorcode nvarchar(4000)
  declare @v_errortext nvarchar(4000)
  declare @v_date datetime
 
  declare @SQL nvarchar(1000) 
        , @Kolumny_OBJ nvarchar(1000) 
        , @Kolumny_CSVIMP01 nvarchar(1000) 
		, @update_kolumny NVARCHAR(1000)
  		, @update_warunek NVARCHAR(1000)
  
	--tyle różnych słowników jest na obiektach	  		
	--select			
	--OBJ_LOCID,
	--OBJ_COSTCENTERID,
	--OBJ_VENDORID,
	--OBJ_GROUPID as OBJ_GROUPCODEID,
	--OBJ_ACCOUNTID,
	--OBJ_PARTSLISTID,
	--OBJ_COSTCODEID,
	--OBJ_MRCID,
	--OBJ_MANUFACID, 
	--OBJ_ASSETID
	--from obj

  declare @pole nvarchar(30)
  declare @IdSlownikaLokalizacji int
  declare @IdSlownikaCentrum int
  declare @IdSlownikaDostawcy int
  declare @IdSlownikaGrupy int
  declare @IdSlownikaKonta int
  declare @IdSlownikaListyCzesci int
  declare @IdSlownikaKosztow int
  declare @IdSlownikaDzialu  int
  declare @IdSlownikaProducenta int
  declare @IdSlownikaSrodkaTrwalego int 
  declare @IdSlownikaSzablonu int 
  declare @IdSlownikaStacjiPaliw int 
  declare @c_SAP_PM nvarchar(255) --SAP_PM
  declare @v_PARENTID int
  declare @v_OBJID int
 
  declare @ile_bledow int
  declare @ile_rekordow int
  declare @zmt_error nvarchar(20)

  --TRUNCATE TABLE CSVIMPORT_ERRORLOG --czyszczenie loga błędów
  delete from CSVIMPORT_ERRORLOG where importuser = @p_UserID
  
  set @ile_bledow = 0
  set @ile_rekordow = (SELECT count(*) FROM CSVIMP01 where importuser = @p_UserID)

  set @Kolumny_CSVIMP01 = (SELECT
								  STUFF(
									(
									SELECT
									  ', ' + rtrim(ltrim(Pole))
									FROM CSVIMPORT
									WHERE ISNULL(Wartosc,'') <> ''  and KodZrodla = 'OBJ'
									ORDER BY Pole
									FOR XML PATH('')
									), 1, 1, ''
								  ))
  set @Kolumny_OBJ = (SELECT
								  STUFF(
									(
									SELECT
									  ', ' + Wartosc
									FROM CSVIMPORT
									WHERE ISNULL(Wartosc,'') <> ''  and KodZrodla = 'OBJ'
									ORDER BY Pole
									FOR XML PATH('')
									), 1, 1, ''
								  ))
  set @update_kolumny = (SELECT
								  STUFF(
									(
									SELECT
									  ', ' + WARTOSC + ' = ' + rtrim(ltrim(Pole))
									FROM CSVIMPORT
									WHERE ISNULL(Wartosc,'') <> '' 
										and KodZrodla = 'OBJ' 
										AND WARTOSC NOT IN ('OBJ_CODE', 'OBJ_ORG')
										and Wartosc not like '%ID'
										ORDER BY Pole
									FOR XML PATH('')
									), 1, 1, ''
								  ))						  
  set @update_warunek = (SELECT
								  STUFF(
									(
									SELECT
									  ' AND ' + WARTOSC + ' = ' + rtrim(ltrim(Pole))
									FROM CSVIMPORT
									WHERE ISNULL(Wartosc,'') <> ''
										and KodZrodla = 'OBJ' 
										AND WARTOSC IN ('OBJ_CODE', 'OBJ_ORG') 
										and Wartosc not like '%ID'
										and exists (select 1 from information_schema.columns where column_name = Wartosc and table_name = 'OBJ')									
									ORDER BY Pole
									FOR XML PATH('')
									), 1, 5 , ''
								  ))
							
		declare @rowid int 
		DECLARE cREFDEP CURSOR FOR 
		  SELECT rowid FROM CSVIMP01(nolock) WHERE importuser = @p_UserID
		  order by rowid

		OPEN cREFDEP
		FETCH NEXT FROM cREFDEP INTO @rowid
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--
			--TRY INSERT
			--
			BEGIN TRY			
				set @pole = NULL
				set @SQL = ' INSERT INTO OBJ (' + @Kolumny_OBJ + ') SELECT ' + @Kolumny_CSVIMP01 + 
					   ' FROM CSVIMP01(nolock) WHERE rowid = ' + CAST(@rowid as nvarchar)
				--słownik lokalizacji select * from LOCATION
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_LOC'
					exec @IdSlownikaLokalizacji = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_LOC', 'LOCATION', 'LOC_CODE', 'OBJ_LOCID'
					select @SQL = replace (@SQL, 'OBJ_LOC', 'OBJ_LOCID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaLokalizacji)
				--słownik centrum select * from COSTCENTER
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_COSTCENTER'
					exec @IdSlownikaCentrum = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_COSTCENTER', 'COSTCENTER', 'CCT_CODE', 'OBJ_COSTCENTERID'
					select @SQL = replace (@SQL, 'OBJ_COSTCENTER', 'OBJ_COSTCENTERID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaCentrum)
				--słownik dostawcyselect * from VENDOR
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_VENDOR'
					exec @IdSlownikaDostawcy = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_VENDOR', 'VENDOR', 'VEN_CODE', 'OBJ_VENDORID'
					select @SQL = replace (@SQL, 'OBJ_VENDOR', 'OBJ_VENDORID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaDostawcy)
				--słownik grupy  select * from OBJGROUP
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_GROUPCODE'
					exec @IdSlownikaGrupy = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_GROUPCODE', 'OBJGROUP', 'OBG_CODE', 'OBJ_GROUPID'
					select @SQL = replace (@SQL, 'OBJ_GROUPCODE', 'OBJ_GROUPID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaGrupy)
				--słownik konta select * from ACCOUNT
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_ACCOUNT'
					exec @IdSlownikaKonta = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_ACCOUNT', 'ACCOUNT', 'ACC_CODE', 'OBJ_ACCOUNTID'
					select @SQL = replace (@SQL, 'OBJ_ACCOUNT', 'OBJ_ACCOUNTID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaKonta)
				--słownik listy czesci select * from OBJPARTSLIST
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_PARTSLIST'
					exec @IdSlownikaListyCzesci = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_PARTSLIST', 'OBJPARTSLIST', 'OPL_CODE', 'OBJ_PARTSLISTID'
					select @SQL = replace (@SQL, 'OBJ_PARTSLIST', 'OBJ_PARTSLISTID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaListyCzesci)
				--słownik Kosztow select * from COSTCODE
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_COSTCODE'
					exec @IdSlownikaKosztow = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_COSTCODE', 'COSTCODE', 'CCD_CODE', 'OBJ_COSTCODEID'
					select @SQL = replace (@SQL, 'OBJ_COSTCODE', 'OBJ_COSTCODEID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaKosztow)
				--słownik Dzialu select * from MRC
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_MRC'
					exec @IdSlownikaDzialu = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_MRC', 'MRC', 'MRC_CODE', 'OBJ_MRCID'
					select @SQL = replace (@SQL, 'OBJ_MRC', 'OBJ_MRCID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaDzialu)
				--słownik producenta select * from MANUFAC
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_MANUFAC'
					exec @IdSlownikaProducenta = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_MANUFAC', 'MANUFAC', 'MFC_CODE', 'OBJ_MANUFACID'
					select @SQL = replace (@SQL, 'OBJ_MANUFAC', 'OBJ_MANUFACID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaProducenta)
				--słownik środka trwałego select * from asset
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_ASSET'
					exec @IdSlownikaSrodkaTrwalego = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_ASSET', 'ASSET', 'AST_CODE', 'OBJ_ASSETID'
					select @SQL = replace (@SQL, 'OBJ_ASSET', 'OBJ_ASSETID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaSrodkaTrwalego)
				--słownik szablonu select * from stencil
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_ASSET'
					exec @IdSlownikaSzablonu = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_ASSET', 'ASSET', 'AST_CODE', 'OBJ_ASSETID'
					select @SQL = replace (@SQL, 'OBJ_STS', 'OBJ_STSID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaSzablonu)

					--zastępuje słowniki nie dodane jako null
					--select @SQL = replace (@SQL, '-1', 'NULL')					   				
					--nieużywane
					--exec sp_executeSQL @SQL  
				
					exec @c_SAP_PM = CSVIMP_GetValue @rowid, 'ASTOBJ', 'OBJ_PM', @Value = @pole output 

					if not exists (select 1 from dbo.OBJ where OBJ_PM = @c_SAP_PM ) and @IdSlownikaSzablonu is not null and @IdSlownikaStacjiPaliw is not null
					begin
		
						--główny system Kas-ZArz	na tej stacji
						if not exists (select * from OBJ where OBJ_ROWID = OBJ_PARENTID and OBJ_STSID = 23
							and OBJ_ROWID in (select OSA_OBJID from OBJSTATION where OSA_STNID = @IdSlownikaStacjiPaliw))
						begin
							exec [dbo].[GenStsObj]
								@p_STSID = 23,
								@p_PSPID = NULL,
								@p_ANOID = NULL,
								@p_PARENTID = NULL,
								@p_STNID = @IdSlownikaStacjiPaliw,
								@p_UserID = 'SA',
								@p_OBJID = @v_PARENTID output,
								@p_apperrortext = @v_errortext output
						end
			 
						exec [dbo].[GenStsObj]
							@p_STSID = @IdSlownikaSzablonu,
							@p_PSPID = NULL,
							@p_ANOID = NULL,
							@p_PARENTID = @v_PARENTID,
							@p_STNID = @IdSlownikaStacjiPaliw,
							@p_UserID = 'SA',
							@p_OBJID = @v_OBJID output,
							@p_apperrortext = @v_errortext output
			
						--update OBJ set 
							--OBJ_VALUE = cast (@c_G as decimal(30,2)),
							--OBJ_PM = @c_SAP_PM
							--OBJ_SERIAL = @c_O
						--where 
							--OBJ_ROWID = @v_OBJID
			  
					if @v_OBJID is not null and @IdSlownikaSrodkaTrwalego is not null
						insert into OBJASSET
							(OBA_OBJID,
							OBA_ASTID,
							OBA_CREDATE,
							OBA_CREUSER)
						select 
							@v_OBJID,
							@IdSlownikaSrodkaTrwalego,
							GETDATE(),
							'SA'
				end

			END TRY
			BEGIN CATCH
				select @zmt_error = 'CSVIMP_' + cast(error_number() as nvarchar(20))
				select @v_syserrorcode = (SELECT Caption from dbo.MSGSv where ObjectID = @zmt_error)--(select CASE WHEN ISNULL(Caption,'') = '' THEN 'Błąd systemowy: '+error_message() ELSE Caption END  from dbo.MSGSv where ObjectID = @zmt_error) --error message
				SELECT @v_syserrorcode = (SELECT ISNULL(NULL,'Błąd systemowy: '+error_message()))
				if @IdSlownikaLokalizacji = 0 and charindex('OBJ_LOCID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika lokalizacji'
				if @IdSlownikaCentrum = 0 and charindex('OBJ_COSTCENTERID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika centrum kosztowego'
				if @IdSlownikaDostawcy = 0 and charindex('OBJ_VENDORID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika dostawcy'
				if @IdSlownikaGrupy = 0 and charindex('OBJ_GROUPID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika grupy'
				if @IdSlownikaKonta = 0 and charindex('OBJ_ACCOUNTID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika konta'
				if @IdSlownikaListyCzesci = 0 and charindex('OBJ_PARTSLISTID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika listy części'
				if @IdSlownikaKosztow = 0 and charindex('OBJ_COSTCODEID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika kosztów'
				if @IdSlownikaDzialu = 0 and charindex('OBJ_MRCID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika działu'
				if @IdSlownikaProducenta = 0 and charindex('OBJ_MANUFACID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika producenta'
				if @IdSlownikaSrodkaTrwalego = 0 and charindex('OBJ_ASSETID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika środka trwałego'
										
				select @v_errorcode = @zmt_error -- blad importu
				INSERT INTO dbo.CSVIMPORT_ERRORLOG   
					([ErrorCode],[ErrorText],[ErrorLP],[spid],[importuser] 
				   ,[C1] ,[C2] ,[C3] ,[C4] ,[C5] ,[C6] ,[C7] ,[C8] ,[C9] ,[C10]
				   ,[C11] ,[C12] ,[C13] ,[C14] ,[C15] ,[C16] ,[C17] ,[C18] ,[C19] ,[C20] 
				   ,[C21] ,[C22] ,[C23] ,[C24] ,[C25] ,[C26] ,[C27] ,[C28] ,[C29] ,[C30]
				   ,[C31] ,[C32] ,[C33] ,[C34] ,[C35] ,[C36] ,[C37] ,[C38] ,[C39] ,[C40]
				   ,[C41] ,[C42] ,[C43] ,[C44] ,[C45] ,[C46] ,[C47] ,[C48] ,[C49] ,[C50])
				SELECT @v_errorcode, @v_syserrorcode, @rowid,[spid],[importuser] 
				   ,[C1] ,[C2] ,[C3] ,[C4] ,[C5] ,[C6] ,[C7] ,[C8] ,[C9] ,[C10]
				   ,[C11] ,[C12] ,[C13] ,[C14] ,[C15] ,[C16] ,[C17] ,[C18] ,[C19] ,[C20] 
				   ,[C21] ,[C22] ,[C23] ,[C24] ,[C25] ,[C26] ,[C27] ,[C28] ,[C29] ,[C30]
				   ,[C31] ,[C32] ,[C33] ,[C34] ,[C35] ,[C36] ,[C37] ,[C38] ,[C39] ,[C40]
				   ,[C41] ,[C42] ,[C43] ,[C44] ,[C45] ,[C46] ,[C47] ,[C48] ,[C49] ,[C50]
				FROM CSVIMP01 where rowid = @rowid
				SET @ile_bledow = @ile_bledow + 1
			END CATCH;
			--
			--TRY UPDATE
			--
			BEGIN TRY 
				set @pole = NULL
				set @SQL = 'UPDATE OBJ SET ' + @update_kolumny + ' FROM OBJ JOIN CSVIMP01 ON ' + @update_warunek + ' AND CSVIMP01.ROWID = ' + CAST(@rowid as nvarchar)
				--słownik lokalizacji
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_LOC'
					exec @IdSlownikaLokalizacji = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_LOC', 'LOCATION', 'LOC_CODE', 'OBJ_LOCID'
					select @SQL = replace (@SQL, 'OBJ_LOC', 'OBJ_LOCID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaLokalizacji)
				--słownik centrum
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_COSTCENTER'
					exec @IdSlownikaCentrum = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_COSTCENTER', 'COSTCENTER', 'CCT_CODE', 'OBJ_COSTCENTERID'
					select @SQL = replace (@SQL, 'OBJ_COSTCENTER', 'OBJ_COSTCENTERID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaCentrum)
				--słownik dostawcy
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_VENDOR'
					exec @IdSlownikaDostawcy = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_VENDOR', 'VENDOR', 'VEN_CODE', 'OBJ_VENDORID'
					select @SQL = replace (@SQL, 'OBJ_VENDOR', 'OBJ_VENDORID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaDostawcy)
				--słownik grupy
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_GROUPCODE'
					exec @IdSlownikaGrupy = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_GROUPCODE', 'OBJGROUP', 'OBG_CODE', 'OBJ_GROUPID'
					select @SQL = replace (@SQL, 'OBJ_GROUPCODE', 'OBJ_GROUPID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaGrupy)
				--słownik konta
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_ACCOUNT'
					exec @IdSlownikaKonta = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_ACCOUNT', 'ACCOUNT', 'ACC_CODE', 'OBJ_ACCOUNTID'
					select @SQL = replace (@SQL, 'OBJ_ACCOUNT', 'OBJ_ACCOUNTID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaKonta)
				--słownik listy czesci
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_PARTSLIST'
					exec @IdSlownikaListyCzesci = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_PARTSLIST', 'OBJPARTSLIST', 'OPL_CODE', 'OBJ_PARTSLISTID'
					select @SQL = replace (@SQL, 'OBJ_PARTSLIST', 'OBJ_PARTSLISTID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaListyCzesci)
				--słownik Kosztow
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_COSTCODE'
					exec @IdSlownikaKosztow = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_COSTCODE', 'COSTCODE', 'CCD_CODE', 'OBJ_COSTCODEID'
					select @SQL = replace (@SQL, 'OBJ_COSTCODE', 'OBJ_COSTCODEID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaKosztow)
				--słownik Dzialu
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_MRC'
					exec @IdSlownikaDzialu = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_MRC', 'MRC', 'MRC_CODE', 'OBJ_MRCID'
					select @SQL = replace (@SQL, 'OBJ_MRC', 'OBJ_MRCID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaDzialu)
				--słownik producenta
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_MANUFAC'
					exec @IdSlownikaProducenta = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_MANUFAC', 'MANUFAC', 'MFC_CODE', 'OBJ_MANUFACID'
					select @SQL = replace (@SQL, 'OBJ_MANUFAC', 'OBJ_MANUFACID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaProducenta)
				--słownik środka trwałego
					select top 1  @pole = POLE FROM CSVIMPORT WHERE ISNULL(Wartosc,'') <> '' and KodZrodla = 'OBJ' and Wartosc = 'OBJ_ASSET'
					exec @IdSlownikaSrodkaTrwalego = CSVIMP_GetDictionaryID @rowid, 'OBJ', 'OBJ_ASSET', 'ASSET', 'AST_CODE', 'OBJ_ASSETID'
					select @SQL = replace (@SQL, 'OBJ_ASSET', 'OBJ_ASSETID')
					select @SQL = replace (@SQL, isnull(@pole,''), @IdSlownikaSrodkaTrwalego)
					--zastępuje słowniki nie dodane jako null
					select @SQL = replace (@SQL, '-1', 'NULL')	
				--nieużywane
				--exec sp_executeSQL @SQL   
			END TRY
			BEGIN CATCH
				select @zmt_error = 'CSVIMP_' + cast(error_number() as nvarchar(20))
				select @v_syserrorcode = (SELECT Caption from dbo.MSGSv where ObjectID = @zmt_error)--(select CASE WHEN ISNULL(Caption,'') = '' THEN 'Błąd systemowy: '+error_message() ELSE Caption END  from dbo.MSGSv where ObjectID = @zmt_error) --error message
				SELECT @v_syserrorcode = (SELECT ISNULL(@v_syserrorcode,'Błąd systemowy: '+error_message()))
				if @IdSlownikaLokalizacji = 0 and charindex('OBJ_LOCID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika lokalizacji'
				if @IdSlownikaCentrum = 0 and charindex('OBJ_COSTCENTERID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika centrum kosztowego'
				if @IdSlownikaDostawcy = 0 and charindex('OBJ_VENDORID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika dostawcy'
				if @IdSlownikaGrupy = 0 and charindex('OBJ_GROUPID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika grupy'
				if @IdSlownikaKonta = 0 and charindex('OBJ_ACCOUNTID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika konta'
				if @IdSlownikaListyCzesci = 0 and charindex('OBJ_PARTSLISTID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika listy części'
				if @IdSlownikaKosztow = 0 and charindex('OBJ_COSTCODEID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika kosztów'
				if @IdSlownikaDzialu = 0 and charindex('OBJ_MRCID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika działu'
				if @IdSlownikaProducenta = 0 and charindex('OBJ_MANUFACID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika producenta'
				if @IdSlownikaSrodkaTrwalego = 0 and charindex('OBJ_ASSETID',@SQL) > 0 set @v_syserrorcode = 'Brak słownika środka trwałego'
						
				select @v_errorcode = @zmt_error -- blad importu
				INSERT INTO dbo.CSVIMPORT_ERRORLOG   
					([ErrorCode],[ErrorText],[ErrorLP],[spid],[importuser] 
				   ,[C1] ,[C2] ,[C3] ,[C4] ,[C5] ,[C6] ,[C7] ,[C8] ,[C9] ,[C10]
				   ,[C11] ,[C12] ,[C13] ,[C14] ,[C15] ,[C16] ,[C17] ,[C18] ,[C19] ,[C20] 
				   ,[C21] ,[C22] ,[C23] ,[C24] ,[C25] ,[C26] ,[C27] ,[C28] ,[C29] ,[C30]
				   ,[C31] ,[C32] ,[C33] ,[C34] ,[C35] ,[C36] ,[C37] ,[C38] ,[C39] ,[C40]
				   ,[C41] ,[C42] ,[C43] ,[C44] ,[C45] ,[C46] ,[C47] ,[C48] ,[C49] ,[C50])
				SELECT @v_errorcode, @v_syserrorcode, @rowid,[spid],[importuser] 
				   ,[C1] ,[C2] ,[C3] ,[C4] ,[C5] ,[C6] ,[C7] ,[C8] ,[C9] ,[C10]
				   ,[C11] ,[C12] ,[C13] ,[C14] ,[C15] ,[C16] ,[C17] ,[C18] ,[C19] ,[C20] 
				   ,[C21] ,[C22] ,[C23] ,[C24] ,[C25] ,[C26] ,[C27] ,[C28] ,[C29] ,[C30]
				   ,[C31] ,[C32] ,[C33] ,[C34] ,[C35] ,[C36] ,[C37] ,[C38] ,[C39] ,[C40]
				   ,[C41] ,[C42] ,[C43] ,[C44] ,[C45] ,[C46] ,[C47] ,[C48] ,[C49] ,[C50]
				FROM CSVIMP01 where rowid = @rowid
				--SET @ile_bledow = @ile_bledow + 1
			END CATCH;
		FETCH NEXT FROM cREFDEP INTO @rowid
		END
		CLOSE cREFDEP
		DEALLOCATE cREFDEP

		UPDATE CSVIMPORT_ERRORLOG 
		SET ErrorText = 'Pozycja już istnieje w systemie. Nastąpiła aktualizacja pozycji.'
		WHERE ErrorText = 'Błąd systemowy: Violation of PRIMARY KEY constraint ''PK_OBJ''. Cannot insert duplicate key in object ''dbo.OBJ''.'
		
	IF EXISTS (SELECT(1) FROM CSVIMPORT_ERRORLOG) 
		BEGIN
		declare @tekst_bledu nvarchar(4000)
		set @tekst_bledu = 'Zaimportowano ' + CAST(@ile_rekordow-@ile_bledow as nvarchar) + ' z ' + cast(@ile_rekordow as nvarchar) + ' rekordów. Przejrzyj listę błędów.' 
		raiserror (@tekst_bledu/*'Import zakończony. Przejrzyj listę błędów.'*/, 16, 1)
		END
	 ELSE 
     	raiserror ('<font color="green">Import zakończony pomyślnie!</font>', 16, 1)
	
	--
  return 0
  errorlabel:
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
    select @p_apperrortext = @v_errortext
    return 1
end


GO