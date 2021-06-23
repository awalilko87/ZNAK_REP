SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
 
create PROCEDURE [dbo].[COSTCODE_LSRC_Update_Proc](
    @CCD_CODE nvarchar(30) = NULL OUT,
    @OLD_CCD_CODE nvarchar(30) = NULL OUT,
    @CCD_DESC nvarchar(80) = NULL,
    @OLD_CCD_DESC nvarchar(80) = NULL,
    @CCD_NOTUSED int = NULL,
    @OLD_CCD_NOTUSED int = NULL,
    @CCD_ORG nvarchar(30) = NULL OUT,
    @OLD_CCD_ORG nvarchar(30) = NULL OUT,
    @CCD_ROWID int = NULL,
    @OLD_CCD_ROWID int = NULL, 
    @p_UserID varchar(30),
    @p_apperrortext nvarchar(4000) output
    )
as
begin

	declare @v_errorcode nvarchar(50)
	, @v_syserrorcode nvarchar(4000)
	, @v_errortext nvarchar(4000)
	, @v_date datetime

	set @v_date = getdate()
	 
	if @CCD_CODE is null or @CCD_ORG is null -- ## dopisac klucze
	begin
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
	 
	if @CCD_CODE <> @OLD_CCD_CODE or @CCD_ORG <> @OLD_CCD_ORG 
	begin
		set @v_errorcode = 'SYS_011'
		goto errorlabel
	end


	if not exists (select 1 from dbo.COSTCODE where CCD_CODE = @CCD_CODE AND CCD_ORG = @CCD_ORG)
	begin
		insert into dbo.COSTCODE
			( CCD_CODE
			, CCD_DESC
			, CCD_NOTUSED
			, CCD_ORG
			, CCD_CREDATE
			, CCD_CREUSER)
		values 
			( @CCD_CODE
			, @CCD_DESC
			, @CCD_NOTUSED
			, @CCD_ORG
			, @v_date
			, @p_UserID)
	end 
	else 
	begin 
		update dbo.COSTCODE 
		set 
		  CCD_CODE = @CCD_CODE
		, CCD_DESC = @CCD_DESC
		, CCD_NOTUSED = @CCD_NOTUSED
		, CCD_ORG = @CCD_ORG
		, CCD_UPDDATE = @v_date
		, CCD_UPDUSER = @p_UserID
		where CCD_CODE = @OLD_CCD_CODE AND CCD_ORG = @OLD_CCD_ORG
	end 
 
	return 0
	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1
	end
GO