SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SYUserActivity_Update](
    @ID int OUT,
    @UserID nvarchar(30),
    @Login datetime,
    @SessionID nvarchar(50),
    @lSid int,
    @_USERID_ nvarchar(30) = null
)
WITH ENCRYPTION
AS

IF NOT EXISTS (SELECT * FROM SYUserActivity WHERE [ID] = @ID)
BEGIN
    INSERT INTO SYUserActivity(
        ID, UserID, Login, SessionID, lSid /*, _USERID_ */ )
    VALUES (
        @ID, @UserID, @Login, @SessionID, @lSid /*, p_USERID_ */ )
    SET @ID = @@IDENTITY
END
ELSE
BEGIN
    UPDATE SYUserActivity 
    SET UserID = @UserID, Login = @Login, SessionID = @SessionID, lSid = @lSid /* , _USERID_ = @_USERID_ */ 
    WHERE ID = @ID
END
GO