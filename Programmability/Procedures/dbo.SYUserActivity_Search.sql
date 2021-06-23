SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_Search](
    @ID int,
    @UserID nvarchar(30),
    @Login datetime,
    @SessionID nvarchar(50),
    @lSid int,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

    SELECT ID, UserID, Login, SessionID, lSid /*, _USERID_ */ 
    FROM SYUserActivity
    /* WHERE UserID = @UserID AND Login = @Login AND SessionID = @SessionID AND lSid = @lSid /*  AND _USERID_ = @_USERID_ */ */
GO