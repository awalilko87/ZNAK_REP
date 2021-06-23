SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[STAHIST_Add_Proc] ( 
	@p_Pref nvarchar(10),
	@p_ID nvarchar(50),
	@p_STATUS nvarchar(30),
	@p_STATUS_old nvarchar(30),
	@p_UserID nvarchar(30), -- uzytkownik
	@p_apperrortext nvarchar(4000) = null output 
)
as  
begin  
	declare @v_errorcode varchar(30)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000) 
	select @v_errortext = null
	declare @v_date datetime

	set @v_date = getdate()

	BEGIN TRY
		insert into dbo.STAHIST (STH_ENTITY, STH_ID, STH_DATE, STH_USER, STH_OLD, STH_NEW)
		values (@p_Pref, @p_ID, @v_date, @p_UserID, @p_STATUS_old, @p_STATUS)
	END TRY
	BEGIN CATCH
		select @v_syserrorcode = error_message()
		select @v_errorcode = 'STAHIST_001' -- blad wstawienia historii zmian statusów
		goto errorlabel
	END CATCH;

	return 0
	
	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		select @p_apperrortext = @v_errortext
		return 1
end  




GO