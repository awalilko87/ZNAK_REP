SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[OBJRC_Update_Proc](
	@p_FormID nvarchar(50),
	@p_ID nvarchar(50),
	@p_ROWID int,
	@p_CODE nvarchar(30),
	@p_CODE_old nvarchar(30),
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
	@p_PSPID int,
	@p_SIGNED smallint,
	@p_SIGNLOC nvarchar (80),
	@p_STSID int,
	@p_PARENTID int,
	@p_LEFT int,
	@p_PM nvarchar(30),
	@p_PM_TOSEND int,  
	@p_PM_SERVICE nvarchar(30),
	@p_SERIAL nvarchar(30),
	@p_VALUE decimal(30,6),
	@p_OTID int,
	@p_INOID int,
	@p_VENDOR nvarchar(30),
    @p_UserID varchar(30),
    @p_apperrortext nvarchar(4000) output
    )
as
begin	

	declare @v_errorcode nvarchar(50)
	, @v_syserrorcode nvarchar(4000)
	, @v_errortext nvarchar(4000)
	, @v_VENDORID int
	, @v_date datetime

	set @v_date = getdate()
	
	select top 1 @v_VENDORID = VEN_ROWID from dbo.VENDOR where VEN_CODE = @p_VENDOR
	
	if @p_CODE is null -- ## dopisac klucze
	begin
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
	 
	if @p_CODE <> @p_CODE_old
	begin
		set @v_errorcode = 'SYS_011'
		goto errorlabel
	end

	if not exists (select 1 from dbo.OBJ where OBJ_ROWID = @p_ROWID)
	begin

		insert into dbo.OBJ (
			OBJ_CODE
			, OBJ_ORG
			, OBJ_DESC
			, OBJ_DATE
			, OBJ_STATUS
			, OBJ_TYPE
			, OBJ_TYPE2
			, OBJ_TYPE3
			--, OBJ_RSTATUS
			--, OBJ_CREUSER
			--, OBJ_CREDATE
			--, OBJ_UPDUSER
			--, OBJ_UPDDATE
			, OBJ_NOTUSED
			, OBJ_ID
			--, OBJ_ACCOUNTID
			--, OBJ_ASSETID
			--, OBJ_ATTACH
			--, OBJ_CAPACITY
			--, OBJ_CATALOGNO
			--, OBJ_COSTCENTERID
			, OBJ_TXT01
			, OBJ_TXT02
			, OBJ_TXT03
			, OBJ_TXT04
			, OBJ_TXT05
			, OBJ_TXT06
			, OBJ_TXT07
			, OBJ_TXT08
			, OBJ_TXT09
			--, OBJ_TXT10
			--, OBJ_TXT11
			--, OBJ_TXT12
			, OBJ_NTX01
			, OBJ_NTX02
			, OBJ_NTX03
			, OBJ_NTX04
			, OBJ_NTX05
			, OBJ_COM01
			, OBJ_COM02
			, OBJ_DTX01
			, OBJ_DTX02
			, OBJ_DTX03
			, OBJ_DTX04
			, OBJ_DTX05
			--, OBJ_GROUPID
			--, OBJ_LOCID
			--, OBJ_LOCATION
			--, OBJ_MANUFACID
			--, OBJ_PARTSLISTID
			--, OBJ_PERSON
			--, OBJ_SERIAL
			--, OBJ_VALUE 
			--, OBJ_YEAR
			--, OBJ_MRCID
			--, OBJ_PREFERED
			--, OBJ_COMPLEX
			--, OBJ_COSTCODEID
			, OBJ_NOTE
			, OBJ_PSPID
			, OBJ_SIGNED
			, OBJ_SIGNLOC
			, OBJ_STSID
			, OBJ_PARENTID
			, OBJ_LEFT
			, OBJ_PM
			, OBJ_PM_TOSEND
			, OBJ_PM_SERVICE
			, OBJ_SERIAL
			, OBJ_VALUE
			, OBJ_OTID
			, OBJ_INOID
			, OBJ_VENDORID)
		values 
			( 
			@p_CODE
			, @p_ORG
			, @p_DESC
			, @p_DATE
			, @p_STATUS
			, @p_TYPE
			, @p_TYPE2
			, @p_TYPE3
			--, @p_RSTATUS
			--, @p_CREUSER
			--, @p_CREDATE
			--, @p_UPDUSER
			--, @p_UPDDATE
			, @p_NOTUSED
			, @p_ID
			--, @p_ACCOUNTID
			--, @p_ASSETID
			--, @p_ATTACH
			--, @p_CAPACITY
			--, @p_CATALOGNO
			--, @p_COSTCENTERID
			, @p_TXT01
			, @p_TXT02
			, @p_TXT03
			, @p_TXT04
			, @p_TXT05
			, @p_TXT06
			, @p_TXT07
			, @p_TXT08
			, @p_TXT09
			--, @p_TXT10
			--, @p_TXT11
			--, @p_TXT12
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
			--, @p_GROUPID
			--, @p_LOCID
			--, @p_LOCATION
			--, @p_MANUFACID
			--, @p_PARTSLISTID
			--, @p_PERSON
			--, @p_SERIAL
			--, @p_VALUE 
			--, @p_YEAR
			--, @p_MRCID
			--, @p_PREFERED
			--, @p_COMPLEX
			--, @p_COSTCODEID
			, @p_NOTE
			, @p_PSPID
			, @p_SIGNED
			, @p_SIGNLOC
			, @p_STSID
			, @p_PARENTID
			, @p_LEFT
			, @p_PM  
			, @p_PM_TOSEND 
			, @p_PM_SERVICE 
			, @p_SERIAL  
			, @p_VALUE
			, @p_OTID
			, @p_INOID
			, @v_VENDORID)
	end 
	else 
	begin 
		if @p_PM_TOSEND = 1 and (select OBJ_PM from dbo.OBJ where OBJ_ROWID = @p_ROWID) is null
		begin
			raiserror('Nie można edytować urządzenia dopóki umer SAP PM zostanie uzupełniony przez interfejs', 16, 1)
			return 1
		end

		update dbo.OBJ 
		set  
			OBJ_CODE = @p_CODE
			, OBJ_ORG = @p_ORG
			, OBJ_DESC = @p_DESC
			, OBJ_DATE = @p_DATE
			, OBJ_STATUS = @p_STATUS
			, OBJ_TYPE = @p_TYPE
			, OBJ_TYPE2 = @p_TYPE2
			, OBJ_TYPE3 = @p_TYPE3
			--, OBJ_RSTATUS = @p_RSTATUS
			--, OBJ_CREUSER = @p_CREUSER
			--, OBJ_CREDATE = @p_CREDATE
			, OBJ_UPDUSER = @p_UserID
			, OBJ_UPDDATE = getdate()
			, OBJ_NOTUSED = @p_NOTUSED
			, OBJ_ID = @p_ID
			--, OBJ_ACCOUNTID = @p_ACCOUNTID
			--, OBJ_ASSETID = @p_ASSETID
			--, OBJ_ATTACH = @p_ATTACH
			--, OBJ_CAPACITY = @p_CAPACITY
			--, OBJ_CATALOGNO = @p_CATALOGNO
			--, OBJ_COSTCENTERID = @p_COSTCENTERID
			, OBJ_TXT01 = @p_TXT01
			, OBJ_TXT02 = @p_TXT02
			, OBJ_TXT03 = @p_TXT03
			, OBJ_TXT04 = @p_TXT04
			, OBJ_TXT05 = @p_TXT05
			, OBJ_TXT06 = @p_TXT06
			, OBJ_TXT07 = @p_TXT07
			, OBJ_TXT08 = @p_TXT08
			, OBJ_TXT09 = @p_TXT09
			--, OBJ_TXT10 = @p_TXT10
			--, OBJ_TXT11 = @p_TXT11
			--, OBJ_TXT12 = @p_TXT12
			, OBJ_NTX01 = @p_NTX01
			, OBJ_NTX02 = @p_NTX02
			, OBJ_NTX03 = @p_NTX03
			, OBJ_NTX04 = @p_NTX04
			, OBJ_NTX05 = @p_NTX05
			, OBJ_COM01 = @p_COM01
			, OBJ_COM02 = @p_COM02
			, OBJ_DTX01 = @p_DTX01
			, OBJ_DTX02 = @p_DTX02
			, OBJ_DTX03 = @p_DTX03
			, OBJ_DTX04 = @p_DTX04
			, OBJ_DTX05 = @p_DTX05
			--, OBJ_GROUPID = @p_GROUPID
			--, OBJ_LOCID = @p_LOCID
			--, OBJ_LOCATION = @p_LOCATION
			--, OBJ_MANUFACID = @p_MANUFACID
			--, OBJ_PARTSLISTID = @p_PARTSLISTID
			--, OBJ_PERSON = @p_PERSON
			--, OBJ_SERIAL = @p_SERIAL
			--, OBJ_VALUE = @p_VALUE
			--, OBJ_YEAR = @p_YEAR
			--, OBJ_MRCID = @p_MRCID
			--, OBJ_PREFERED = @p_PREFERED
			--, OBJ_COMPLEX = @p_COMPLEX
			--, OBJ_COSTCODEID = @p_COSTCODEID
			, OBJ_NOTE = @p_NOTE
			, OBJ_PSPID = @p_PSPID
			, OBJ_SIGNED = @p_SIGNED
			, OBJ_SIGNLOC = @p_SIGNLOC
			, OBJ_STSID = @p_STSID
			, OBJ_PARENTID = @p_PARENTID
			, OBJ_LEFT = @p_LEFT
			, OBJ_PM = @p_PM
			, OBJ_PM_TOSEND = @p_PM_TOSEND
			, OBJ_PM_SERVICE = @p_PM_SERVICE
			, OBJ_SERIAL = @p_SERIAL
			, OBJ_VALUE = @p_VALUE
			, OBJ_OTID = @p_OTID
			, OBJ_INOID = @p_INOID
			, OBJ_VENDORID = @v_VENDORID

		where OBJ_ROWID = @p_ROWID
	end 
 
	return 0
	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1
	end
GO