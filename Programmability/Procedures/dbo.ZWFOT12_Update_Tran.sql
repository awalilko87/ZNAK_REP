SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[ZWFOT12_Update_Tran]
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
	@p_ANLKL_POSKI nvarchar(8), 
	@p_BUKRS nvarchar(30),  
	@p_GDLGRP_POSKI nvarchar(30),
	@p_HERST_POSKI nvarchar(30),
	@p_NR_DOW_DOST nvarchar(30),
	@p_IF_EQUNR nvarchar(30), 
	@p_IF_SENTDATE datetime,
	@p_IF_STATUS int,
	@p_IMIE_NAZWISKO nvarchar(80), 
	@p_KOSTL_POSKI nvarchar(30),
	@p_KROK nvarchar(10), 
	@p_DATA_DOST datetime, 	
	@p_MIES_DOST int,
	@p_MUZYTKID int,
	@p_MUZYTK nvarchar(30), 
	@p_POSNR_POSKI nvarchar(30),
	@p_PRZEW_OKRES int,
	@p_ROK_DOST int,
	@p_SAPUSER nvarchar(12),
	@p_SERNR_POSKI nvarchar(30),  
	@p_WOJEWODZTWO nvarchar(12),
	@p_PODZ_USL_P int,
	@p_PODZ_USL_S int,
	@p_PODZ_USL_B int,
	@p_PODZ_USL_C int,
	@p_PODZ_USL_U int,
	@p_PODZ_USL_H int, 
	@p_CZY_FORM nvarchar(1),
	@p_ZZ_NR_FORM nvarchar(25),
	@p_ZZ_TYP_DOK nvarchar(50),
	@p_ZZ_POZ_FORM nvarchar(10),
	@p_ZZ_NR_DOK  nvarchar(25),
	@p_ZMT_ROWID int,
	@p_ZMT_OBJ_CODE nvarchar(30),
	@p_INOID int,
	 
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
		@v_errorid = [dbo].[ZWFOT12_Update_Proc] 
		
			@p_FormID, 
			@p_ROWID,
			@p_CODE, 
			@p_ID,
			@p_ORG,
			@p_RSTATUS,
			@p_STATUS,
			@p_STATUS_old,
			@p_TYPE,
			@p_ANLKL_POSKI, 
			@p_BUKRS,  
			@p_GDLGRP_POSKI, 
			@p_HERST_POSKI,
			@p_NR_DOW_DOST,
			@p_IF_EQUNR, 
			@p_IF_SENTDATE,
			@p_IF_STATUS,
			@p_IMIE_NAZWISKO, 
			@p_KOSTL_POSKI,
			@p_KROK, 
			@p_DATA_DOST,
			@p_MIES_DOST,
			@p_MUZYTKID,
			@p_MUZYTK, 
			@p_POSNR_POSKI,
			@p_PRZEW_OKRES,
			@p_ROK_DOST,
			@p_SAPUSER,
			@p_SERNR_POSKI, 
			@p_WOJEWODZTWO,
			@p_PODZ_USL_P,
			@p_PODZ_USL_S,
			@p_PODZ_USL_B,
			@p_PODZ_USL_C,
			@p_PODZ_USL_U,
			@p_PODZ_USL_H, 
			@p_CZY_FORM,
			@p_ZZ_NR_FORM,
			@p_ZZ_TYP_DOK,
			@p_ZZ_POZ_FORM,
			@p_ZZ_NR_DOK,
			@p_ZMT_ROWID, 
			@p_ZMT_OBJ_CODE,
			@p_INOID,

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