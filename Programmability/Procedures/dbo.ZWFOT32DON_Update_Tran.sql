SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT32DON_Update_Tran]
(
	@p_FormID nvarchar(50), 
	@p_ROWID int,
	@p_OT32ID int,
	@p_CODE nvarchar(30), 
	@p_ID nvarchar(50),
	@p_ORG nvarchar(30),
	@p_RSTATUS int,
	@p_STATUS nvarchar(30),
	@p_STATUS_old nvarchar(30),
	@p_TYPE nvarchar(30),
 	@p_LP int,
	@p_BUKRS nvarchar(30), 
	@p_ANLN1_POSKI nvarchar(30), 
	@p_ANLN2 nvarchar(30), 
	@p_ANLN1_DO_POSKI nvarchar(30), 
	@p_ANLN2_DO nvarchar(30), 
	@p_ZMT_ROWID int, 

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
	
	exec 
		@v_errorid = [dbo].[ZWFOT32DON_Update_Proc] 
		
			@p_FormID,
			@p_ROWID,
			@p_OT32ID,
			@p_CODE,
			@p_ID,
			@p_ORG,
			@p_RSTATUS,
			@p_STATUS,
			@p_STATUS_old,
			@p_TYPE,
 			@p_LP,
			@p_BUKRS,
			@p_ANLN1_POSKI,
			@p_ANLN2,
			@p_ANLN1_DO_POSKI,
			@p_ANLN2_DO,
			@p_ZMT_ROWID,

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