SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_RefreshLastActivity](
  @UserID nvarchar(30),
	@SessionID nvarchar(50),
	@Status int = 0 OUT,
  @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

  UPDATE SYUserActivity
  SET LastUpdate = GetDate()
  WHERE [UserID] = @UserID AND SessionID = @SessionID
  
  IF @@ROWCOUNT = 1
 	 RETURN
  ELSE
	 SET @Status = 1

GO