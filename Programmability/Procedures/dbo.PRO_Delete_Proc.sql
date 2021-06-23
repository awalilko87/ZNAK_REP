SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[PRO_Delete_Proc]
(
	@p_FormID nvarchar(50),
	@p_ROWID int = NULL,
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
 
	set @v_date = getdate()

	--insert
	if not exists (select * from dbo.PROPERTYVALUES (nolock) where PRV_PROID = @p_ROWID)
	begin
	 
		BEGIN TRY
			delete from ADDSTSPROPERTIES where ASP_PROID = @p_ROWID
			delete from PROPERTIES where PRO_ROWID = @p_ROWID
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'PRO_001' -- blad wstawienia
			goto errorlabel
		END CATCH;
	end
	else 
	begin
		BEGIN TRY
			update PROPERTIES set PRO_NOTUSED = 1 where PRO_ROWID = @p_ROWID
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'PRO_001' -- blad wstawienia
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