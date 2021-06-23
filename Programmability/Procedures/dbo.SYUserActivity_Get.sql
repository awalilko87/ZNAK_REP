SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_Get](
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT ID, UserID, Login, SessionID, lSid /*, _USERID_ */ 
    FROM SYUserActivity
GO