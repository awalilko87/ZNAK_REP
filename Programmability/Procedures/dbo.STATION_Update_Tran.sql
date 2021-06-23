SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[STATION_Update_Tran] 
(
	@p_FormID nvarchar(50),
	@p_ID nvarchar(50),
	@p_ROWID int,
	@p_CODE nvarchar(30),
	@p_DESC nvarchar(80),
	@p_STATUS nvarchar(30),
	@p_STATUS_old nvarchar(30),
	@p_TYPE nvarchar(30),
	@p_STREET nvarchar(100),
	@p_CITY nvarchar(100),
	@p_VOIVODESHIP nvarchar(10),
	@p_CCD nvarchar(30),  
	@p_KL5 nvarchar(30),  
	@p_NOTUSED int, 
	@p_ORG nvarchar(30),
 
	--- tutaj ewentualnie swoje parametry/zmienne/dane
	@p_UserID nvarchar(30), -- uzytkownik
	@p_apperrortext nvarchar(4000) output
)
as
begin
	declare @v_errorid int
	declare @v_errortext nvarchar(4000) 
	select @v_errorid = 0
	select @v_errortext = null

	begin transaction
		exec @v_errorid = [dbo].[STATION_Update_Proc]
			@p_FormID,
			@p_ID,
			@p_ROWID,
			@p_CODE,
			@p_DESC,
			@p_STATUS,
			@p_STATUS_old,
			@p_TYPE,
			@p_STREET,
			@p_CITY,
			@p_VOIVODESHIP,
			@p_CCD,
			@p_KL5,
			@p_NOTUSED, 
			@p_ORG,
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