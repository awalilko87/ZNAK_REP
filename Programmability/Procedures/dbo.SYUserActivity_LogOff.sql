SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_LogOff](
  @UserID nvarchar(30),
	@SessionID nvarchar(50),
  @OptionalInfo nvarchar(200) = ''
)
WITH ENCRYPTION
AS
	SET @OptionalInfo = N'Logoff' + @OptionalInfo
	EXEC SYLog_Add @UserID = @UserID, @Operation=@OptionalInfo, @SessionID = @SessionID
  
  DELETE FROM SYUserActivity WHERE [UserID] = @UserID
  
GO