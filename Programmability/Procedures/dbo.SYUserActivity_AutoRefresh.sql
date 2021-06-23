SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_AutoRefresh](
 @UserID nvarchar(30),
 @SessionID nvarchar(50),
 @Status int OUT
)
WITH ENCRYPTION
AS
	  SET @Status = (SELECT IsAutoRefresh FROM SYUserActivity WHERE [UserID] = @UserID AND SessionID = @SessionID)

GO