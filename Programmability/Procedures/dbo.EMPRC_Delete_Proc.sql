SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[EMPRC_Delete_Proc] 
(
	@p_FormID nvarchar(50),
	@p_ID nvarchar(50),
	@p_UserID nvarchar(30), -- uzytkownik
	@p_apperrortext nvarchar(4000) output
)
as
begin
	declare @v_errorcode nvarchar(50)
	declare @v_syserrorcode nvarchar(4000)
	declare @v_errortext nvarchar(4000)
	declare @v_date datetime 
	declare @v_EMPID int
	declare @t_EmpUsed table (ROWID int)
	
	select @v_EMPID = EMP_ROWID from EMP (nolock) where EMP_ID = @p_ID
	
	insert into @t_EmpUsed  (ROWID)
		select EMP.EMP_ROWID from ST_INW (nolock) join EMP (nolock) on SIN_RESPON = EMP_CODE and SIN_ORG = EMP_ORG
		union
		--select EMP.EMP_ROWID from OFFQRY (nolock) join EMP (nolock) on OFF_RESPON = EMP_CODE and OFF_ORG = EMP_ORG
		--union
		--select EMP.EMP_ROWID from EVT (nolock) join EMP (nolock) on EVT_RESPON = EMP_CODE and EVT_ORG = EMP_ORG
		--union
		--select EMP.EMP_ROWID from EVT (nolock) join EMP (nolock) on   EVT_ASSIGNED = EMP_CODE and EVT_ORG = EMP_ORG
		--union
		--select EMP.EMP_ROWID from OBJ (nolock) join EMP (nolock) on OBJ_RESPON = EMP_CODE and OBJ_ORG = EMP_ORG
		--union
		select EMP.EMP_ROWID from OBJ (nolock) join EMP (nolock) on OBJ_PERSON = EMP_CODE and OBJ_ORG = EMP_ORG
		--union
		--select EMP.EMP_ROWID from ORDERS (nolock) join EMP (nolock) on ORD_PERSON = EMP_CODE and ORD_ORG = EMP_ORG
		--union
		--select EMP.EMP_ROWID from REQUEST (nolock) join EMP (nolock) on RST_RESPON = EMP_CODE and RST_ORG = EMP_ORG
		--union
		--select EMP.EMP_ROWID from VEHICLEFUEL (nolock) join EMP (nolock) on VEF_OWNER  = EMP_CODE and VEF_ORG = EMP_ORG
		--union
		--select EMP.EMP_ROWID from VEHICLE (nolock) join EMP (nolock) on VEH_OWNER = EMP_CODE and VEH_ORG = EMP_ORG
		--union
		--select ACT_RESPONID from ACT (nolock)
		--union
		--select ACT_EMPLOYEEID from ACT (nolock)
		--union
		--select EVE_EMPID from EVTE (nolock)
		--union
		--select SCH_EMPID from EMPSCHEDULE (nolock)
		--union
		--select ERT_EMPID from EMPRATE (nolock)
		--union
		--select SWL_EMPID from ST_WNLN (nolock)
		--union 
		--select SNL_EMPID from ST_ZNLN (nolock)
		--union 
		--select ETR_EMPID from EMPTRAIN (nolock)
		--union
		--select VET_EMPID from VEHICLETRIP (nolock)
		--union
		--select VED_EMPID from VEHICLEDRIVER (nolock)
		--union
		--select MAIR_EMPID from MAILRECIPIENTS (nolock)



	if @v_EMPID in (select ROWID from @t_EmpUsed)
	begin 
		BEGIN TRY
			update EMP set EMP_NOTUSED = 1 where EMP_ID = @p_ID
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'EMP_003' -- blad kasowania
			goto errorlabel
		END CATCH;
		
		select @v_errorcode = 'EMP_004' -- Pracownik jest już wykorzystywany w systemie. Nie został usunięty a jedynie oznaczony jako "Nieużywany"
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 1, 1)  
	end
	else
	begin
		BEGIN TRY
			delete from EMP where EMP_ID = @p_ID
		END TRY
		BEGIN CATCH
			select @v_syserrorcode = error_message()
			select @v_errorcode = 'EMP_003' -- blad kasowania
			goto errorlabel
		END CATCH;	
	end
	
	return 0
	errorlabel:
		exec err_proc @v_errorcode, @v_syserrorcode, @p_UserID, @v_errortext output
		raiserror (@v_errortext, 16, 1) 
		return 1
end
 
GO