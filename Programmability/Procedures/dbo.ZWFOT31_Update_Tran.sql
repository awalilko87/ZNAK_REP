SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT31_Update_Tran]
(	
	@p_FormID nvarchar(50), 
	@p_ROWID int,
	@p_CODE nvarchar(30), 
	@p_ID nvarchar(50),
	@p_ORG nvarchar(30),
	@p_RSTATUS int,
	@p_STATUS nvarchar(30),
	@p_STATUS_old nvarchar(30),
	@p_TYPE nvarchar(30),
	@p_BUKRS nvarchar(30),  
	@p_CCD_DEFAULT nvarchar(30),
	@p_IF_EQUNR nvarchar(30), 
	@p_IF_SENTDATE datetime,
	@p_IF_STATUS int,
	@p_IMIE_NAZWISKO nvarchar(80), 
	@p_KROK nvarchar(10), 
	@p_SAPUSER nvarchar(12),
	@p_ZMT_ROWID int, 
	@p_NR_PM nvarchar(50),
	@p_OBSZAR nvarchar(30) = null,
	@p_COSTCODEID int,  
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
		@v_errorid = [dbo].[ZWFOT31_Update_Proc] 
		
			@p_FormID, 
			@p_ROWID,
			@p_CODE, 
			@p_ID,
			@p_ORG,
			@p_RSTATUS,
			@p_STATUS,
			@p_STATUS_old,
			@p_TYPE, 
			@p_BUKRS,   
			@p_CCD_DEFAULT,
			@p_IF_EQUNR, 
			@p_IF_SENTDATE,
			@p_IF_STATUS,
			@p_IMIE_NAZWISKO,  
			@p_KROK,  
			@p_SAPUSER, 
			@p_ZMT_ROWID,
			@p_NR_PM,
			@p_OBSZAR,
			@p_COSTCODEID,
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