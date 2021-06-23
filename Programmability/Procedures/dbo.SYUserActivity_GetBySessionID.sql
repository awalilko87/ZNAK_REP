SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_GetBySessionID](
    @SessionID nvarchar(50) = null
)
WITH ENCRYPTION
AS
    SELECT ID, UserID, Login, SessionID, lSid /*, _USERID_ */ 
    FROM SYUserActivity
    WHERE SessionID = @SessionID
GO