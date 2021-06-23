SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SYS_USERS_Update_New](
	@Admin bit = NULL,
	@OLD_Admin bit = NULL,
	@DefUrl nvarchar(1000) = NULL,
	@OLD_DefUrl nvarchar(1000) = NULL,
	@DefWorker nvarchar(30) = NULL,
	@OLD_DefWorker nvarchar(30) = NULL, 
	@DepartmentID nvarchar(200) = NULL,
	@OLD_DepartmentID nvarchar(200) = NULL,
	@Email nvarchar(80) = NULL,
	@OLD_Email nvarchar(80) = NULL,
	@InternalPhoneNumber int = NULL,
	@OLD_InternalPhoneNumber int = NULL,
	@LangID nvarchar(50) = NULL,
	@OLD_LangID nvarchar(50) = NULL,
	@MessagePhone nvarchar(50) = NULL,
	@OLD_MessagePhone nvarchar(50) = NULL,
	@NoActive bit = NULL,
	@OLD_NoActive bit = NULL,
	@PasswordLastChange datetime = NULL,
	@OLD_PasswordLastChange datetime = NULL,
	@SiteID nvarchar(20) = NULL,
	@OLD_SiteID nvarchar(20) = NULL,
	@UserGroupID nvarchar(20) = NULL,
	@OLD_UserGroupID nvarchar(20) = NULL,
	@UserID nvarchar(30) = NULL,
	@OLD_UserID nvarchar(30) = NULL,
	@UserName nvarchar(100) = NULL,
	@OLD_UserName nvarchar(100) = NULL,
	@UserSignature nvarchar(100) = NULL,
	@OLD_UserSignature nvarchar(100) = NULL, 
	@MobileUser bit,
	@MobileAuthUser bit,
	@ADLogin nvarchar(30), 
	@_UserID varchar(30), 
	@_GroupID nvarchar(20), 
	@_LangID varchar(10),
	@User_STNID int
)
WITH ENCRYPTION
AS
BEGIN TRAN 

	DECLARE @Msg nvarchar(500), @IsErr bit
	SELECT @Msg = '', @IsErr = 0 
	DECLARE @mOrgGuid uniqueidentifier
	DECLARE @mUserGuid uniqueidentifier
	DECLARE @mActionGuid uniqueidentifier
	DECLARE @mActionType nvarchar(30)
	DECLARE @mActionCode nvarchar(30)
	
	DECLARE 
		@Lu int,	
		@text nvarchar(255),
		@KeyCode nvarchar(50),
		@ModuleCode nvarchar(50),
		@Description nvarchar(50),
		@LT nvarchar(30),
		@LT_KeyCode nvarchar(50),
		@LT_Hash varchar(255),
		@LT_Hash_Varb varbinary(255),
		@LC int,
		@LC_KeyCode nvarchar(50),
		@LC_Hash varchar(255),
		@LC_Hash_Varb varbinary(255),
		@LCP int,
		@LCP_KeyCode nvarchar(50),
		@LCP_Hash varchar(255),
		@LCP_Hash_Varb varbinary(255),
		@Typ nvarchar(50),
		@Typ2 nvarchar(50),
		@Count int
				
	SET @ModuleCode = 'VISION'
	IF EXISTS (select null from SYSettings WHERE KeyCode = 'SEC_CHAECK_CONFIGURATION' AND SettingValue = '1') BEGIN
		SELECT @LT = SettingValue FROM SYSettings WHERE KeyCode='LT' AND @ModuleCode='VISION'
		EXEC SYSettings_Get_int_ByID @KeyCode='LC', @ModuleCode='VISION', @Val = @LC OUT
		EXEC SYSettings_Get_int_ByID @KeyCode='LCP', @ModuleCode='VISION', @Val = @LCP OUT

		SET @LT_KeyCode = 'LT'
		SET @text = @LT_KeyCode + @ModuleCode + Convert(nvarchar(50), @LT)
		SET @LT_Hash_Varb = HashBytes('MD5', @text)	
		SET @Description =  (SELECT Description FROM SYSettings WHERE KeyCode = 'LT' AND ModuleCode = 'VISION')
		SET @Description = UPPER(@Description)
		SET @LT_Hash = UPPER(sys.fn_varbintohexstr(@LT_Hash_Varb))
		IF (@LT_Hash <> @Description) 
		BEGIN
			SELECT @Msg = 'Parametr konfiguracyjny został zmodyfikowany [ERROR 1]'
			GOTO ERR
		END
	
		IF (@LT = 'N')
		BEGIN
			SET @LC_KeyCode = 'LC'
			SET @text = @LC_KeyCode + @ModuleCode + Convert(nvarchar(50), @LC)
			SET @LC_Hash_Varb = HashBytes('MD5', @text)	
			SET @Description =  (SELECT Description FROM SYSettings WHERE KeyCode = 'LC' AND ModuleCode = 'VISION')
			SET @Description = UPPER(@Description)
			SET @LC_Hash = UPPER(sys.fn_varbintohexstr(@LC_Hash_Varb))
			IF (@LC_Hash <> @Description) 
			BEGIN
				SELECT @Msg = 'Parametr konfiguracyjny został zmodyfikowany [ERROR 2]'
				GOTO ERR
			END
		
			SET @LCP_KeyCode = 'LCP'
			SET @text = @LCP_KeyCode + @ModuleCode + Convert(nvarchar(50), @LCP)
			SET @LCP_Hash_Varb = HashBytes('MD5', @text)	
			SET @Description =  (SELECT Description FROM SYSettings WHERE KeyCode = 'LCP' AND ModuleCode = 'VISION')
			SET @Description = UPPER(@Description)
			SET @LCP_Hash = UPPER(sys.fn_varbintohexstr(@LCP_Hash_Varb))
			IF (@LCP_Hash <> @Description) 
			BEGIN
				SELECT @Msg = 'Parametr konfiguracyjny został zmodyfikowany [ERROR 3]'
				GOTO ERR
			END

			SELECT @Typ = Typ, @Typ2 = Typ2 FROM SYGroups (NOLOCK) WHERE GroupID = @UserGroupID
			IF @Typ2 <> UPPER(sys.fn_varbintohexstr(HashBytes('MD5',@UserGroupID+'VISION'+@Typ)))
			BEGIN
				SELECT @Msg = 'Typ grupy został zmodyfikowany [ERROR 6]'
				GOTO ERR
			END
		
			IF @Typ = 'PE'
			BEGIN
				SELECT @Count = COUNT(*) FROM SYUsers u, SYGroups g 
					WHERE u.UserGroupID = g.GroupID AND g.Typ = @Typ
				IF @Count >= @LC
				BEGIN
					SELECT @Msg = 'Brak wolnych licencji [ERROR 4]'
					GOTO ERR
				END
			END
			IF @Typ = 'PR'
			BEGIN
				SELECT @Count = COUNT(*) FROM SYUsers u, SYGroups g 
					WHERE u.UserGroupID = g.GroupID AND g.Typ = @Typ
				IF @Count >= @LCP
				BEGIN
					SELECT @Msg = 'Brak wolnych licencji [ERROR 5]'
					GOTO ERR
				END
			END
		END
	END

	/* Error management */
	IF @IsErr = 1
	BEGIN
		SET @Msg = '<b>Komunikat bledu</b>'
		GOTO ERR
	END

	/* Generate number
	IF 1=1 
	DECLARE @RC int, @Type nvarchar(50), @Pref nvarchar(50), @Suff nvarchar(50), @Number nvarchar(50), @No int
	SELECT @Type = 'DOC_TYPE', @Pref = '', @Suff='' /* + CONVERT(nvarchar(4),YEAR(@LOCAL_Date)) */
	EXECUTE @RC = [dbo].[VS_GetNumber] @Type, @Pref, @Suff, @Number OUTPUT, @No OUTPUT
	/* SET @LOCAL_Number = @Number */
	/* SET @LOCAL_No = @No */
	END
	*/

	if not exists (select * from SYUsersv where UserID = @UserID)
	begin
		insert into dbo.SYUsers(
		[Admin], [DefUrl], [DefWorkerID], [DepartmentID], [Email], [InternalPhoneNumber], [LangID], 
		[MessagePhone], [NoActive], [PasswordLastChange], [SiteID], [UserGroupID], [UserID], [UserName], 
		[UserSignature], [Module],/*, [_UserID], [_GroupID], [_LangID]*/
		[MobileUser], [MobileAuthUser], ADLogin, [UserGroupID2], [User_STNID])
		values (
		@Admin, @DefUrl, @DefWorker, @DepartmentID, @Email, @InternalPhoneNumber, @LangID, 
		@MessagePhone, @NoActive, @PasswordLastChange, isnull(@SiteID, ''), @UserGroupID, @UserID, @UserName, 
		@UserSignature, 'ZMT',/*, @_UserID, @_GroupID, @_LangID*/
		@MobileUser, isnull(@MobileAuthUser, 0), @ADLogin, UPPER(sys.fn_varbintohexstr(HashBytes('MD5',@UserID+'VISION'+@UserGroupID))), @User_STNID)
	end 
	else 
	begin 
		update dbo.SYUsers set
			 [Admin] = @Admin
			,[DefUrl] = @DefUrl
			,[DefWorkerID] = @DefWorker
			,[DepartmentID] = @DepartmentID
			,[Email] = @Email
			,[InternalPhoneNumber] = @InternalPhoneNumber
			,[LangID] = @LangID
			,[MessagePhone] = @MessagePhone
			,[NoActive] = @NoActive
			,[PasswordLastChange] = @PasswordLastChange
			,[SiteID] = isnull(@SiteID, '')
			,[UserGroupID] = @UserGroupID
			,[UserID] = @UserID
			,[UserName] = @UserName
			,[UserSignature] = @UserSignature
			,[Module] = 'ZMT'
			,[MobileUser] = isnull(@MobileUser, 0)
			,[MobileAuthUser] = @MobileAuthUser
			,[ADLogin] = @ADLogin
			,[UserGroupID2] = UPPER(sys.fn_varbintohexstr(HashBytes('MD5',@UserID+'VISION'+@UserGroupID)))
			,[User_STNID] = @User_STNID
		where UserID = @UserID
	end  

	--dodanie użytkownika
	IF EXISTS (select object_id from sys.objects where name='MobileUsers' and type='U')
	BEGIN
	    select top 1 @mOrgGuid = rowguid from dbo.MOrg
		if (@MobileUser = 'true')
		begin
			if not exists (select null from dbo.MobileUsers where UserID = @UserID)
			begin
				insert into MobileUsers (UserID, UserName, Module, UserGroupID, [LangID], [Admin], NoActive, orgguid, rowguid)
				select top 1 @UserID, @UserName, 'ZMT', @UserGroupID, 'PL', @Admin, @NoActive, @mOrgGuid, newid()
			end
			else
			begin
				update MobileUsers set UserName = @UserName WHERE UserID = @UserID
			end
		end
		else
		begin
			delete from MobileUsers where UserID = @UserID
		end
	END
	
	/*przeniesione do formatki "Uprawnienia do przyciskoów" w "Administracja Mobile"
	--nadawanie uprawnień do akcji
	select top 1 @mUserGuid = rowguid from MobileUsers where UserID = @UserID
	IF (@MobileUser = 'true' and @MobileAuthUser = 'true')   
	begin	
		declare cr_authactions cursor for select distinct refguid, [type], rightscode from MUserRights
		
		open cr_authactions
		fetch next from cr_authactions into @mActionGuid, @mActionType, @mActionCode
		
		WHILE @@FETCH_STATUS = 0
		begin
			if not exists (select * from MUserRights where UserGuid = @mUserGuid and refguid = @mActionGuid)
			begin
				insert into MUserRights(rowguid, userguid, refguid, [type], rightscode, orgguid)
				select newid(), @mUserGuid, @mActionGuid, @mActionType, @mActionCode, @mOrgGuid
			end
			else
			begin
				update MUserRights set [type] = @mActionType, rightscode = @mActionCode, orgguid = @mOrgGuid where UserGuid = @mUserGuid and refguid = @mActionGuid
			end
			fetch next from cr_authactions into @mActionGuid, @mActionType, @mActionCode
		end 			
		close cr_authactions
		deallocate cr_authactions
	end
	else 
	begin
		delete from MUserRights where UserGuid = @mUserGuid
	end
	delete from MUserRights where UserGuid not in (select rowguid from MobileUsers) or UserGuid is null
	*/

/* Error managment */
IF @@TRANCOUNT>0 COMMIT TRAN
RETURN
ERR:
IF @@TRANCOUNT>0 ROLLBACK TRAN
RAISERROR(@Msg, 16, 1)
GO