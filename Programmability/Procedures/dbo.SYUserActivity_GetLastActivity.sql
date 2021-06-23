SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_GetLastActivity](
  @UserID nvarchar(30),
  @SessionID nvarchar(50),
  @LastUpdate datetime = null OUT,
  @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS
 
  SET @LastUpdate = (select LastUpdate from SYUserActivity
  WHERE [UserID] = @UserID AND SessionID = @SessionID)  

GO