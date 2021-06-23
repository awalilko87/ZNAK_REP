SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[INVTSK_ADD_OBJ_PROPERTIES_Tran]
(
	@p_FormID nvarchar(50),   
	@p_ASPID int, 
	@p_ENT nvarchar(10), 
	@p_OBJ nvarchar(30), 
	@p_OBJDESC nvarchar(80), 
	@p_OBJID int, 
	@p_PROID int, 
	@p_PSP nvarchar(30),  
	@p_PSPID int, 
	@p_ROWID int, 
	@p_STSID int, 
	@p_UOM nvarchar(30), 
	@p_UOMID int, 
	@p_VALUE nvarchar(40), 

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
		exec @v_errorid = [dbo].[INVTSK_ADD_OBJ_PROPERTIES_Proc] 
			@p_FormID,   
			@p_ASPID, 
			@p_ENT, 
			@p_OBJ, 
			@p_OBJDESC, 
			@p_OBJID, 
			@p_PROID, 
			@p_PSP,  
			@p_PSPID, 
			@p_ROWID, 
			@p_STSID, 
			@p_UOM, 
			@p_UOMID, 
			@p_VALUE,	
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