SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[PRO_LIST_Update_Proc] 
(
	@p_FormID nvarchar(50),  
	@p_PROID int = NULL, 
	@p_ROWID int = NULL, 
	@p_TEXT nvarchar(255) = NULL, 
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
	declare @v_type nvarchar(4)
	declare @v_count int
  
  select @v_type = PRO_TYPE, @v_count = PRO_PRL_COUNT from PROPERTIESv where PRO_ROWID = @p_PROID

	-- czy klucze niepuste
	if @p_TEXT is null -- ## dopisac klucze
	begin
		select @v_errorcode = 'PRL_001'
		goto errorlabel
	end
 
 	-- czy klucze niepuste
	if @p_PROID is null -- ## dopisac klucze
	begin
		select @v_errorcode = 'PRL_002'
		goto errorlabel
	end

	set @v_date = getdate()


	if (@v_type <> 'DDL' and @v_count >= 1)

		begin

		RaisError('Nie można wprowadzić kolejnej wartości dla parametru innego niż DDL',16,1)
	
		end

   
	--insert
	if not exists (select * from dbo.PROPERTIES_LIST (nolock) where PRL_ROWID = @p_ROWID)
	begin 
		BEGIN TRY
			insert into dbo.PROPERTIES_LIST
			(
				PRL_TEXT,
				PRL_CREATED,
				PRL_PROID
			)
			select  
				@p_TEXT,
				getdate(),
				@p_PROID

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'SYS_001' -- blad wstawienia
			goto errorlabel
		END CATCH;
	end
	else
	begin
      
		BEGIN TRY

		UPDATE dbo.PROPERTIES_LIST SET
			
			PRL_TEXT = @p_TEXT,
			PRL_UPDATECOUNT = isnull(PRL_UPDATECOUNT,0) + 1, 
			PRL_UPDATED = getdate(),
			PRL_PROID = @p_PROID 
		where 
			PRL_ROWID = @p_ROWID

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