SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUsers_Update](
    @UserID nvarchar(30) OUT,
    @UserName nvarchar(100),
    @Password nvarchar(50),
    @PIN nvarchar(4),
    @UserSignature nvarchar(100),
    @Admin bit,
    @DefWorkerID nvarchar(30),
    @Module nvarchar(20),
    @DepartmentID nvarchar(50),
    @ASOID nvarchar(20),
    @Email nvarchar(80),
    @ScheduleFlags int,
    @NoActive bit,
    @UserGroupID nvarchar(20),
    @SiteID nvarchar(50),
    @MessageRights bigint,
    @MessagePhone nvarchar(50),
    @MessageEmail nvarchar(50),
    @LangID nvarchar(10),
    @DefUrl nvarchar(1000),
    @PasswordLastChange datetime,
    @AccountExpirationDate datetime,
    @FileID nvarchar(50) = null,
    @DateLocked datetime,
	@Violations int,
	@LastSuccessfulLogin datetime,
	@LastFailedLogin datetime,
	@ADLogin nvarchar(30),
	@ManageDataSpy bit
)
WITH ENCRYPTION
AS
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
		@Count int,
		@Typ_Hash varchar(255),
		@Typ_Hash_Varb varbinary(255),
		@GroupID_Hash varchar(255),
		@GroupID_Hash_Varb varbinary(255)

IF @UserID is null
    SET @UserID = NewID()
IF @UserID =''
    SET @UserID = NewID()
    
	SET @ModuleCode = 'VISION'
	
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
		RAISERROR('Parametr konfiguracyjny został zmodyfikowany', 16, -1)
		RETURN
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
			RAISERROR('Parametr konfiguracyjny został zmodyfikowany', 16, -1)
			RETURN
		END
		
		SET @LCP_KeyCode = 'LCP'
		SET @text = @LCP_KeyCode + @ModuleCode + Convert(nvarchar(50), @LCP)
		SET @LCP_Hash_Varb = HashBytes('MD5', @text)	
		SET @Description =  (SELECT Description FROM SYSettings WHERE KeyCode = 'LCP' AND ModuleCode = 'VISION')
		SET @Description = UPPER(@Description)
		SET @LCP_Hash = UPPER(sys.fn_varbintohexstr(@LCP_Hash_Varb))
		IF (@LCP_Hash <> @Description) 
		BEGIN
			RAISERROR('Parametr konfiguracyjny został zmodyfikowany', 16, -1)
			RETURN
		END

		SELECT @Typ = ISNULL(Typ,''), @Typ2 = ISNULL(Typ2,'') FROM SYGroups (NOLOCK) WHERE GroupID = @UserGroupID
		SET @text = @UserGroupID + @ModuleCode + @Typ
		SET @Typ_Hash_Varb = HashBytes('MD5', @text)
		SET @Typ_Hash = UPPER(sys.fn_varbintohexstr(@Typ_Hash_Varb))
		IF @Typ2 <> @Typ_Hash
		BEGIN
			RAISERROR('Typ grupy został zmodyfikowany', 16, -1)
			RETURN
		END
		
		IF @Typ = 'PE'
		BEGIN
			SELECT @Count = COUNT(*) FROM SYUsers u, SYGroups g 
				WHERE u.UserGroupID = g.GroupID AND g.Typ = @Typ
			IF @Count >= @LC
			BEGIN
				RAISERROR('Brak wolnych licencji', 16, -1)
				RETURN
			END
		END
		IF @Typ = 'PR'
		BEGIN
			SELECT @Count = COUNT(*) FROM SYUsers u, SYGroups g 
				WHERE u.UserGroupID = g.GroupID AND g.Typ = @Typ
			IF @Count >= @LCP
			BEGIN
				RAISERROR('Brak wolnych licencji', 16, -1)
				RETURN
			END
		END
	END

IF NOT EXISTS (SELECT * FROM SYUsers WHERE UserID = @UserID)
BEGIN
    INSERT INTO SYUsers(
        UserID, UserName, Password, PIN, UserSignature,
        Admin, DefWorkerID, Module, DepartmentID, ASOID,
        Email, ScheduleFlags, NoActive, UserGroupID, SiteID,
        MessageRights, MessagePhone, MessageEmail, LangID, DefUrl,
		PasswordLastChange, AccountExpirationDate, FileID,
		DateLocked, Violations, LastSuccessfulLogin, LastFailedLogin, ADLogin, ManageDataSpy,
		CreatedOn)
    VALUES (
        @UserID, @UserName, @Password, @PIN, @UserSignature,
        @Admin, @DefWorkerID, @Module, @DepartmentID, @ASOID,
        @Email, @ScheduleFlags, @NoActive, @UserGroupID, @SiteID,
        @MessageRights, @MessagePhone, @MessageEmail, @LangID, @DefUrl,
		@PasswordLastChange, @AccountExpirationDate, @FileID,
		@DateLocked, @Violations, @LastSuccessfulLogin, @LastFailedLogin, @ADLogin, @ManageDataSpy, 
		getdate())
END
ELSE
BEGIN
IF (@Password <> '') BEGIN
    UPDATE SYUsers SET
        UserName = @UserName, Password = @Password, PIN = @PIN, UserSignature = @UserSignature, Admin = @Admin,
        Email = @Email, ScheduleFlags = @ScheduleFlags, NoActive = @NoActive, UserGroupID = @UserGroupID, MessageRights = @MessageRights,
        MessagePhone = @MessagePhone, MessageEmail = @MessageEmail, DefWorkerID = @DefWorkerID, Module = @Module, DepartmentID = @DepartmentID,
        ASOID = @ASOID, SiteID = @SiteID, LangID = @LangID, DefUrl = @DefUrl, PasswordLastChange = @PasswordLastChange,
        AccountExpirationDate = @AccountExpirationDate, FileID = @FileID,
        DateLocked = @DateLocked, Violations = @Violations, LastSuccessfulLogin = @LastSuccessfulLogin, 
        LastFailedLogin = @LastFailedLogin, ADLogin = @ADLogin, ManageDataSpy = @ManageDataSpy,
        [UserGroupID2] = UPPER(sys.fn_varbintohexstr(HashBytes('MD5',@UserID+'VISION'+@UserGroupID)))
        WHERE UserID = @UserID
END ELSE BEGIN
    UPDATE SYUsers SET
        UserName = @UserName, PIN = @PIN, UserSignature = @UserSignature, Admin = @Admin,
        DefWorkerID = @DefWorkerID, Module = @Module, DepartmentID = @DepartmentID, ASOID = @ASOID, Email = @Email,
        ScheduleFlags = @ScheduleFlags, NoActive = @NoActive, UserGroupID = @UserGroupID, SiteID = @SiteID,
        MessageRights = @MessageRights, MessagePhone = @MessagePhone, MessageEmail = @MessageEmail, LangID = @LangID, DefUrl = @DefUrl,
		PasswordLastChange = @PasswordLastChange, 
		AccountExpirationDate = @AccountExpirationDate, FileID = @FileID,
		DateLocked = @DateLocked, Violations = @Violations, LastSuccessfulLogin = @LastSuccessfulLogin,
		LastFailedLogin = @LastFailedLogin, ADLogin = @ADLogin, ManageDataSpy = @ManageDataSpy,
		[UserGroupID2] = UPPER(sys.fn_varbintohexstr(HashBytes('MD5',@UserID+'VISION'+@UserGroupID)))
    WHERE UserID = @UserID
END
END
GO