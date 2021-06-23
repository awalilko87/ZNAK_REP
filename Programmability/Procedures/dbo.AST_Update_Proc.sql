SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[AST_Update_Proc] 
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
	@p_BUYVALUE	numeric (24,6),
	@p_TEXT1	nvarchar (4000),
	@p_TEXT2	nvarchar (4000),
	@p_TEXT3	nvarchar (4000),
	@p_PSP	nvarchar (50),
	@p_ISSIGNED	int,
	@p_SIGN_LOC	nvarchar (50),
	@p_SAP	nvarchar (50),

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
  
 


  -- czy klucze niepuste
  if @p_ID is null or @p_CODE is NULL OR @p_ORG IS NULL -- ## dopisac klucze
  begin
    select @v_errorcode = 'SYS_003'
	goto errorlabel
  end

  select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID
  select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS

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

--  declare 
--	@v_MRCID int,
--	@v_TRADEID int
--	
--
--  select @v_MRCID = ROWID from dbo.MRC (nolock) where MRC_CODE = @p_MRCCODE
--  if @v_MRCID is null and @p_MRCCODE is not null 
--  begin   
--    select @v_errorcode = 'POP_013' 
--    goto errorlabel 
--  end
--
--  
--  select @v_TRADEID = ROWID from dbo.TRADE (nolock) where TRD_CODE = @p_TRADECODE
--  if  @v_TRADEID is null and @p_TRADECODE is not null 
--  begin   
--    select @v_errorcode = 'POP_014' 
--    goto errorlabel 
--  end
  
  
 --insert
	if not exists (select * from dbo.ASSET (nolock) where AST_ID = @p_ID)
	begin

		--numeracja
		--declare @v_Number nvarchar(50), @v_No int
		--exec dbo.VS_GetNumber @Type = 'RST_BUK', @Pref = 'ZP/', @Suff = '/09', @Number = @v_Number output, @No = @v_No output
		--select @v_Number, @v_No

      BEGIN TRY
		insert into dbo.ASSET
		(
		  AST_CODE
		, AST_ORG
		, AST_DESC
		, AST_NOTE
		, AST_DATE
		, AST_STATUS
		, AST_TYPE
		, AST_TYPE2
		, AST_TYPE3
		, AST_RSTATUS
		, AST_CREUSER
		, AST_CREDATE
		, AST_UPDUSER
		, AST_UPDDATE
		, AST_NOTUSED
 
		, AST_ID
		, AST_TXT01
		, AST_TXT02
		, AST_TXT03
		, AST_TXT04
		, AST_TXT05
		, AST_TXT06
		, AST_TXT07
		, AST_TXT08
		, AST_TXT09
		, AST_NTX01
		, AST_NTX02
		, AST_NTX03
		, AST_NTX04
		, AST_NTX05
		, AST_COM01
		, AST_COM02
		, AST_DTX01
		, AST_DTX02
		, AST_DTX03
		, AST_DTX04
		, AST_DTX05
		
		-- dalej własne pola
		, AST_BUYVALUE
		, AST_TEXT1
		, AST_TEXT2
		, AST_TEXT3
		, AST_PSP
		, AST_ISSIGNED
		, AST_SIGN_LOC
		, AST_SAP

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
		, @p_BUYVALUE
		, @p_TEXT1
		, @p_TEXT2
		, @p_TEXT3
		, @p_PSP
		, @p_ISSIGNED
		, @p_SIGN_LOC
		, @p_SAP



		)
	  END TRY
	  BEGIN CATCH
		select @v_syserrorcode = error_message()
		select @v_errorcode = 'AST_001' -- blad wstawienia
		goto errorlabel
	  END CATCH;
	end
    else
    begin

	  if not exists(select * from dbo.ASSET (nolock) where AST_ID = @p_ID and ISNULL(AST_STATUS,0) = ISNULL(@p_STATUS_old,0))
	  begin
	    select @v_syserrorcode = error_message()
	    select @v_errorcode = 'SYS_002' -- blad wspoluzytkowania
	    goto errorlabel
      end   

	  if exists(select * from dbo.ASSET (nolock) where AST_ID = @p_ID AND AST_CODE <> @p_CODE)
	  begin
	    select @v_syserrorcode = error_message()
	    select @v_errorcode = 'SYS_011' -- blad wspoluzytkowania
	    goto errorlabel
      end   

		BEGIN TRY
		  UPDATE dbo.ASSET SET
			  AST_CODE = @p_CODE
			, AST_ORG = @p_ORG
			, AST_DESC = @p_DESC
			, AST_NOTE = @p_NOTE
			, AST_DATE = @p_DATE
			, AST_STATUS = @p_STATUS
			, AST_TYPE = @p_TYPE
			, AST_TYPE2 = @p_TYPE2
			, AST_TYPE3 = @p_TYPE3
			, AST_RSTATUS = @v_Rstatus
			, AST_UPDDATE  =  @v_date
			, AST_UPDUSER  =  @p_UserID
			, AST_NOTUSED = @p_NOTUSED
 
			, AST_TXT01 = @p_TXT01
			, AST_TXT02 = @p_TXT02
			, AST_TXT03 = @p_TXT03
			, AST_TXT04 = @p_TXT04
			, AST_TXT05 = @p_TXT05
			, AST_TXT06 = @p_TXT06
			, AST_TXT07 = @p_TXT07
			, AST_TXT08 = @p_TXT08
			, AST_TXT09 = @p_TXT09
			, AST_NTX01 = @p_NTX01
			, AST_NTX02 = @p_NTX02
			, AST_NTX03 = @p_NTX03
			, AST_NTX04 = @p_NTX04
			, AST_NTX05 = @p_NTX05
			, AST_COM01 = @p_COM01
			, AST_COM02 = @p_COM02
			, AST_DTX01 = @p_DTX01
			, AST_DTX02 = @p_DTX02
			, AST_DTX03 = @p_DTX03
			, AST_DTX04 = @p_DTX04
			, AST_DTX05 = @p_DTX05
			-- dalej własne pola



		  where AST_ID = @p_ID

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'AST_002' -- blad aktualizacji zgloszenia
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