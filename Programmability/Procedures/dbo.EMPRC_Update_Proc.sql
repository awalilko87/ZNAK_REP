SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[EMPRC_Update_Proc](
@p_FormID nvarchar(50),
@p_ID nvarchar(50),
@p_ROWID int,
@p_CODE nvarchar(30),
@p_ORG nvarchar(30),
@p_DESC nvarchar(80),
@p_NOTE ntext,
@p_DATE datetime,
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
@p_ENGAGE datetime, --Data zatrudnienia -- datetime
@p_MRCCODE NVARCHAR(50),  --Wydział
@p_GROUP_CODE NVARCHAR(50),  --Wydział
@p_COSTCODEID nvarchar(30),
@p_MAGID int,
@p_PHONE nvarchar(30), --Telefon domowy 
@p_EMAIL nvarchar(80), 
@p_TRADECODE NVARCHAR(50), --Stanowisko
@p_UR int,
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
  declare @v_MultiOrg bit

  -- czy klucze niepuste
  if @p_ID is null or @p_CODE is null or @p_ORG is null -- ## dopisac klucze
  begin
    select @v_errorcode = 'SYS_003'
	goto errorlabel
  end

  select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID
  select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @p_STATUS

  set @v_date = getdate()

-- obsługa POP-upów

  declare 
	@v_MRCID int,
	@v_TRADEID int,
	@v_GROUPID int
	

  select @v_MRCID = MRC_ROWID from dbo.MRC (nolock) where MRC_CODE = @p_MRCCODE 
  if @v_MRCID is null and @p_MRCCODE is not null 
  begin   
    select @v_errorcode = 'POP_013' 
    goto errorlabel 
  end
  
  select @v_GROUPID = EMG_ROWID from dbo.EMPGROUP (nolock) where EMG_CODE = @p_GROUP_CODE 
  if @v_GROUPID is null and @p_GROUP_CODE is not null 
  begin   
    select @v_errorcode = 'POP_025' 
    goto errorlabel 
  end

  
  select @v_TRADEID = TRD_ROWID from dbo.TRADE (nolock) where TRD_CODE = @p_TRADECODE
  if  @v_TRADEID is null and @p_TRADECODE is not null 
  begin   
    select @v_errorcode = 'POP_014' 
    goto errorlabel 
  end
  
  
 --insert
	if not exists (select * from dbo.EMP (nolock) where EMP_ID = @p_ID)
	begin

		--numeracja
		--declare @v_Number nvarchar(50), @v_No int
		--exec dbo.VS_GetNumber @Type = 'RST_BUK', @Pref = 'ZP/', @Suff = '/09', @Number = @v_Number output, @No = @v_No output
		--select @v_Number, @v_No
		
	  if exists (select * from dbo.EMP (nolock) where EMP_CODE = @p_CODE)
	  begin
		select @v_errorcode = 'SYS_005' 
		goto errorlabel 
	  end

      BEGIN TRY
		insert into dbo.EMP
		(
		  EMP_CODE
		, EMP_ORG
		, EMP_DESC
		, EMP_NOTE
		, EMP_DATE
		, EMP_STATUS
		, EMP_TYPE
		, EMP_TYPE2
		, EMP_TYPE3
		, EMP_RSTATUS
		, EMP_CREUSER
		, EMP_CREDATE
		, EMP_UPDUSER
		, EMP_UPDDATE
		, EMP_NOTUSED
		, EMP_ID
		, TXT01
		, TXT02
		, TXT03
		, TXT04
		, TXT05
		, TXT06
		, TXT07
		, TXT08
		, TXT09
		, NTX01
		, NTX02
		, NTX03
		, NTX04
		, NTX05
		, COM01
		, COM02
		, DTX01
		, DTX02
		, DTX03
		, DTX04
		, DTX05
-- dalej własne pola
		, EMP_ENGAGE
		, EMP_MRCID
		, EMP_GROUPID
		, EMP_COSTCODEID
		, EMP_MAGID
		, EMP_PHONE
		, EMP_EMAIL
		, EMP_TRADEID
		, EMP_UR

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
		, @p_ENGAGE
		, @v_MRCID
		, @v_GROUPID
		, @p_COSTCODEID
		, @p_MAGID
		, @p_PHONE
		, @p_EMAIL
		, @v_TRADEID
		, @p_UR)
	  END TRY
	  BEGIN CATCH
		select @v_syserrorcode = error_message()
		select @v_errorcode = 'EMP_001' -- blad wstawienia
		goto errorlabel
	  END CATCH;
	end
    else
    begin

	  if not exists(select * from dbo.EMP (nolock) where EMP_ID = @p_ID and ISNULL(EMP_STATUS,0) = ISNULL(@p_STATUS_old,0))
	  begin
	    select @v_syserrorcode = error_message()
	    select @v_errorcode = 'SYS_002' -- blad wspoluzytkowania
	    goto errorlabel
      end   

	  if exists(select * from dbo.EMP (nolock) where EMP_ID = @p_ID AND EMP_CODE <> @p_CODE)
	  begin
	    select @v_syserrorcode = error_message()
	    select @v_errorcode = 'SYS_011' -- blad wspoluzytkowania
	    goto errorlabel
      end   

		BEGIN TRY
		  UPDATE dbo.EMP SET
			  EMP_CODE = @p_CODE
			, EMP_ORG = @p_ORG
			, EMP_DESC = @p_DESC
			, EMP_NOTE = @p_NOTE
			, EMP_DATE = @p_DATE
			, EMP_STATUS = @p_STATUS
			, EMP_TYPE = @p_TYPE
			, EMP_TYPE2 = @p_TYPE2
			, EMP_TYPE3 = @p_TYPE3
			, EMP_RSTATUS = @v_Rstatus
			, EMP_UPDDATE  =  @v_date
			, EMP_UPDUSER  =  @p_UserID
			, EMP_NOTUSED = @p_NOTUSED
			, TXT01 = @p_TXT01
			, TXT02 = @p_TXT02
			, TXT03 = @p_TXT03
			, TXT04 = @p_TXT04
			, TXT05 = @p_TXT05
			, TXT06 = @p_TXT06
			, TXT07 = @p_TXT07
			, TXT08 = @p_TXT08
			, TXT09 = @p_TXT09
			, NTX01 = @p_NTX01
			, NTX02 = @p_NTX02
			, NTX03 = @p_NTX03
			, NTX04 = @p_NTX04
			, NTX05 = @p_NTX05
			, COM01 = @p_COM01
			, COM02 = @p_COM02
			, DTX01 = @p_DTX01
			, DTX02 = @p_DTX02
			, DTX03 = @p_DTX03
			, DTX04 = @p_DTX04
			, DTX05 = @p_DTX05
-- dalej własne pola
			, EMP_ENGAGE = @p_ENGAGE
			, EMP_MRCID = @v_MRCID
			, EMP_GROUPID = @v_GROUPID
			, EMP_COSTCODEID = @p_COSTCODEID
			, EMP_MAGID = @p_MAGID
			, EMP_PHONE = @p_PHONE
			, EMP_EMAIL = @p_EMAIL
			, EMP_TRADEID = @v_TRADEID
			, EMP_UR = @p_UR

		  where EMP_ID = @p_ID

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'EMP_002' -- blad aktualizacji zgloszenia
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