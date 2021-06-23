SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_GetByUser](
    @UserID nvarchar(30)
)
WITH ENCRYPTION
AS

    SELECT TOP 1 ID, UserID, Login, SessionID, lSid 
    FROM SYUserActivity
    WHERE UserID = @UserID
    ORDER BY Login
GO