SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUsers_LoginStatus](@UserID nvarchar(30), @Status int OUT)
WITH ENCRYPTION
AS
	DECLARE @DateLocked datetime
	SELECT @DateLocked = DateLocked FROM SYUsers WHERE UserID = @UserID
		
	IF @DateLocked IS NULL
		SET @Status = 0
	ELSE
		SET @Status = 1
GO