SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INWAST_NEW_OBJ_Update_Tran]
(
	@p_SIAID int,
	@p_STS nvarchar(30),
	@p_OBJ nvarchar(30),
	@p_STNID int,

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
	
		exec @v_errorid = dbo.[INWAST_NEW_OBJ_Update_Proc] 
			@p_SIAID,
			@p_STS,
			@p_OBJ,
			@p_STNID,
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