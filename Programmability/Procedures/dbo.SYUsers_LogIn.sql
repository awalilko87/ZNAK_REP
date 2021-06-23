SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUsers_LogIn](
  @UserID nvarchar(30),
  @Pass nvarchar(50),
  @OptionalInfo nvarchar(200) = '',
  @SessionID nvarchar(50) = null,
  @IsADLogin bit = 0,
  @AppCode nvarchar(30),
  @Status int OUT
)
WITH ENCRYPTION
AS
  /*
  DEAKTYWACJA KONTA JEŚLI NIEAKTYWNE PRZE OKREŚLNY OKRES CZASU
  */
  DECLARE @DEACT_ACNT_IF_NO_ACT_PARAM NVARCHAR(50)
  DECLARE @DEACT_ACNT_PERIOD_PARAM NVARCHAR(50)
  DECLARE @DEACT_ACNT_EXPIRED_PARAM NVARCHAR(50)

  SET @DEACT_ACNT_PERIOD_PARAM = @AppCode + '_DEACTIVATE_IF_NO_ACTIVITY_PERIOD'
  SET @DEACT_ACNT_EXPIRED_PARAM = 'CHECK_EXPIRED_ACCOUNTS_ON_LOGIN'

  IF NOT EXISTS (SELECT null FROM SYSettings WHERE KeyCode = @DEACT_ACNT_PERIOD_PARAM)
	INSERT SYSettings (KeyCode, ModuleCode, SettingValue, Description)
	VALUES (@DEACT_ACNT_PERIOD_PARAM, 'VISION', '0', N'Deaktywacja konta po nielogowaniu się przez określną liczbę dni.')

  IF NOT EXISTS (SELECT null FROM SYSettings WHERE KeyCode = @DEACT_ACNT_EXPIRED_PARAM)
	INSERT SYSettings (KeyCode, ModuleCode, SettingValue, Description)
	VALUES (@DEACT_ACNT_EXPIRED_PARAM, 'VISION', '0', N'Deaktywacja konta po przekroczeniu daty ważności.')
	
  IF EXISTS (SELECT NULL FROM SYSettings WHERE KeyCode = @DEACT_ACNT_PERIOD_PARAM AND ISNUMERIC(SettingValue) = 1 and isnull(SettingValue,'0') <> '0')
  BEGIN
	update SYUsers 
    set NoActive = 1,
        DateLocked = GETDATE()
    where datediff(day, coalesce(LastSuccessfulLogin, CreatedOn) ,getdate()) >= (select top 1 Cast(SettingValue as int) from SYSettings where KeyCode = @DEACT_ACNT_PERIOD_PARAM)
	and isnull([Admin],0) = 0
	and coalesce(LastSuccessfulLogin, CreatedOn) is not null
	and coalesce(NoActive,0) = 0
    and UserID = @UserID
  END  
  /* Deaktywacja przeterminowanych kont
	 przeniesione z hardkoded login.aspx
   */
  ELSE IF EXISTS (select null from dbo.SYSettings where KeyCode = @DEACT_ACNT_EXPIRED_PARAM and cast(SettingValue as nvarchar(30)) = N'1')
  BEGIN
    update SYUsers 
    set NoActive = 1,
        DateLocked = GETDATE() 
    where isnull(NoActive,0) = 0
    and AccountExpirationDate < getdate()
    and UserID = @UserID
  END

	DECLARE @lPass nvarchar(50),
	        @noActive bit, 
	        @dateLocked datetime,
	        @secAccountViolationsStr varchar(100),
	        @secAccountViolations int,
	        @violations int
	
	IF @IsADLogin = 1
	BEGIN
		SELECT @UserID = UserID FROM SYUsers WHERE ADLogin = @UserID
	END

	SELECT @dateLocked = DateLocked FROM SYUsers WHERE UserID = @UserID
	IF (@dateLocked IS NULL OR (@dateLocked > getdate()))
	BEGIN
		
		DECLARE @CRPass nvarchar(50), @PType nvarchar(50)
		SELECT @PType = ISNULL(SettingValue, '') FROM SYSettings WHERE ModuleCode='VISION' AND KeyCode='PTYPE'

		IF (len(@Pass) = 0) AND (@IsADLogin = 0)
		BEGIN
			SELECT TOP 0 * FROM SYUsers WHERE UserID = -1
			RETURN
		END
	    
		IF @PType = '' OR @PType IS NULL OR @PType = 'SZEOR'
			SET @CRPass = @Pass
		IF @PType = 'P1'
			SET @CRPass = dbo.P1(@Pass)
		IF @PType = 'D7i'
			SET @CRPass = dbo.Pass_D7i(@Pass)
		IF @PType = 'MP2'
			SET @CRPass = dbo.Pass_MP2(@Pass)
		IF @PType = 'SHA1'
			SET @CRPass = dbo.VS_EncryptPasswordSHA1(@Pass)
		IF @IsADLogin = 1
			SET @CRPass = ''
		
		SELECT @lPass = [Password] FROM SYUsers WHERE UserID = @UserID
		IF (@lPass = '') AND (@IsADLogin =0)
			UPDATE SYUsers SET [Password] = @CRPass WHERE UserID = @UserID

		IF @IsADLogin = 1
		BEGIN
			SELECT @noActive = NoActive FROM SYUsers WHERE UserID = @UserID
		END
		ELSE
		BEGIN
			SELECT @noActive = NoActive FROM SYUsers WHERE UserID = @UserID AND [Password] = @CRPass
		END
		SELECT @violations = Violations FROM SYUsers WHERE UserID = @UserID
		SELECT @secAccountViolationsStr = SettingValue FROM SYSettings WHERE KeyCode = 'SEC_ACCOUNT_VIOLATIONS'
		SET @secAccountViolations = cast(@secAccountViolationsStr as int)
		
		IF @IsADLogin = 1
			SELECT * FROM SYUsers WHERE UserID = @UserID
		ELSE
			SELECT * FROM SYUsers WHERE UserID = @UserID AND [Password] = @CRPass
			
		IF (@@ROWCOUNT = 1 AND @noActive = 0)
		BEGIN
			SET @Status = 0
			SET @OptionalInfo = N'Login' + @OptionalInfo
			
			--Data ostatniego udanego logowania
			--Zerowanie liczby nie udanych logowań
			IF @IsADLogin = 1
			BEGIN
				UPDATE SYUsers
				SET LastSuccessfulLogin = GetDate()
					, Violations = 0
				WHERE UserID = @UserID 
			END
			ELSE
			BEGIN
				UPDATE SYUsers
				SET LastSuccessfulLogin = GetDate()
					, Violations = 0
				WHERE UserID = @UserID AND [Password] = @CRPass
			END
		END
		ELSE
		BEGIN
		  IF (@noActive = 0 OR @noActive IS NULL)
		  BEGIN
			SET @violations = @violations + 1
			IF (@secAccountViolations = 0 OR (@violations < @secAccountViolations))
			BEGIN
				SET @Status = 1
				SET @OptionalInfo = N'Login failed' + @OptionalInfo

				--Data ostatniego nie udanego logowania
				--Liczba nie udanych logowań
				UPDATE  SYUsers
				SET LastFailedLogin = GetDate()
					, Violations = @violations
				WHERE UserID = @UserID   
			END		
			ELSE IF (@violations >= @secAccountViolations)
			BEGIN
				SET @Status = 3
				SET @OptionalInfo = N'Login failed [Violations]' + @OptionalInfo
				
				--Data ostatniego nie udanego logowania
				--Liczba nie udanych logowań
				--Data zablokowania konta
				UPDATE  SYUsers
				SET LastFailedLogin = GetDate()
					, Violations = @violations
					, DateLocked = GetDate()
				WHERE UserID = @UserID   
			END	
			
		  END
		  ELSE IF (@noActive = 1)
		  BEGIN
			SET @Status = 2
			SET @OptionalInfo = N'Login failed [NoActive]' + @OptionalInfo
		  END
		END
	END
	ELSE
	BEGIN
		SET @Status = 3
		SET @OptionalInfo = N'Login failed [Violations]' + @OptionalInfo
		
		SELECT TOP 0 * FROM SYUsers WHERE UserID = -1
		RETURN
	END
	
	exec SYLog_Add @UserID = @UserID, @Operation=@OptionalInfo, @SessionID = @SessionID
GO