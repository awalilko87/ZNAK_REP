SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT33DON_Update_Tran]
(
	@p_FormID nvarchar(50), 
	@p_ROWID int,
	@p_OT33ID int,
	@p_CODE nvarchar(30), 
	@p_ID nvarchar(50),
	@p_ORG nvarchar(30),
	@p_RSTATUS int,
	@p_STATUS nvarchar(30),
	@p_STATUS_old nvarchar(30),
	@p_TYPE nvarchar(30),
	@p_TXT50 nvarchar (50),
	@p_WARST decimal (13,2),
	@p_NDJARPER int,
	@p_MTOPER nvarchar(2),
	@p_ANLN1_POSKI nvarchar (30),
	@p_ANLN2 nvarchar (4),
	@p_ANLN1_DO_POSKI nvarchar (30),
	@p_ANLN2_DO nvarchar (4),
	@p_ANLKL_DO_POSKI nvarchar (8),
	@p_KOSTL_DO_POSKI nvarchar (10),
	@p_UZYTK_DO_POSKI nvarchar (8),
	@p_PRAC_DO int,
	@p_PRCNT_DO int,
	@p_WARST_DO decimal (13,2),
	@p_TXT50_DO nvarchar (50),
	@p_NDPER_DO int,
	@p_CHAR_DO nvarchar (50),
	@p_BELNR nvarchar (10),
	@p_ZMT_ROWID int,
	@p_STNID nvarchar(30),   
	@p_STS nvarchar(30), 
	@p_OT33_OPERATION nvarchar(2),
	@p_OBJ nvarchar(30) = null,
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
		@v_errorid = [dbo].[ZWFOT33DON_Update_Proc] 
		
				@p_FormID, 
				@p_ROWID,
				@p_OT33ID,
				@p_CODE,
				@p_ID,
				@p_ORG,
				@p_RSTATUS,
				@p_STATUS,
				@p_STATUS_old,
				@p_TYPE,
				@p_TXT50,
				@p_WARST,
				@p_NDJARPER,
				@p_MTOPER,
				@p_ANLN1_POSKI,
				@p_ANLN2,
				@p_ANLN1_DO_POSKI,
				@p_ANLN2_DO,
				@p_ANLKL_DO_POSKI,
				@p_KOSTL_DO_POSKI,
				@p_UZYTK_DO_POSKI,
				@p_PRAC_DO,
				@p_PRCNT_DO,
				@p_WARST_DO,
				@p_TXT50_DO,
				@p_NDPER_DO,
				@p_CHAR_DO,
				@p_BELNR,
				@p_ZMT_ROWID,
				@p_STNID,
				@p_STS,
				@p_OT33_OPERATION,
				@p_OBJ,
				@p_UserID, -- uzytkownik
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