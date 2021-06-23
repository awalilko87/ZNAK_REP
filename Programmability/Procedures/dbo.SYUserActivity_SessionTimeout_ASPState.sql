SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_SessionTimeout_ASPState](
	@SessionID nvarchar(50)
)
WITH ENCRYPTION
AS
	if ISNULL(@SessionID,'') = ''
		return 0
		
	DECLARE @OptionalInfo nvarchar(50)
	DECLARE @UserID nvarchar(30)
	
	SET @OptionalInfo = N'STATE Server SessionTimeout'

	SELECT @UserID = UserID from dbo.SYUserActivity where [SessionID] = @SessionID

	DELETE FROM dbo.SYUserActivity WHERE [SessionID] = @SessionID

	EXEC SYLog_Add @UserID = @UserID, @Operation = @OptionalInfo, @SessionID = @SessionID
GO