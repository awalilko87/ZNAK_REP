SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT41_Delete_Proc]
(
	@p_FormID nvarchar(50), 
	@p_ROWID int,
	@p_ID nvarchar(50),

	@p_UserID nvarchar(30) = NULL, -- uzytkownik
	@p_apperrortext nvarchar(4000) = null output
)
as
begin

	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @v_date datetime 
	declare @v_Pref nvarchar(10)
	declare @v_MultiOrg BIT
	declare 
		@v_OTID int,
		@v_OT41ID int,
		@v_STATUS nvarchar(30),
		@v_RSTATUS int
 
	select 
		@v_STATUS = OT_STATUS,
		@v_OTID = OT_ROWID
	from dbo.ZWFOT (nolock) where OT_ID = @p_ID
 
	-- czy klucze niepuste
	if @p_ID is null  -- ## dopisac klucze
	begin
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
	
 	-- czy status pozwala
	if @v_STATUS not like '%10' 
	begin
		select @v_errorcode = 'STA_DEL_ERROR'
		goto errorlabel
	end
	 
	select @v_Pref = TablePrefix, @v_MultiOrg = MultiOrg from dbo.VS_Forms (nolock) where FormID = @p_FormID
	select @v_Rstatus = STA_RFLAG from dbo.STA (nolock) where STA_ENTITY = @v_Pref and STA_CODE = @v_STATUS

	set @v_date = getdate()
  	     
	--insert
	if exists (select * from dbo.ZWFOT (nolock) where OT_ID = @p_ID)
	begin

		BEGIN TRY
		
			delete from dbo.SAPO_ZWFOT41LN where OT41LN_OT41ID in (select OT41_ROWID from dbo.SAPO_ZWFOT41 where OT41_ZMT_ROWID = @v_OTID)
			delete from dbo.ZWFOTOBJ  where OTO_OTID = @v_OTID 
			delete from dbo.ZWFOTLN  where OTL_OTID = @v_OTID 
			delete from dbo.SAPO_ZWFOT41 where OT41_ZMT_ROWID = @v_OTID
			delete from dbo.ZWFOT where OT_ROWID = @v_OTID
			
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OT41_002' -- blad wstawienia
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