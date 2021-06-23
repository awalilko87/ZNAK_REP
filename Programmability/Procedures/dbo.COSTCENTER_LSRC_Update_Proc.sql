SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

 
create PROCEDURE [dbo].[COSTCENTER_LSRC_Update_Proc](
    @CCT_CODE nvarchar(30) = NULL OUT,
    @OLD_CCT_CODE nvarchar(30) = NULL OUT,
    @CCT_DESC nvarchar(80) = NULL,
    @OLD_CCT_DESC nvarchar(80) = NULL,
    @CCT_NOTUSED int = NULL,
    @OLD_CCT_NOTUSED int = NULL,
    @CCT_ORG nvarchar(30) = NULL OUT,
    @OLD_CCT_ORG nvarchar(30) = NULL OUT,
    @CCT_ROWID int = NULL,
    @OLD_CCT_ROWID int = NULL, 
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
	 
	if @CCT_CODE is null or @CCT_ORG is null -- ## dopisac klucze
	begin
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
	 
	if @CCT_CODE <> @OLD_CCT_CODE or @CCT_ORG <> @OLD_CCT_ORG 
	begin
		set @v_errorcode = 'SYS_011'
		goto errorlabel
	end


	if not exists (select 1 from dbo.COSTCENTER where CCT_CODE = @CCT_CODE AND CCT_ORG = @CCT_ORG)
	begin
		insert into dbo.COSTCENTER
			( CCT_CODE
			, CCT_DESC
			, CCT_NOTUSED
			, CCT_ORG
			, CCT_CREDATE
			, CCT_CREUSER)
		values 
			( @CCT_CODE
			, @CCT_DESC
			, @CCT_NOTUSED
			, @CCT_ORG
			, @v_date
			, @p_UserID)
	end 
	else 
	begin 
		update dbo.COSTCENTER 
		set 
		  CCT_CODE = @CCT_CODE
		, CCT_DESC = @CCT_DESC
		, CCT_NOTUSED = @CCT_NOTUSED
		, CCT_ORG = @CCT_ORG
		, CCT_UPDDATE = @v_date
		, CCT_UPDUSER = @p_UserID
		where CCT_CODE = @OLD_CCT_CODE AND CCT_ORG = @OLD_CCT_ORG
	end 
 
	return 0
	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1
	end

GO