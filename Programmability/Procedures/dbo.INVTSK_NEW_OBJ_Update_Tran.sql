SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INVTSK_NEW_OBJ_Update_Tran]
(
	@p_INOID int,
	@p_PSP nvarchar(30),
	@p_STS nvarchar(30),
	@p_STN nvarchar(30),
	@p_VALUE decimal(30,6),
	@p_OBJ nvarchar(30),

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
  
    exec @v_errorid = [dbo].[INVTSK_NEW_OBJ_Update_Proc]    
		@p_INOID,
		@p_PSP, 
		@p_STS, 
		@p_STN, 
		@p_VALUE, 
		@p_OBJ, 
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