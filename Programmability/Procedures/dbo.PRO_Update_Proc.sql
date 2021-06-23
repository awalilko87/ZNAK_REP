SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[PRO_Update_Proc]
(
	@p_FormID nvarchar(50),
	@p_CODE nvarchar(30) = NULL,
	@p_MAX nvarchar(40) = NULL,
	@p_MIN nvarchar(40) = NULL,
	@p_ROWID int = NULL,
	@p_TEXT nvarchar(25) = NULL,
	@p_TYPE nvarchar(4) = NULL,
	@p_PM_KLASA nvarchar(30),
	@p_PM_CECHA nvarchar(30),
	 
	@p_UserID nvarchar(30) = NULL, -- uzytkownik
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
	if @p_CODE is NULL  
	begin
		select @v_errorcode = 'SYS_003'
		goto errorlabel
	end
 
	set @v_date = getdate()

	--insert
	if not exists (select * from dbo.PROPERTIES (nolock) where PRO_ROWID = @p_ROWID)
	begin

		--numeracja
		--declare @v_Number nvarchar(50), @v_No int
		--exec dbo.VS_GetNumber @Type = 'RST_BUK', @Pref = 'ZP/', @Suff = '/09', @Number = @v_Number output, @No = @v_No output
		--select @v_Number, @v_No

		BEGIN TRY
			insert into dbo.PROPERTIES
			(
				PRO_CODE 
				, PRO_MAX
				, PRO_MIN 
				, PRO_TEXT 
				, PRO_TYPE 
				, PRO_PM_KLASA
				, PRO_PM_CECHA
			)
			values 
			(
				@p_CODE 
				, @p_MAX
				, @p_MIN 
				, @p_TEXT 
				, @p_TYPE 
				, @p_PM_KLASA
				, @p_PM_CECHA
			)
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'PRO_001' -- blad wstawienia
			goto errorlabel
		END CATCH;
	end
	else
	begin

		/*
		if not exists(select * from dbo.PROPERTIES (nolock) where PRO_ROWID = @p_ROWID and ISNULL(PRO_STATUS,0) = ISNULL(@p_STATUS_old,0))
		begin
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'SYS_002' -- blad wspoluzytkowania
			goto errorlabel
		end   
		*/
		
		if exists(select * from dbo.PROPERTIES (nolock) where PRO_ROWID = @p_ROWID AND PRO_CODE <> @p_CODE)
		begin
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'SYS_011' -- blad wspoluzytkowania
			goto errorlabel
		end   

		BEGIN TRY
		
			UPDATE dbo.PROPERTIES SET
				PRO_CODE = @p_CODE
				, PRO_MAX = @p_MAX
				, PRO_MIN = @p_MIN 
				, PRO_TEXT = @p_TEXT
				, PRO_TYPE = @p_TYPE
				, PRO_UPDATECOUNT = isnull(PRO_UPDATECOUNT,0) + 1
				, PRO_PM_KLASA = @p_PM_KLASA
				, PRO_PM_CECHA = @p_PM_CECHA
			where PRO_ROWID = @p_ROWID

		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'PRO_002' -- blad aktualizacji zgloszenia
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