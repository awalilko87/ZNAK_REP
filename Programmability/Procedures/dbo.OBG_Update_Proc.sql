SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[OBG_Update_Proc] 
(
  @p_FormID nvarchar(50),
  @p_ID nvarchar(50),
  @p_ROWID int,
  @p_CODE nvarchar(48),
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
  @p_AUTHGROUP nvarchar(100)
  
  --- tutaj ewentualnie swoje parametry/zmienne/dane


,  @p_UserID nvarchar(30) -- uzytkownik
,  @p_apperrortext nvarchar(4000) output
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
	if not exists (select * from dbo.OBJGROUP (nolock) where OBG_ID = @p_ID)
	begin

		--numeracja
		--declare @v_Number nvarchar(50), @v_No int
		--exec dbo.VS_GetNumber @Type = 'RST_BUK', @Pref = 'ZP/', @Suff = '/09', @Number = @v_Number output, @No = @v_No output
		--select @v_Number, @v_No

      BEGIN TRY
		insert into dbo.OBJGROUP
		(
		  OBG_CODE
		, OBG_ORG
		, OBG_DESC
		, OBG_NOTE
		, OBG_DATE
		, OBG_STATUS
		, OBG_TYPE
		, OBG_TYPE2
		, OBG_TYPE3
		, OBG_RSTATUS
		, OBG_CREUSER
		, OBG_CREDATE
		, OBG_UPDUSER
		, OBG_UPDDATE
		, OBG_NOTUSED
		, OBG_ID
		, OBG_TXT01
		, OBG_TXT02
		, OBG_TXT03
		, OBG_TXT04
		, OBG_TXT05
		, OBG_TXT06
		, OBG_TXT07
		, OBG_TXT08
		, OBG_TXT09
		, OBG_NTX01
		, OBG_NTX02
		, OBG_NTX03
		, OBG_NTX04
		, OBG_NTX05
		, OBG_COM01
		, OBG_COM02
		, OBG_DTX01
		, OBG_DTX02
		, OBG_DTX03
		, OBG_DTX04
		, OBG_DTX05
		, OBG_AUTHGROUP
-- dalej własne pola
        


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
		, @p_AUTHGROUP
-- dalej własne pola





		)

		set @p_ROWID = scope_identity()
	  END TRY
	  BEGIN CATCH
		select @v_syserrorcode = error_message()
		select @v_errorcode = 'OBG_001' -- blad wstawienia
		goto errorlabel
	  END CATCH;
	end
    else
    begin

	  if not exists(select * from dbo.OBJGROUP (nolock) where OBG_ID = @p_ID and ISNULL(OBG_STATUS,0) = ISNULL(@p_STATUS_old,0))
	  begin
	    select @v_syserrorcode = error_message()
	    select @v_errorcode = 'SYS_002' -- blad wspoluzytkowania
	    goto errorlabel
      end   

	  if exists(select * from dbo.OBJGROUP (nolock) where OBG_ID = @p_ID AND OBG_CODE <> @p_CODE)
	  begin
	    select @v_syserrorcode = error_message()
	    select @v_errorcode = 'SYS_011' -- blad wspoluzytkowania
	    goto errorlabel
      end   

		BEGIN TRY
		  UPDATE dbo.OBJGROUP SET
			  OBG_CODE = @p_CODE
			, OBG_ORG = @p_ORG
			, OBG_DESC = @p_DESC
			, OBG_NOTE = @p_NOTE
			, OBG_DATE = @p_DATE
			, OBG_STATUS = @p_STATUS
			, OBG_TYPE = @p_TYPE
			, OBG_TYPE2 = @p_TYPE2
			, OBG_TYPE3 = @p_TYPE3
			, OBG_RSTATUS = @v_Rstatus
			, OBG_UPDDATE  =  @v_date
			, OBG_UPDUSER  =  @p_UserID
			, OBG_NOTUSED = @p_NOTUSED
			, OBG_TXT01 = @p_TXT01
			, OBG_TXT02 = @p_TXT02
			, OBG_TXT03 = @p_TXT03
			, OBG_TXT04 = @p_TXT04
			, OBG_TXT05 = @p_TXT05
			, OBG_TXT06 = @p_TXT06
			, OBG_TXT07 = @p_TXT07
			, OBG_TXT08 = @p_TXT08
			, OBG_TXT09 = @p_TXT09
			, OBG_NTX01 = @p_NTX01
			, OBG_NTX02 = @p_NTX02
			, OBG_NTX03 = @p_NTX03
			, OBG_NTX04 = @p_NTX04
			, OBG_NTX05 = @p_NTX05
			, OBG_COM01 = @p_COM01
			, OBG_COM02 = @p_COM02
			, OBG_DTX01 = @p_DTX01
			, OBG_DTX02 = @p_DTX02
			, OBG_DTX03 = @p_DTX03
			, OBG_DTX04 = @p_DTX04
			, OBG_DTX05 = @p_DTX05
			, OBG_AUTHGROUP = @p_AUTHGROUP
-- dalej własne pola



		  where OBG_ID = @p_ID

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OBG_002' -- blad aktualizacji zgloszenia
			goto errorlabel
		END CATCH;

		delete from dbo.PRVOBJ where PVO_OBGID = @p_ROWID

		insert into dbo.PRVOBJ (PVO_GROUPID, PVO_OBGID, PVO_ID)
		select value, @p_ROWID, newid()
		from string_split(@p_AUTHGROUP, ',')

  end
  return 0
  errorlabel:
    exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
	raiserror (@v_errortext, 16, 1) 
    select @p_apperrortext = @v_errortext
    return 1
end
GO