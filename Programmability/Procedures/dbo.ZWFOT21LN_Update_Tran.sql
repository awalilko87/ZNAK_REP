SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT21LN_Update_Tran]
(
	@p_FormID nvarchar(50), 
	@p_ROWID int, 
	@p_OT21ID int,
	@p_OBJID int,
	@p_CODE nvarchar(30), 
	@p_ID nvarchar(50),
	@p_ORG nvarchar(30),
	@p_RSTATUS int,
	@p_STATUS nvarchar(30),
	@p_STATUS_old nvarchar(30),
	@p_TYPE nvarchar(30),
	@p_ANLN1_POSKI nvarchar(30),
	@p_ANLN2 nvarchar(30),
	@p_WART_NAB_PLN numeric(30,2),
	@p_DOSTAWCA nvarchar(80),
	@p_NR_DOW_DOSTAWY nvarchar(30),
	@p_DT_DOSTAWY datetime,
	@p_GRUPA nvarchar(8),
	@p_ILOSC int,
	@p_NZWYP nvarchar(50),
	@p_MUZYTK nvarchar(50),

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
		@v_errorid = [dbo].[ZWFOT21LN_Update_Proc] 
		
			@p_FormID, 
			@p_ROWID, 
			@p_OT21ID,
			@p_OBJID,
			@p_CODE, 
			@p_ID,
			@p_ORG,
			@p_RSTATUS,
			@p_STATUS,
			@p_STATUS_old,
			@p_TYPE, 
			@p_ANLN1_POSKI,
			@p_ANLN2,
			@p_WART_NAB_PLN,
			@p_DOSTAWCA,
			@p_NR_DOW_DOSTAWY,
			@p_DT_DOSTAWY,
			@p_GRUPA,
			@p_ILOSC,
			@p_NZWYP,
			@p_MUZYTK,
			
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