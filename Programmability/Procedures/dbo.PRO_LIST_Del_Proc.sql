SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[PRO_LIST_Del_Proc] 
(
	@p_PROID int = NULL, 
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
   
	begin
      
		BEGIN TRY

		delete from dbo.PROPERTIES_LIST where PRL_PROID = @p_PROID and PRL_TEXT = @p_TEXT

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