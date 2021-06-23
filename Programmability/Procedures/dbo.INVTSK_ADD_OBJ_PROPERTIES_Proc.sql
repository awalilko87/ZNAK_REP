SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INVTSK_ADD_OBJ_PROPERTIES_Proc]
(
	@p_FormID nvarchar(50),   
	@p_ASPID int, 
	@p_ENT nvarchar(10), 
	@p_OBJ nvarchar(30), 
	@p_OBJDESC nvarchar(80), 
	@p_OBJID int, 
	@p_PROID int, 
	@p_PSP nvarchar(30),  
	@p_PSPID int, 
	@p_ROWID int, 
	@p_STSID int, 
	@p_UOM nvarchar(30), 
	@p_UOMID int, 
	@p_VALUE nvarchar(40),

	@p_UserID nvarchar(30), -- uzytkownik
	@p_apperrortext nvarchar(4000) = null output
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
		
	--select @p_VALUE_LIST ='a + ' + isnull(cast (@p_PROPERTY as nvarchar(30)),'@p_OBJID: NULL') + ' + a'
	--raiserror (@p_VALUE_LIST, 16, 1) 
	--return 0

	-- czy klucze niepuste
	if @p_ASPID is null -- ## dopisac klucze
	begin
		select @v_errorcode = 'PRV_001'
		goto errorlabel
	end
 
 	-- czy klucze niepuste
	if @p_PROID is null -- ## dopisac klucze
	begin
		select @v_errorcode = 'PRL_002'
		goto errorlabel
	end
   
	--select @v_PRO_TYPE = PRO_TYPE from PROPERTIES (nolock) where PRO_ROWID = @p_PROID
	--select 	PRO_TYPE from PROPERTIES where PRO_CODE = 'MID'

	--if @v_PRO_TYPE = 'TXT' 
	--	select @v_VALUE = cast (@p_VALUE_LIST as nvarchar(255))

	--else if @v_PRO_TYPE = 'DDL' 
	--begin
	--	if @p_VALUE_LIST in (select PRL_TEXT from PROPERTIES_LIST (nolock) where PRL_PROID = @p_PROID) select @v_VALUE = cast (@p_VALUE_LIST as nvarchar(255))
	--	else select @v_ERROR = N'Wprowadzono niewłaściwe pole słownikowane: ' + cast (@p_VALUE_LIST as nvarchar(255))
	--end

	--else if @v_PRO_TYPE = 'DTX' 
	--begin
	--	if isdate(@p_VALUE_LIST) = 1	select @v_DVALUE = cast (@p_VALUE_LIST as datetime)
	--	else select @v_ERROR = N'Wprowadzono niewłaściwe pole daty: ' + cast (@p_VALUE_LIST as nvarchar(255))
	--end

	--else if @v_PRO_TYPE = 'NTX' 
	--begin
	--	if isnumeric(@p_VALUE_LIST) = 1	select @v_NVALUE = cast (@p_VALUE_LIST as numeric(24,6))
	--	else select @v_ERROR = N'Wprowadzono niewłaściwe pole numeryczne: ' + cast (@p_VALUE_LIST as nvarchar(255))
	--end
		
	--insert
	if not exists (select * from dbo.PROPERTYVALUES (nolock) where PRV_PKID = @p_OBJID and PRV_PROID = @p_PROID and isnull(@p_VALUE,'') <> '')
	begin 
		BEGIN TRY
			insert into dbo.PROPERTYVALUES
			(
				PRV_PROID,
				PRV_PKID,
				PRV_ENT,
				PRV_VALUE,
				PRV_CREATED,
				PRV_NOTUSED
			)
			select  
				@p_PROID,
				@p_OBJID,
				'OBJ',
				@p_VALUE,
				getdate(),
				0

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'SYS_001' -- blad wstawienia
			goto errorlabel
		END CATCH;
	end
	else if isnull(@p_VALUE,'') <> ''
	begin
      
		BEGIN TRY

		UPDATE dbo.PROPERTYVALUES SET 
			PRV_VALUE = @p_VALUE,
			PRV_UPDATECOUNT = PRV_UPDATECOUNT   + 1,
			PRV_UPDATED = getdate(),
			PRV_NOTUSED = 0
		where 
			PRV_PROID = @p_PROID and PRV_PKID = @p_OBJID 

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'OBJ_002' -- blad aktualizacji zgloszenia
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