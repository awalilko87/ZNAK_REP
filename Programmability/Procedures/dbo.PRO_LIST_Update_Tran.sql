SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[PRO_LIST_Update_Tran]
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
	declare @v_errorid int
	declare @v_errortext nvarchar(4000) 
	select @v_errorid = 0
	select @v_errortext = null

	begin transaction
		exec @v_errorid = [dbo].[PRO_LIST_Update_Proc] 
			@p_FormID,
			@p_PROID,
			@p_ROWID,
			@p_TEXT,
			@p_UserID, 
			@p_apperrortext output
		
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