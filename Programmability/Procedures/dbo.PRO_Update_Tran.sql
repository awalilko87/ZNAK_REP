SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[PRO_Update_Tran]
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
	declare @v_errorid int
	declare @v_errortext nvarchar(4000) 
	select @v_errorid = 0
	select @v_errortext = null

	begin transaction
	
	exec @v_errorid = [dbo].[PRO_Update_Proc] 
		@p_FormID
		, @p_CODE 
		, @p_MAX
		, @p_MIN
		, @p_ROWID
		, @p_TEXT 
		, @p_TYPE 
		, @p_PM_KLASA
		, @p_PM_CECHA
 		, @p_UserID, @p_apperrortext output

	if @v_errorid = 0
	begin
		commit transaction
		return 0
	end
	else
	begin
		rollback transaction
		return 1
	end
end
GO