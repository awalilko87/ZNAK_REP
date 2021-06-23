SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

 
CREATE procedure [dbo].[INVTSK_ADD_OBJ_LINES_Tran]
(
 
	@p_FormID nvarchar(50),
	@p_INOID int,
	@p_OBJ_COUNT nvarchar(5),
	@p_OBJ_PSP nvarchar(30),  
	@p_STS_CHILD nvarchar(30),  
	@p_STS_PARENT nvarchar(30), 
	@p_OBJ_VALUE numeric(18, 2),

	@p_UserID nvarchar(30), -- uzytkownik
	@p_apperrortext nvarchar(4000) = null output

)
as
begin
	declare @v_errorid int
	declare @v_errortext nvarchar(4000) 
	select @v_errorid = 0
	select @v_errortext = null
	declare @v_OBJ_COUNT int

	begin transaction

	--Z jakiegoś powodu po wyborze z DDL NULLA był z tym problem, stąd przeszczep
	select @v_OBJ_COUNT = cast (isnull(@p_OBJ_COUNT,'0') as int)

	exec @v_errorid = [dbo].[INVTSK_ADD_OBJ_LINES_Proc] 	
		@p_FormID,
		@p_INOID,
		@v_OBJ_COUNT,
		@p_OBJ_PSP, 
		@p_STS_CHILD, 
		@p_STS_PARENT, 
		@p_OBJ_VALUE,

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