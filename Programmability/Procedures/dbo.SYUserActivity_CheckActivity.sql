SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_CheckActivity](
  @UserID nvarchar(30),
	@SessionID nvarchar(50),
	@Status int = 0 OUT,
  @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
  SELECT @Status = COUNT(*) FROM SYUserActivity WHERE [UserID] = @UserID
	IF @Status = 0
		RETURN
	ELSE
	BEGIN
		SELECT @Status = COUNT(*) FROM SYUserActivity WHERE [UserID] = @UserID AND SessionID = @SessionID
		IF @Status = 0
			SET @Status = 2
		ELSE
			SET @Status = 1
	END
GO