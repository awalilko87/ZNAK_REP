SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_CheckUniqueSessionID](
 @UserID nvarchar(30),
 @SessionID nvarchar(50),
 @Status int OUT
)
WITH ENCRYPTION
AS
	IF NOT EXISTS(SELECT * FROM SYUserActivity WHERE [UserID] <> @UserID AND SessionID = @SessionID)
	  SET @Status = 0
	ELSE
	  SET @Status = 1  

GO