SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SYUserActivity_CheckTimeout](
  @UserID nvarchar(30),
	@SessionID nvarchar(50),
	@Timeout int,
	@Status int = 0 OUT
)
WITH ENCRYPTION
AS
	DECLARE @last datetime
	
	SELECT @last = DATEADD(SECOND, @Timeout * 60, LastUpdate) FROM SYUserActivity  WHERE [UserID] = @UserID AND SessionID = @SessionID

	IF @last IS NULL
	BEGIN
		SET @Status = 0
	END
	ELSE IF @last< GetDate()
	BEGIN
		SET @Status = 1
	END
	ELSE
	BEGIN
		SET @Status = 0
	END
GO