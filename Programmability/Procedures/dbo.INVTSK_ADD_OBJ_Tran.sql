SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INVTSK_ADD_OBJ_Tran]
(
 
	@p_FormID nvarchar(50),
	--@p_OBJ_COUNT nvarchar(5),
	@p_OBJ_PSP nvarchar(30),  
	--@p_STS_CHILD nvarchar(30),  
	@p_STS nvarchar(30), 

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

	exec @v_errorid = [dbo].[INVTSK_ADD_OBJ_Proc] 	
		@p_FormID,
		@p_OBJ_PSP, 
		@p_STS, 

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