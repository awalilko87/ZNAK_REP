SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[STS_PROPERTIES_Update_Tran]
(
	@p_FormID nvarchar(50),
	@p_ENT nvarchar(10), 
	@p_LIST nchar(1), 
	@p_PRO nvarchar(30),  
	@p_PROID int, 
	@p_PROTYPE nvarchar(4), 
	@p_REQUIRED nvarchar(3), 
	@p_ROWID int, 
	@p_STSID int, 
	@p_UOM nvarchar(30),  
	@p_UOMID int,  
	@p_ASP_VALUE nvarchar(512),
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
	exec @v_errorid = [dbo].[STS_PROPERTIES_Update_Proc] 
 		  @p_FormID 
		, @p_ENT  
		, @p_LIST 
		, @p_PRO 
		, @p_PROID 
		, @p_PROTYPE 
		, @p_REQUIRED 
		, @p_ROWID 
		, @p_STSID  
		, @p_UOM  
		, @p_UOMID 
		, @p_ASP_VALUE
		, @p_UserID
		, @p_apperrortext output

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