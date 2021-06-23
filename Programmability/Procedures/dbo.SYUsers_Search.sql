SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUsers_Search](
    @UserID nvarchar(30),
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

    SELECT
        UserID, UserName, Password, PIN, UserSignature,
        Admin, DefWorkerID, Module, DepartmentID, ASOID,
        Email, ScheduleFlags, NoActive, UserGroupID, SiteID,
        MessageRights, MessagePhone, MessageEmail, LangID, DefUrl,
		PasswordLastChange, AccountExpirationDate, FileID,
		DateLocked, Violations, LastSuccessfulLogin, LastFailedLogin, ADLogin, ManageDataSpy,LoginWith2fa
    FROM SYUsers
            /* WHERE UserName = @UserName AND Password = @Password AND PIN = @PIN AND UserSignature = @UserSignature AND Admin = @Admin AND
            DefWorkerID = @DefWorkerID AND Module = @Module AND DepartmentID = @DepartmentID AND ASOID = @ASOID AND Email = @Email AND
            ScheduleFlags = @ScheduleFlags AND NoActive = @NoActive AND UserGroupID = @UserGroupID AND SiteID = @SiteID AND MessageRights = @MessageRights AND
            MessagePhone = @MessagePhone AND MessageEmail = @MessageEmail AND LangID = @LangID AND DefUrl = @DefUrl AND PasswordLastChange = @PasswordLastChange AND
            FileID = @FileID*/
GO