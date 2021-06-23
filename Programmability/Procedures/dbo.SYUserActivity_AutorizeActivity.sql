SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SYUserActivity_AutorizeActivity](
  @UserID nvarchar(30),
  @SessionID nvarchar(50),
  @Status int OUT,
  @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

if @UserID = 'SA'
begin
	SET @Status = 0
	return
end

DECLARE @ID int,
		@LT varchar(30),
		@LC int, 
		@LCP int,
		@Lu int,	
		@text nvarchar(255),
		@KeyCode nvarchar(50),
		@ModuleCode nvarchar(50),
		@Description nvarchar(50),
		
		@LT_KeyCode nvarchar(50),
		@LT_Hash varchar(255),
		@LT_Hash_Varb varbinary(255),
		@LC_Hash varchar(255),
		@LC_Hash_Varb varbinary(255),
		@LCP_KeyCode nvarchar(50),
		@LCP_Hash varchar(255),
		@LCP_Hash_Varb varbinary(255),
		@GroupType nvarchar(50),
		@Typ2 nvarchar(50),
		@UserGroupID nvarchar(20),
		@UserGroupID2 nvarchar(50),
		@Typ_Hash varchar(255),
		@Typ_Hash_Varb varbinary(255),
		@GroupID_Hash varchar(255),
		@GroupID_Hash_Varb varbinary(255),
		@Check_Configuration nvarchar(30)
		
IF NOT EXISTS (SELECT * FROM SYUserActivity WHERE [UserID] = @UserID)
BEGIN
	SELECT @Check_Configuration = SettingValue FROM SYSettings WHERE KeyCode='SEC_CHECK_CONFIGURATION' AND ModuleCode='VISION'
	SELECT @LT = SettingValue FROM SYSettings WHERE KeyCode='LT' AND ModuleCode='VISION'
	EXEC SYSettings_Get_int_ByID @KeyCode='LC', @ModuleCode='VISION', @Val = @LC OUT
	EXEC SYSettings_Get_int_ByID @KeyCode='LCP', @ModuleCode='VISION', @Val = @LCP OUT
	SET @ModuleCode = 'VISION'
		
	IF (@Check_Configuration = 1)
	BEGIN	
		SET @LT_KeyCode = 'LT'
		SET @text = @LT_KeyCode + @ModuleCode + @LT
		SET @LT_Hash_Varb = HashBytes('MD5', @text)	
		SET @Description =  (SELECT Description FROM SYSettings WHERE KeyCode = 'LT' AND ModuleCode = 'VISION')
		SET @Description = UPPER(@Description)
		SET @LT_Hash = UPPER(sys.fn_varbintohexstr(@LT_Hash_Varb))
		IF (@LT_Hash <> @Description) 
		BEGIN
			SET @Status = 3
			RETURN
		END
			
		IF (@LT = 'R')
		BEGIN
			SET @KeyCode = 'LC'
			SET @text = @KeyCode + @ModuleCode + Convert(nvarchar(50), @LC)
			SET @LC_Hash_Varb = HashBytes('MD5', @text)
			SET @Description =  (SELECT Description FROM SYSettings WHERE KeyCode = 'LC' AND ModuleCode = 'VISION')
			SET @Description = UPPER(@Description)
			SET @LC_Hash = UPPER(sys.fn_varbintohexstr(@LC_Hash_Varb))
			IF (@LC_Hash <> @Description) 
			BEGIN
				SET @Status = 3
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
				SET @Status = 3
				RETURN
			END
				
			SELECT @GroupType = ISNULL(g.Typ,''), @Typ2 = ISNULL(g.Typ2,''), @UserGroupID = ISNULL(u.UserGroupID,''), 
				@UserGroupID2 = ISNULL(u.UserGroupID2,'') FROM SYGroups g, SYUsers u
			WHERE g.GroupID = u.UserGroupID AND u.UserID = @UserID
			SET @text = @UserGroupID + @ModuleCode + @GroupType
			SET @Typ_Hash_Varb = HashBytes('MD5', @text)
			SET @Typ_Hash = UPPER(sys.fn_varbintohexstr(@Typ_Hash_Varb))
			IF @Typ2 <> @Typ_Hash
			BEGIN
				SET @Status = 4
				RETURN
			END
			
			SET @text = UPPER(@UserID + @ModuleCode + @UserGroupID)
			SET @GroupID_Hash_Varb = HashBytes('MD5', @text)
			SET @GroupID_Hash = UPPER(sys.fn_varbintohexstr(@GroupID_Hash_Varb))
			IF @UserGroupID2 <> @GroupID_Hash
			BEGIN
				SET @Status = 5
				RETURN
			END
			IF @GroupType = 'PE'
			BEGIN
				SELECT @Lu = @LC - COUNT(*) 
				FROM SYUserActivity ua, SYUsers u, SYGroups g
				WHERE ua.UserID = u.UserID AND u.UserGroupID = g.GroupID AND g.Typ = 'PE'
				 AND u.UserID <> 'SA'
				IF @Lu < 1
				BEGIN
					SET @Status = 2
					RETURN
				END
				SET @Status = 0
			END
			ELSE IF @GroupType = 'PR'
			BEGIN
				SELECT @Lu = @LCP - COUNT(*) 
				FROM SYUserActivity ua, SYUsers u, SYGroups g
				WHERE ua.UserID = u.UserID AND u.UserGroupID = g.GroupID AND g.Typ = 'PR'
				 AND u.UserID <> 'SA'
				IF @Lu < 1
				BEGIN
					SET @Status = 2
					RETURN
				END
				SET @Status = 0
			END
		END
		ELSE IF (@LT = 'N')
		BEGIN
			IF @GroupType = 'PE'
			BEGIN			
				SELECT @Lu = @LC - COUNT(*) 
				FROM SYUsers u, SYGroups g
				WHERE u.UserGroupID = g.GroupID AND g.Typ = 'PE'
				 AND u.UserID <> 'SA' AND u.NoActive = 0				 
				IF @Lu < 0
				BEGIN
					SET @Status = 6
					RETURN
				END
				SET @Status = 0
			END
			ELSE IF @GroupType = 'PR'
			BEGIN
				SELECT @Lu = @LCP - COUNT(*) 
				FROM SYUsers u, SYGroups g
				WHERE u.UserGroupID = g.GroupID AND g.Typ = 'PR'
				 AND u.UserID <> 'SA' AND u.NoActive = 0
				IF @Lu < 0
				BEGIN
					SET @Status = 6
					RETURN
				END
				SET @Status = 0
			END
		END
		ELSE
		BEGIN
			SET @Status = 0
	    END	
	END
	ELSE
		SET @Status = 0
  
  IF (@Status = 0)
  BEGIN
	  INSERT INTO SYUserActivity(UserID, Login, SessionID, lSid,IsAutoRefresh)
	  VALUES (UPPER(@UserID), getDate(), @SessionID, @@SPID,0)
	  SET @ID = @@IDENTITY
	END
END
ELSE
BEGIN
    SET @Status = 1
END

GO