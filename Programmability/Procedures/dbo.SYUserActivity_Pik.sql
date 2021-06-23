SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_Pik](
  @UserID nvarchar(30),
  @SessionID nvarchar(50)
)

AS	
	Declare @Status int = (SELECT IsAutoRefresh FROM SYUserActivity WHERE [UserID] = @UserID AND SessionID = @SessionID)
	IF @Status = 0 or @Status = 2
	BEGIN
		  UPDATE dbo.SYUserActivity SET LastUpdate = getdate() WHERE [UserID] = @UserID AND SessionID = @SessionID
		RETURN
	END	
	ELSE
	BEGIN
		  UPDATE dbo.SYUserActivity SET IsAutoRefresh = 0 WHERE [UserID] = @UserID AND SessionID = @SessionID
	END
GO