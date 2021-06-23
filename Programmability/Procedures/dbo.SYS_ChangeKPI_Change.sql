SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

      
CREATE PROCEDURE [dbo].[SYS_ChangeKPI_Change](
	@UserID nvarchar(30),
    @UserName nvarchar(100), 
    @KPIUserID nvarchar(30)
) 
AS
BEGIN
    DECLARE @Mes nvarchar(400)
    --Niewłaściwa grupa źródłowego użytkownika KPI
    IF (SELECT UserGroupID from SYUsers (nolock) WHERE UserID = @UserID) <> (SELECT UserGroupID FROM SYUsers (nolock) WHERE UserID = @KPIUserID)
    BEGIN
	    SELECT @Mes = '<b>Użytkownik źródłowy musi znajdować się w tej samej grupie co użytkownik ze zmienianym KPI</b>'
        GOTO end_error
    END
	
	DECLARE @c_Userid nvarchar(30)
    DECLARE users_cursor CURSOR FOR
    SELECT UserID FROM SYUsers (nolock) WHERE UserID = @UserID
   
    --kursor gdyby zmienianych było więcej userów (np. całej grupy)
    --where UserGroupID = @p_GroupID and UserID <> @p_UserID
    OPEN users_cursor
    FETCH NEXT FROM users_cursor
    INTO @c_Userid
	WHILE @@fetch_status = 0
	BEGIN
		DELETE FROM dbo.VS_KPIUSERS WHERE KPU_USERID = @c_Userid
        INSERT INTO dbo.VS_KPIUSERS(KPU_KPIID,KPU_USERID,KPU_ORDER, KPU_SHOW_WHEN_ZERO)
			SELECT KPU_KPIID,@c_Userid,KPU_ORDER, KPU_SHOW_WHEN_ZERO FROM dbo.VS_KPIUSERS (nolock) WHERE KPU_USERID = @KPIUserID;
        
        FETCH NEXT FROM users_cursor
        INTO @c_Userid
    END
    CLOSE users_cursor
    DEALLOCATE users_cursor
 
    WHILE @@TRANCOUNT>0 COMMIT TRAN
    return
    
    end_error:
	    IF @@TRANCOUNT>0 ROLLBACK TRAN
	    raiserror(@Mes,16,1)
END
GO