SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_DuplicateSessionID](
  @UserID nvarchar(30),
	@SessionID nvarchar(50)
)
WITH ENCRYPTION
AS
  DECLARE @OptionalInfo nvarchar(50)
	SET @OptionalInfo = N'DuplicateSessionID'
	EXEC SYLog_Add @UserID = @UserID, @Operation = @OptionalInfo, @SessionID = @SessionID
GO